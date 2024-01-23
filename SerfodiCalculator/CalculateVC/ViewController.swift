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
    
    var isNewInput = true
    
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
    
    let calculator = Calculator()
    
    
    var historyExample: [String] = []
    
    
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyTableView.delegate = self
        
        inputLabel.text = "0"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "HistoryVC":
            break
        default: break
        }
    }
    
    @IBAction func unwindAction(unwindSegue: UIStoryboardSegue) {
        
    }
    
    
    // MARK: - Action
    
    /// Кнопки от 0 до 9 и point
    @IBAction func numberButtonTap(_ sender: UIButton) {
        sender.animationTap()
        sender.hapticLightTap()
        currentOperationButton = nil
        
        guard let buttonText = sender.currentTitle else { return }
        guard inputLabel.text!.count < 13 else { return }
        switch buttonText {
        case ",":
            if isNewInput {
                inputLabel.text = "0,"
                isNewInput = false
            } else {
                if inputLabel.text?.contains(",") == true { return }
                inputLabel.text?.append(buttonText)
            }
        case "0":
            if isNewInput {
                inputLabel.text = "0"
                isNewInput = false
            } else {
                if inputLabel.text != "0" {
                    inputLabel.text?.append(buttonText)
                }
            }
        default:
            if isNewInput {
                inputLabel.text = buttonText
                isNewInput = false
            } else {
                inputLabel.text?.append(buttonText)
            }
        }
    }
    
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
        
        currentOperationButton = sender
        
        print("Пример: \(textHistory(items: calculator.calculationHistory))")
        
        calculateResult()
        
        isNewInput = true
    }
    
    
    @IBAction func equallyButtonTap(_ sender: UIButton) {
        sender.hapticMediumTap()
        sender.animationTap()
        
        guard let labelText = inputLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        
        // Нажал после того как нажал на действие. + или * в примере 5 + 2 +\*
        // не срабатывает нажатия 5 + 2 + *
        // Нажали сразу
        // Нажимают несколько раз
        
        if !isNewInput {
            calculator.addNumber(labelNumber)
        } else {
            calculator.removeLastOperation()
        }
        
        print("= Пример: \(textHistory(items: calculator.calculationHistory))")
        calculateResult()
        
        
        calculator.removeHistory { example in
            let text = self.textHistory(items: example)
            if "" != text {
                self.historyExample.append(text)
                self.historyTableView.reloadData()
                
                let indexPath = IndexPath(row: self.historyExample.count - 1, section: 0)
                self.historyTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        
        currentOperationButton = nil // Опирации нет
        isNewInput = true // Новый ввод разрешён
    }
    
    
    @IBAction func clearButtonTap(_ sender: UIButton) {
        sender.hapticHeavyTap()
        sender.animationTap()
        calculator.removeHistory()
        inputLabel.text = "0"
        currentOperationButton = nil
        isNewInput = true
    }
    
    
    
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
    
    
    
    
    
    // MARK: - Calculate
    
    func calculateResult() {
        calculator.calculateResult { (number, error) in
            if let result = number {
                self.inputLabel.text = self.numberFormatter.string(from: NSNumber(value: result))
            } else {
                self.calculator.removeHistory()
                self.inputLabel.text = "Ошибка!"
                self.inputLabel.animationError()
            }
        }
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


