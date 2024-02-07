//
//  ViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: DisplayLabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet var operationButton: [UIButton]!
    @IBOutlet var numberButton: [UIButton]!
    @IBOutlet weak var numpadView: UIView!
    @IBOutlet weak var historyTableView: HistoryTableView!
    
    private var currentOperationButton: UIButton? = UIButton() {
        didSet {
            guard let button = oldValue else { return }
            guard button != currentOperationButton else { return }
            button.backgroundColor = UIColor.operatingButtonColor()
            button.isSelected = false
        }
        willSet {
            guard let button = newValue else { return }
            guard button != currentOperationButton else { return }
            button.backgroundColor = UIColor.mainColor()
            button.isSelected = true
        }
    }
    
    private let calculator = Calculator()
    
    public var dataProvider: DataProvider!
    
    /// Индикатор для сигнализации о новом вводе:
    /// `true` – Разрешён новый ввод числа
    /// `false` – Ввод числа завершен
    private var isNewInput = true
    
    
    
    
    // MARK: - Live circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetCalculate()
        
        let historyManager = HistoryManager()
        dataProvider = DataProvider()
        
        dataProvider.historyManager = historyManager
        
        inputLabel.delegate = self
        historyTableView.tableView.dataSource = dataProvider
        historyTableView.tableView.delegate = dataProvider
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        historyTableView.tableView.showLastCell(animated: false)
        let lastResult = SettingManager.shared.getLastResult
        
        inputLabel.setTextLabel(number: lastResult) // fix it
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let number = inputLabel.getNumber() {
            SettingManager.shared.saveLastResult(result: number)
        }
    }
    
    
    // MARK: - Action
    
    /// Добавляет символ в строчку ввода числа.
    @IBAction func numberButtonTap(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let _ = inputLabel.text
        else { return }
        
        sender.animationTap()
        sender.hapticLightTap()
        
        guard inputLabel.isCanAddDigit(new: buttonText) || isNewInput else { return }
        
        if isNewInput {
            isNewInput = !isNewInput
            inputLabel.text = "0"
        }
        
        inputLabel.inputDigit(add: buttonText) { number in
            SettingManager.shared.saveLastResult(result: number)
        }
        
        currentOperationButton = nil
    }
    
    
    @IBAction func addMinus(_ sender: UIButton) {
        sender.animationTap()
        sender.hapticLightTap()
        inputLabel.addMinusNumber()
        SettingManager.shared.saveLastResult(result: inputLabel.getNumber()!)
    }
    
    
    /// Выполняет фиксацию введеного числа и операции.
    /// Операцию можно менять до нового ввода.
    /// Вычисление текущего результата `calculateResult` происходит после каждого нажатия на кнопаку
    @IBAction func operatingButtonTap(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        
        sender.animationTap()
        sender.hapticSoftTap()
        
        guard let labelNumber = inputLabel.getNumber() else { return }
        
        if !isNewInput || calculator.count == 0 {
            calculator.addNumber(labelNumber)
        }
        
        calculator.addOperation(buttonOperation)
        currentOperationButton = sender
        
        calculateResult { result in
            inputLabel.setTextLabel(number: result)
            SettingManager.shared.saveLastResult(result: result)
        }
        
        isNewInput = true
    }
    
    /// Выполняет фиксацию введеного или полученого числа.
    /// Вычисление текущего результата `calculateResult` происходит после каждого нажатия на кнопку.
    /// Выводит результирующий пример и очищяет `calculationHistory`
    /// При повторном нажатии выполняет последнее действие.
    @IBAction func equallyButtonTap(_ sender: UIButton) {
        sender.hapticMediumTap()
        sender.animationTap()
        
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
                self.dataProvider.historyManager?.add(calculation: calculation)
                self.historyTableView.tableView.reloadData()
                self.historyTableView.tableView.showLastCell()
            }
            inputLabel.setTextLabel(number: result)
        }
        
        currentOperationButton = nil // Опирации нет
        isNewInput = true // Новый ввод разрешён
    }
    
    @IBAction func clearButtonTap(_ sender: UIButton) {
        sender.hapticHeavyTap()
        sender.animationTap()
        resetCalculate()
    }
    
    
    
    // MARK: - Calculate
    
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
    
    /// Обработка ошибок вычислений
    func errorCalculate(error: CalculationError) {
        switch error {
        case .dividedByZero:
            inputLabel.animationError()
            resetCalculate(clearLabel: false)
            errorText()
        case .fewOperations:
            return
        case .outOfRang:
            inputLabel.animationError()
            resetCalculate(clearLabel: false)
            errorText()
        }
    }
    
    /// Полный сброс калькулятора и вычислений.
    func resetCalculate(clearLabel: Bool = true) {
        calculator.removeAll()
        currentOperationButton = nil
        isNewInput = true
        if clearLabel {
            inputLabel.text = "0"
        }
    }
    
    func errorText(labelText: String = "Ошибка!") {
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(10.0), range: NSRange(location: labelText.count - 1, length: 1))
        inputLabel.attributedText = attributedString
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
