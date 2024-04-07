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
    
    private var dataProvider: DataProvider!
    private let calculator = Calculator()
    
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
        historyVC.table.scrollToBottom(animated: false)
    }
    
    private func addNewExample(_ example: Calculation) {
        dataProvider.historyManager.add(calculation: example)
        historyVC.table.reloadData()
        historyVC.table.scrollToBottom(animated: true)
    }
    
    private func calculateResult(result: (Double)->()) {
        do {
            let number = try calculator.calculateResult()
            result(number)
        } catch let error {
            self.errorCalculate(error: error as! CalculationError)
        }
    }
    
    private func resetCalculate(clearLabel: Bool = true) {
        calculator.removeAll()
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
        if !isNewInput || calculator.count == 0 {
            calculator.addNumber(labelNumber)
        }
        calculator.addOperation(buttonOperation)
        calculateResult { result in
            inputLabel.setTextLabel(number: result)
            if buttonOperation.type == .unary {
                calculator.removeHistory { calculationItems in
                    let calculation = Calculation(expression: calculationItems, result: result)
                    self.addNewExample(calculation)
                }
            }
        }
        isNewInput = true
    }
    
    func equal(_ sender: UIButton) {
        guard let labelNumber = inputLabel.getNumber() else { return }
        if !isNewInput || calculator.count == 0 {
            calculator.addNumber(labelNumber)
        } else {
            calculator.removeLastOperation()
        }
        if isNewInput && calculator.count == 1 {
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


// MARK: Table View delegate

extension ViewController: UITableViewDelegate, NavigationDoneDelegate {
        
    func done(to viewController: UIViewController) {
        viewController.navigationController?.view.layer.animationTransition()
        viewController.navigationController?.popToRootViewController(animated: false)
        let historyManager = HistoryManager()
        dataProvider = DataProvider(historyManager: historyManager)
        historyVC.table.dataSource = dataProvider
        historyVC.table.reloadData()
        animationTableController()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        animationTableController(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


private extension ViewController {
    func configurationHistory() {
        historyVC = HistoryViewController()
        addChild(historyVC)
        view.insertSubview(historyVC.view, belowSubview: inputLabel)
        historyVC.pinedVC(parentView: self.view, buttonView: inputLabel)
        didMove(toParent: self)
        let historyManager = HistoryManager()
        dataProvider = DataProvider(historyManager: historyManager)
        historyVC.delegate = self
        historyVC.table.delegate = self
        historyVC.table.dataSource = dataProvider
    }
}


// MARK: - Animation

private extension ViewController {
    
    func animationTableController(_ indexPath: IndexPath? = nil) {
        switch historyVC.stateVC {
        case true:
            historyVC.animationClose(indexPath) {
                self.view.layoutIfNeeded()
            }
            UIView.animate(withDuration: 0.3, delay: 0.15, options: .curveEaseInOut) {
                self.mainView.blurBG.alpha = 0
            } completion: { _ in
                self.view.sendSubviewToBack(self.historyVC.view)
                self.mainView.blurBG.isHidden = true
            }
        case false:
            self.mainView.blurBG.isHidden = false
            view.bringSubviewToFront(historyVC.view)
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                self.mainView.blurBG.alpha = 1
            }
            historyVC.animationOpen {
                self.view.layoutIfNeeded()
            }
        }
    }
}
