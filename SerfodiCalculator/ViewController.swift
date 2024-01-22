//
//  ViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit


enum CalculationError: Error {
    case dividedByZero
}


enum Operation: String {
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self{
        case .add:
            return number1 + number2
        case .subtract:
            return number1 - number2
        case .multiply:
            return number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.dividedByZero
            }
            return number1 / number2
        }
    }
}

enum CalculationHistoryItem {
    case number(Double)
    case operation(Operation)
}


class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet var operationButton: [UIButton]!
    @IBOutlet var numberButton: [UIButton]!
    @IBOutlet weak var numpadView: UIView!
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    var calculationHistory: [CalculationHistoryItem] = []
    
    var isNewInput = true
    
    var currentOperationButton: UIButton = UIButton() {
        didSet {
            oldValue.backgroundColor = UIColor.serviceButtonColor()
            oldValue.isSelected = false
        }
        willSet {
            newValue.backgroundColor = UIColor.mainColor()
            newValue.isSelected = true
        }
    }
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resetLabelText()
    }
    
    
    
    // MARK: - func button
    
    /// Кнопки от 0 до 9 и point
    @IBAction func numberButtonTap(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else { return }
        
        switch buttonText {
        case ",":
            if isNewInput && calculationHistory.count == 0 {
                inputLabel.text = "0,"
                isNewInput = false
            } else {
                if inputLabel.text?.contains(",") == true { return }
                inputLabel.text?.append(buttonText)
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
    
    
    /// Кнопки опираций: / x - +
    @IBAction func operatingButtonTap(_ sender: UIButton) {
        
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        
        guard let labelText = inputLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        
        if !isNewInput {
            
            currentOperationButton = sender
            calculationHistory.append(.number(labelNumber))
            calculationHistory.append(.operation(buttonOperation))
            isNewInput = true
            
            calculateResult()
        }
        
        
//        resetLabelText()
    }
    
    
    /// Кнопка =
    @IBAction func equallyButtonTap(_ sender: UIButton) {
        guard let labelText = inputLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        if !isNewInput {
            calculationHistory.append(.number(labelNumber))
            calculateResult()
            calculationHistory.removeAll()
            currentOperationButton = UIButton()
        }
    }
    
    
    /// Кнопка С
    @IBAction func clearButtonTap(_ sender: UIButton) {
        calculationHistory.removeAll()
        resetLabelText()
        isNewInput = true
    }
    
    
    
    func calculateResult() {
        do {
            let result = try calculate()
            inputLabel.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            inputLabel.text = "Ошибка!"
        }
    }
    
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0] else { return 0 }
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2) {
            guard
                case .operation(let operation) = calculationHistory[index],
                case .number(let number) = calculationHistory[index + 1]
            else { break }
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }
    
    private func resetLabelText() {
        inputLabel.text = "0"
    }
    
}



