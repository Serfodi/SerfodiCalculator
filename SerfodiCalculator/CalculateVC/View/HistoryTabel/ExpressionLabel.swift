//
//  ExpressionLabel.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.02.2024.
//

import UIKit

class ExpressionLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        textAlignment = .right
        lineBreakMode = .byTruncatingTail
        numberOfLines = 4
    }
   
}

// MARK: - Expression set

extension ExpressionLabel {
    
    /// Устонавливает прмер в Label
    public func expression(_ expression: Calculation) {
        let postfix = DynamicCalculate.toPostfix(calculationHistory: expression.expression)
        // add style text
        let textArray = parsing(items: postfix)
        let array = addResult(expression.result, in: textArray)
        // output text
        outputLabel(expression: array)
    }
    
    /// Парсит опирации и числа.
    /// Накладывает на них стиль. В зависимости от опирации.
    /// Банарные опирации: сложения, вычитания, умнжения, деления игнорирует. Просто накладывает атрибуты текста.
    private func parsing(items: [CalculationHistoryItem]) -> [String] {
        
        var result: String = ""
        var stack = [String]()
        
        for index in items {
            switch index {
                
            case .number(let number):
                let numberText = String(number)
                stack.append(numberText)
                
            case .operation(let operation):
                                
                guard let numbers = stack.pop(operation.type.rawValue) else { break }
                result = symbol(numbers, operation: operation)
                stack.append(result)
            }
        }
        return stack
    }
    
    /// Накадывает отрибуты на равно и ответ.
    private func addResult(_ result: Double, in current: [String]) -> [String] {
        var array = current
        array.append("=")
        let resultText = String( result )
        array.append(resultText)
        return array
    }
    
    /// Выводит массив текста на экран.
    ///
    /// - Note: Опирации бинарного типа можно разделить на две строчки. Уранрные операнды разделять на строчки нельзя.
    ///
    /// - Parameter expression Это массив из отфармотированных чисел и бинарных опираций
    ///
    private func outputLabel(expression: [String]) {
        var text = String()
        for item in expression {
            text.append(item)
        }
        self.text = text
    }
    
}

extension ExpressionLabel {
    
    private func symbol(_ numbers: [String], operation: Operation) -> String {
        switch operation {
            
        case .add, .subtract, .multiply, .divide:
            return numbers[0] + operation.symbol() + numbers[1]
        case .powXY:
            return numbers[0] + "^" + numbers[1]
        case .powYX:
            return numbers[1] + "^" + numbers[0]
        case .rootYX:
            return numbers[1] + "^" +  "√" + numbers[0]
        case .logY:
            return "log" + numbers[0] + "_" + numbers[1]
            
        case .precent:
            return "1%" + numbers[0]
        case .pow2:
            return numbers[0] + "²"
        case .pow3:
            return numbers[0] + "³"
            
            
        case .powEX:
            return "e" + "^" + numbers[0]
        case .pow10X:
            return "10" + "^" + numbers[0]
        case .pow2X:
            return "2" + "^" + numbers[0]
        
        case .divisionByOne:
            return "1/" + numbers[0]
        case .root2:
            return "√" + numbers[0]
        case .root3:
            return "∛" + numbers[0]
        
        case .lnX:
            return "ln" + numbers[0]
        case .log10X:
            return "log₁₀" + numbers[0]
        
        case .log2X:
            return "log₂" + numbers[0]
            
        case .factorial:
            return "!" + numbers[0]
            
        case .sinX:
            return "sin" + numbers[0]
        case .cosX:
            return "cos" + numbers[0]
        case .tanX:
            return "tan" + numbers[0]
        case .sinhX:
            return "sinh" + numbers[0]
        case .coshX:
            return "cosh" + numbers[0]
        case .tanhX:
            return "tanh" + numbers[0]
        }
        
    }
    
}

//enum Script: Int {
//        case non = 0
//        case superscripts = 1
//        case subscripts = -1
//    }
//
//    func addAtt(_ text: String) -> NSAttributedString {
//        NSAttributedString(string: text)
//    }
//
//    func addAtt(_ text: String, font: UIFont, color: UIColor, script: Script = .non) -> NSAttributedString {
//        let att: [NSAttributedString.Key : Any] = [
//            .font: font,
//            .foregroundColor: color,
//            .baselineOffset: font.lineHeight * CGFloat( script.rawValue )
//        ]
//        return NSAttributedString(string: text, attributes: att)
//    }
