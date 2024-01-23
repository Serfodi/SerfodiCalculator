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
    
//    var calculationHistory: [CalculationHistoryItem] = []
    
    var isNewInput = true
    
    var currentOperationButton: UIButton? = UIButton() {
        didSet {
            guard let button = oldValue else { return }
            button.backgroundColor = UIColor.operatingButtonColor()
            button.isSelected = false
        }
        willSet {
            guard let button = newValue else { return }
            button.backgroundColor = UIColor.mainColor()
            button.isSelected = true
        }
    }
    
    let calculator = Calculator()
    
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
        
        
        if !isNewInput {
            calculator.addNumber(labelNumber)
        }
        
        if let button = currentOperationButton {
            if button != sender {
                currentOperationButton = sender
            }
        } else {
            currentOperationButton = sender
            
            if isNewInput {
                calculator.removeLastNumber()
            }
            
        }
        
        
        
        
        calculator.addOperation(buttonOperation)
        calculateResult()
        
        isNewInput = true
    }
    
    
    @IBAction func equallyButtonTap(_ sender: UIButton) {
        sender.hapticMediumTap()
        sender.animationTap()
        
        guard let labelText = inputLabel.text,
              let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else { return }
        
        if currentOperationButton == nil {
            // Нажимают на равно
            if !isNewInput {
                // Нажали в первый раз
                calculator.addNumber(labelNumber)
            }
        } else {
            // Нажали после того как нажали опирацию
            calculator.removeLastOperation()
        }
        
        calculateResult()
        
        calculator.removeHistory { example in
            print(example)
        }
        
        currentOperationButton = nil
        isNewInput = true
    }
    
    
    @IBAction func clearButtonTap(_ sender: UIButton) {
        sender.hapticHeavyTap()
        sender.animationTap()
        calculator.removeHistory()
        currentOperationButton = nil
        resetLabelText()
        isNewInput = true
    }
    
    
    private func resetLabelText() {
        inputLabel.text = "0"
    }
    
    
    func calculateResult() {
        calculator.calculateResult { (number, error) in
            if let result = number {
                self.inputLabel.text = self.numberFormatter.string(from: NSNumber(value: result))
            } else {
                self.inputLabel.text = "Ошибка!"
                self.inputLabel.animationError()
            }
        }
    }
    
}



