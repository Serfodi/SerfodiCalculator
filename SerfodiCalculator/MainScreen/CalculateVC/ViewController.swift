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
    private var historyVC : HistoryViewController!
    
    private var dataProvider: CoreDataProvider!
    
    private let calculator: CalculateManager = Calculator()
    
    private var isNewInput = true
    
    
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
    
    // MARK: addNewExample
    
    private func addNewExample(_ example: Calculation) {
        dataProvider.addCalculate(example)
        guard let section = self.historyVC.table.lastSection else { return }
        let row = self.historyVC.table.numberOfRows(inSection: section)
        self.historyVC.table.performBatchUpdates {
            self.historyVC.table.insertRows(at: [IndexPath(row: row, section: section)], with: .bottom)
        } completion: { _ in
        }
        self.historyVC.table.scrollToBottom(animated: true)
    }
    
    // MARK: Calculator
    
    private func calculateResult(result: (Double)->()) {
        do {
            let number = try calculator.result()
            result(number)
        } catch let error {
            self.errorCalculate(error: error as! CalculationError)
        }
    }
    
    private func resetCalculate(clearLabel: Bool = true) {
        calculator.eraseAll()
        isNewInput = true
        if clearLabel {
            inputLabel.clearInput()
        }
    }
    
    // MARK: Error handler
    
    private func errorCalculate(error: CalculationError) {
        switch error {
        case .dividedByZero, .outOfRang:
            resetCalculate(clearLabel: false)
            inputLabel.showError()
        }
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
            isNewInput = !isNewInput
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
            inputLabel.setTextLabel(number: result)
        }
        isNewInput = true
    }
    
    func equal(_ sender: UIButton) {
        guard let labelNumber = inputLabel.getNumber() else { return }
        
        // Повтор последнего дейсвия при нажатии на равно. Получения числа и опирации.
        if !isNewInput || calculator.countItems == 0 {
            calculator.addNumber(labelNumber)
        }
        if isNewInput && calculator.countItems == 1 {
            // Добавить последнее действие.
            calculator.addLastOperation()
        }
        
        calculateResult { result in
            calculator.removeHistory { calculationItems in
                let calculation = Calculation(expression: calculationItems, result: result)
                self.addNewExample(calculation)
            }
            inputLabel.setTextLabel(number: result)
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

// MARK: Navigation DoneDelegate
extension ViewController: NavigationDoneActionHandler {
    
    func done(_ sender: AnyObject, forEvent event: DoneEvent) {
        guard let navigationController = event.controller.navigationController else { return }
        navigationController.view.layer.animationTransition()
        navigationController.popToRootViewController(animated: false)
        animationTableController()
    }
}

// MARK: Table View delegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animationTableController(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
}

//MARK: - Configuration
private extension ViewController {
    func configurationHistory() {
        historyVC = HistoryViewController()
        addChildVC()
        configurationDataMenager()
        historyVC.table.delegate = self
    }
    
    func addChildVC() {
        addChild(historyVC)
        view.insertSubview(historyVC.view, belowSubview: inputLabel)
        historyVC.pinedVC(parentView: self.view, buttonView: inputLabel)
        didMove(toParent: self)
    }
    
    func configurationDataMenager() {
        let dataMeneger = CoreDataManager.sherd
        dataProvider = CoreDataProvider(historyManager: dataMeneger)
        historyVC.table.dataSource = dataProvider
    }
}


// MARK: - Animation
private extension ViewController {
    func animationTableController(_ indexPath: IndexPath? = nil) {
        switch historyVC.stateVC {
        case true:
            self.view.isUserInteractionEnabled = false
            historyVC.animationClose(indexPath) {
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.3, delay: 0.15, options: .curveEaseInOut) {
                self.mainView.blurBG.alpha = 0
            } completion: { _ in
                self.view.sendSubviewToBack(self.historyVC.view)
                self.mainView.blurBG.isHidden = true
                self.view.isUserInteractionEnabled = true
            }
        case false:
            self.view.isUserInteractionEnabled = false
            self.mainView.blurBG.isHidden = false
            view.bringSubviewToFront(historyVC.view)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.mainView.blurBG.alpha = 1
            } completion: { _ in
                self.view.isUserInteractionEnabled = true
            }
            historyVC.animationOpen {
                self.view.layoutIfNeeded()
            }
        }
    }
}
