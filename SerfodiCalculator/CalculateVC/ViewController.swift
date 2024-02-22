//
//  ViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: DisplayLabel!
    @IBOutlet weak var historyTableView: HistoryTableView!
    @IBOutlet weak var numpadController: NumpadController!
    
    public var dataProvider: DataProvider!
    private let calculator = Calculator()
    
    
    /// Индикатор для сигнализации о новом вводе:
    /// `true` – Разрешён новый ввод числа
    /// `false` – Ввод числа завершен
    private var isNewInput = true
    
    
    // MARK: - Live circle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let historyManager = HistoryManager()
        dataProvider = DataProvider()
        dataProvider.historyManager = historyManager
        
        numpadController.delegate = self
        inputLabel.delegate = self
        
        historyTableView.tableView.dataSource = dataProvider
        historyTableView.tableView.delegate = self
        
        resetCalculate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        historyTableView.tableView.showLastCell(animated: false)
        let lastResult = SettingManager.shared.getLastResult
        inputLabel.setTextLabel(number: lastResult)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let number = inputLabel.getNumber() {
            SettingManager.shared.saveLastResult(result: number)
        }
    }
    
    
    private func addNewExample(_ example: Calculation) {
        self.dataProvider.historyManager?.add(calculation: example)
        self.historyTableView.tableView.reloadData()
        self.historyTableView.tableView.showLastCell()
    }
    
    
}


// MARK: - Calculate

extension ViewController {
    
    /// Проивзодит вычисленя результата
    /// В случаии ошибки вызывает функцию `errorCalculate`
    func calculateResult(result: (Double)->()) {
        do {
            let number = try calculator.calculateResult()
            result(number)
        } catch let error {
            self.errorCalculate(error: error as! CalculationError)
        }
    }
    
    // MARK: FIX IT
    
    /*
    добавить операции для одной переменной
     */
    
    /// Обработка ошибок вычислений
    func errorCalculate(error: CalculationError) {
        switch error {
        case .dividedByZero, .outOfRang:
            resetCalculate(clearLabel: false)
            inputLabel.showError()
        }
        
    }
    
    /// Полный сброс калькулятора и вычислений.
    func resetCalculate(clearLabel: Bool = true) {
        calculator.removeAll()
        isNewInput = true
        if clearLabel {
            inputLabel.text = "0"
        }
    }
    
}

extension ViewController: RemoveLastDigit {
    
    func removeLastDigit() {
        if let _ = inputLabel.getNumber() {
            inputLabel.removeLastDigit()
        } else {
            inputLabel.text = "0"
        }
        if let number = inputLabel.getNumber() {
            SettingManager.shared.saveLastResult(result: number)
        }
    }
    
}

extension ViewController: NumpadDelegate {
    
    func number(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let _ = inputLabel.text
        else { return }
        guard inputLabel.isCanAddDigit(new: buttonText) || isNewInput else { return }
        if isNewInput {
            isNewInput = !isNewInput
            inputLabel.text = "0"
        }
        inputLabel.inputDigit(add: buttonText) { number in
            SettingManager.shared.saveLastResult(result: number)
        }
    }

    
    func minusNum(_ sender: UIButton) {
        inputLabel.addMinusNumber()
        SettingManager.shared.saveLastResult(result: inputLabel.getNumber()!)
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
            SettingManager.shared.saveLastResult(result: result)
            if buttonOperation.type() == .unary {
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


// MARK: - Table View delegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.contentView.backgroundColor = .clear
        }
        
        goToSecondViewController()
        
    }
    
    func goToSecondViewController() {
        let storyboard = UIStoryboard(name: "HistoryStoryboard", bundle: nil)
        let nextViewController = storyboard.instantiateViewController(
            withIdentifier: String(describing: HistoryTableViewController.self)) as! HistoryTableViewController
        nextViewController.dataProvider = dataProvider
        
        show(nextViewController, sender: nil)
        
    }
    
}
