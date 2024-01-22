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
            oldValue.backgroundColor = UIColor.operatingButtonColor()
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
        
        sender.animationTap()
        sender.hapticLightTap()
        
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
            if inputLabel.text != "0" {
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
    
    
    
    @IBAction func operatingButtonTap(_ sender: UIButton) {
        sender.animationTap()
        
        sender.hapticSoftTap()
        
        guard let buttonText = sender.currentTitle,
              let buttonOperation = Operation(rawValue: buttonText)
        else { return }
        guard let labelText = inputLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        if isNewInput {
            // старое число
            if case .operation(let operation) = calculationHistory.last {
                if operation != buttonOperation {
                    // Смена знака
                    calculationHistory.removeLast()
                    currentOperationButton = sender
                    calculationHistory.append(.operation(buttonOperation))
                }
            } else {
                currentOperationButton = sender
                calculationHistory.append(.number(labelNumber))
                calculationHistory.append(.operation(buttonOperation))
            }
        } else {
            // Новое число введенно
            currentOperationButton = sender
            calculationHistory.append(.number(labelNumber))
            calculationHistory.append(.operation(buttonOperation))
            calculateResult()
        }
        isNewInput = true
    }
    
    
    /// Кнопка =
    @IBAction func equallyButtonTap(_ sender: UIButton) {
        
//        sender.hapticRigidTap()
        sender.hapticMediumTap()
        
        sender.animationTap()
        guard let labelText = inputLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        
        calculationHistory.append(.number(labelNumber))
        calculateResult()
        calculationHistory.removeAll()
        currentOperationButton = UIButton()
        isNewInput = true
    }
    
    
    /// Кнопка С
    @IBAction func clearButtonTap(_ sender: UIButton) {
        
        sender.hapticHeavyTap()
        
        sender.animationTap()
        calculationHistory.removeAll()
        currentOperationButton = UIButton()
        resetLabelText()
        isNewInput = true
    }
    
    
    
    func calculateResult() {
        do {
            let result = try calculate()
            inputLabel.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            inputLabel.text = "Ошибка!"
//            animatorColor(view: inputLabel)
            inputLabel.animationError()
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



