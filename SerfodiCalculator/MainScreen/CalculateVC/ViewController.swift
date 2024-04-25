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
    
    var isNewInput = true
    
    // MARK: - Live circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurationHistory()
        numpadController.delegate = self
        inputLabel.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        inputLabel.setTextLabel(number: SettingManager().getEnvironmentSetting().lastResult)
        historyVC.table.scrollToBottom(animated: false)
    }
    
    // MARK: - AddNewExample
    
    func addNewExample(_ example: Calculation) {
        dataProvider.addCalculate(example)
        historyVC.table.animatedInsertLastRow()
    }
    
    // MARK: Calculator
    
    func calculateResult(result: @escaping (Double)->()) {
        Task(priority: .medium) {
            do {
                let number = try await calculator.result()
                result(number)
            } catch let error {
                self.errorCalculate(error: error as! CalculationError)
            }
        }
    }
    
    func resetCalculate(clearLabel: Bool = true) {
        calculator.eraseAll()
        isNewInput = true
        if clearLabel {
            inputLabel.clearInput()
        }
    }
    
    // MARK: Error handler
    
    func errorCalculate(error: CalculationError) {
        switch error {
        case .dividedByZero, .outOfRang:
            resetCalculate(clearLabel: false)
            inputLabel.showError()
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

// MARK: - Calculate
extension ViewController: NumpadDelegate, RemoveLastDigit {
    
    func removeLastDigit() {
        if let _ = inputLabel.getNumber() {
            inputLabel.removeLastDigit()
        } else {
            inputLabel.text = "0"
        }
    }
    
    func number(_ sender: UIButton) {
        
        guard let buttonText = sender.currentTitle,
              let _ = inputLabel.text
        else { return }
        
        guard inputLabel.isCanAddDigit(new: buttonText) || isNewInput else { return }
        
        if isNewInput {
            isNewInput.toggle()
            inputLabel.text = "0"
        }
        inputLabel.inputDigit(add: buttonText) { number in }
    }

    func minusNum(_ sender: UIButton) {
        inputLabel.addMinusNumber()
    }
    
    func operating(_ sender: UIButton) {
        guard let buttonOperation = Operation(rawValue: sender.tag) else { return }
        guard let labelNumber = inputLabel.getNumber() else { return }
        
        if !isNewInput || calculator.countItems == 0 {
            calculator.addNumber(labelNumber)
        }
        
        calculator.addOperation(buttonOperation)
        
        calculateResult { result in
            self.inputLabel.setTextLabel(number: result)
        }
        
        isNewInput = true
    }
    
    func equal(_ sender: UIButton) {
        guard let labelNumber = inputLabel.getNumber() else { return }
        
        if !isNewInput {
            calculator.addNumber(labelNumber)
        }
        if isNewInput && calculator.countItems == 1 {
            calculator.addLastOperation()
        }
        
        calculateResult { result in
            self.calculator.removeHistory { calculationItems in
                let calculation = Calculation(expression: calculationItems, result: result)
                self.addNewExample(calculation)
            }
            self.inputLabel.setTextLabel(number: result)
        }
        isNewInput = true // Новый ввод разрешён
    }

    func reset(_ sender: UIButton) {
        resetCalculate()
    }
}

// MARK: - History Delegate
extension ViewController: SettingActionHandler {
    func eraseData(_ sender: AnyObject, forEvent event: UIEvent) {
        self.historyVC.table.reloadData()
    }
}

// MARK: - Navigation DoneDelegate
extension ViewController: NavigationDoneActionHandler {
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
