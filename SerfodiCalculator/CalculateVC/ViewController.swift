//
//  ViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet var operationButton: [UIButton]!
    @IBOutlet var numberButton: [UIButton]!
    @IBOutlet weak var numpadView: UIView!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    
    var currentOperationButton: UIButton? = UIButton() {
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
    
    /// Индикатор для сигнализации о новом вводе:
    /// `true` – Разрешён новый ввод числа
    /// `false` – Ввод числа завершен
    var isNewInput = true
    
    let calculator = Calculator()
    
    
    // @fix it Перенести
    var historyExample: [String] = []
    
    
    
    // MARK: - Live circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableView.delegate = self
        
        resetCalculate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    
    // MARK: - Transit
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "HistoryVC":
            break
        default: break
        }
    }
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {}
    
    
    
    // MARK: - Action
    
    /// Добавляет символ в строчку ввода числа.
    @IBAction func numberButtonTap(_ sender: UIButton) {
        sender.animationTap()
        sender.hapticLightTap()
        
        guard let buttonText = sender.currentTitle else { return }
        guard inputLabel.text!.count < 13 || isNewInput else { return }
        
        switch buttonText {
        case ",":
            if isNewInput {
                inputLabel.text = "0,"
            } else {
                if inputLabel.text?.contains(",") == true { return }
                inputLabel.text?.append(buttonText)
            }
        case "0":
            if isNewInput {
                inputLabel.text = buttonText
            } else {
                if inputLabel.text != "0" {
                    inputLabel.text?.append(buttonText)
                }
            }
        default:
            if isNewInput {
                inputLabel.text = buttonText
            } else {
                inputLabel.text?.append(buttonText)
            }
        }
        
        currentOperationButton = nil
        isNewInput = false
    }
    
    /// Выполняет фиксацию введеного числа и операции.
    /// Операцию можно менять до нового ввода.
    /// Вычисление текущего результата `calculateResult` происходит после каждого нажатия на кнопаку
    @IBAction func operatingButtonTap(_ sender: UIButton) {
        sender.animationTap()
        sender.hapticSoftTap()
        
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        
        guard let labelText = inputLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        if !isNewInput || calculator.count == 0 {
            calculator.addNumber(labelNumber)
        }
        
        calculator.addOperation(buttonOperation)
        
        calculateResult { result in
            inputLabel.text = numberFormatter.string(from: NSNumber(value: result))
        }
        
        currentOperationButton = sender
        isNewInput = true
    }
    
    /// Выполняет фиксацию введеного или полученого числа.
    /// Вычисление текущего результата `calculateResult` происходит после каждого нажатия на кнопку.
    /// Выводит результирующий пример и очищяет `calculationHistory`
    /// При повторном нажатии выполняет последнее действие.
    @IBAction func equallyButtonTap(_ sender: UIButton) {
        sender.hapticMediumTap()
        sender.animationTap()
        
        guard let labelText = inputLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        
        // MARK: Operation
        
        
        if !isNewInput || calculator.count == 0 {
            calculator.addNumber(labelNumber)
        } else {
            calculator.removeLastOperation()
        }
        
        if isNewInput && calculator.count == 1 {
            // Добавить последнее действие.
            calculator.addLastOperation()
        }
        
        
        // MARK: Calculate Result
                
        calculateResult { result in
            inputLabel.text = self.numberFormatter.string(from: NSNumber(value: result))
            calculator.removeHistory { items in
                self.addExample(items, result: result)
            }
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
            resetCalculate(labelText: "Ошибка!")
        case .fewOperations:
            return
        }
    }
    
    /// Полный сброс калькулятора и вычислений.
    func resetCalculate(labelText: String = "0") {
        calculator.removeAll()
        inputLabel.text = labelText
        currentOperationButton = nil
        isNewInput = true
    }
    
    
    
    /// fix it Добовляет новый пример в историю.
    func addExample(_ items: [CalculationHistoryItem], result: Double) {
        let text = self.textHistory(items: items) + "=" + self.numberFormatter.string(from: NSNumber(value: result))!
        
        guard text != "" else { return }
        self.historyExample.append(text)
        self.historyTableView.reloadData()
        
        let indexPath = IndexPath(row: self.historyExample.count - 1, section: 0)
        self.historyTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    
    // @fix it  Перенести
    func textHistory(items: [CalculationHistoryItem]) -> String {
        var text: String = ""
        for item in items {
            switch item{
            case .number(let number):
                text += self.numberFormatter.string(from: NSNumber(value: number))!
            case .operation(let sign):
                text += sign.rawValue
            }
        }
        return text
    }
    
}


// MARK: - UITableViewDelegate


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyExample.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseId, for: indexPath) as! HistoryCell
        cell.config(example: historyExample[indexPath.row])
        return cell
        
    }
 
    
    
    
}


