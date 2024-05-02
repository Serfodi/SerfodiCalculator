//
//  ViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit

class ViewController: UIViewController {
    
    var mainView: MainView { return self.view as! MainView }
    
    @IBOutlet weak var inputLabel: DisplayLabel!
    @IBOutlet weak var numpadController: NumpadController!
    var historyVC : HistoryViewController!
    
    var dataProvider: CoreDataProvider!
    
    let calculator: CalculateManager = Calculator()
    
    // MARK: - Live circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationHistory()
        numpadController.delegate = self
        inputLabel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputLabel.input(SettingManager().getEnvironmentSetting().lastResult)
        historyVC.table.scrollToBottom(animated: false)
    }
    
    // MARK: - Add new Cell Example
    func addNewExample(_ example: Calculation) {
        dataProvider.addCalculate(example)
        historyVC.table.animatedInsertLastRow()
    }
    
    // MARK: calculate Result
    func calculateResult(isFinal: Bool, result: @escaping (Double)->()) {
        Task(priority: .medium) {
            do {
                let number = try await calculator.result(isFinal: isFinal)
                result(number)
            } catch let error {
                self.errorCalculate(error: error as! CalculationError)
            }
        }
    }
    
    func resetCalculate(clearLabel: Bool = true) {
        calculator.eraseAll()
        if clearLabel {
            inputLabel.clear()
        }
    }
    
    // MARK: Error handler
    func errorCalculate(error: CalculationError) {
        switch error {
        case .dividedByZero, .outOfRang:
            resetCalculate(clearLabel: false)
            inputLabel.showError()
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }
    
    // MARK: Notification
    @objc func showDetail(withNotification notification: Notification ) {
        guard let userInfo = notification.userInfo,
                let indexPath = userInfo["indexPath"] as? IndexPath
        else { fatalError() }
        animationTableController(indexPath)
    }
}


// MARK: - Numpad Delegate, RemoveLastDigit
extension ViewController: NumpadDelegate, RemoveLastDigit {
    
    func removeLastDigit() {
        guard !calculator.isNewInput else { return }
        inputLabel.removeLast()
    }
    
    func number(_ num: String) {
        if calculator.isNewInput {
            calculator.endNewInput()
            inputLabel.clear()
        }
        inputLabel.input(num)
        calculator.addNumber(inputLabel.number!)
    }
    
    func operating(_ operation: Operation) {
        calculator.addOperation(operation)
        calculateResult(isFinal: false) { result in
            self.inputLabel.input(result)
        }
    }
    
    func equal() {
        calculator.repeatsEqual()
        calculateResult(isFinal: true) { result in
            self.inputLabel.input(result)
            self.calculator.equal(result: result) { items in
                self.addNewExample(.init(expression: items, result: result))
            }
        }
    }
    
    func minusNum() {
        inputLabel.inputMinus()
    }
    
    func reset() {
        resetCalculate()
    }
}

// MARK: - Action Handler
extension ViewController: SettingActionHandler, NavigationDoneActionHandler {
    
    func eraseData(_ sender: AnyObject, forEvent event: UIEvent) {
        self.historyVC.table.reloadData()
    }
    
    func done(_ sender: AnyObject, forEvent event: DoneEvent) {
        guard let navigationController = event.controller.navigationController else { return }
        navigationController.view.layer.animationTransition()
        navigationController.popToRootViewController(animated: false)
        animationTableController()
    }
}

//MARK: - Configuration
private extension ViewController {
    func configurationHistory() {
        historyVC = HistoryViewController()
        addChildVC()
        configurationDataMenager()
        NotificationCenter.default.addObserver(self, selector: #selector(showDetail(withNotification:)), name: NSNotification.Name(rawValue: "DidSelectRowAtNotification"), object: nil)
    }
    
    func addChildVC() {
        addChild(historyVC)
        view.insertSubview(historyVC.view, belowSubview: inputLabel)
        historyVC.pinedVC(parentView: self.view, buttonView: inputLabel)
        didMove(toParent: self)
    }
    
    func configurationDataMenager() {
        let dataManager = CoreDataManager.sherd
        dataProvider = CoreDataProvider(historyManager: dataManager)
        historyVC.table.dataSource = dataProvider
        historyVC.table.delegate = dataProvider
    }
}

// MARK: - Animation
extension ViewController {
    func animationTableController(_ indexPath: IndexPath? = nil) {
        switch historyVC.stateVC {
        case true:
            self.view.isUserInteractionEnabled = false
            historyVC.animationClose(indexPath) {
                self.mainView.blurBG.alpha = 0
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.view.sendSubviewToBack(self.historyVC.view)
                self.mainView.blurBG.isHidden = true
                self.view.isUserInteractionEnabled = true
            }
        case false:
            self.view.isUserInteractionEnabled = false
            self.mainView.blurBG.isHidden = false
            self.view.bringSubviewToFront(self.historyVC.view)
            historyVC.animationOpen {
                self.mainView.blurBG.alpha = 1
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.view.isUserInteractionEnabled = true
            }
        }
    }
}
