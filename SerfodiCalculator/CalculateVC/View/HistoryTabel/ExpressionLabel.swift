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
        font = .example26()
        textAlignment = .right
        lineBreakMode = .byTruncatingTail
        numberOfLines = 4
        textColor = .exampleColorNumber()
    }
   
}

// MARK: - Expression set

extension ExpressionLabel {
    
    public func expression(_ expression: Calculation) {
        /*
         1. Приоброзовать в постфиксную форму
         2. Разспарсить по операциям
         3. Добавить в конец = result
         4. Полученный массив присвоить label
         */
        
        let postfix = DynamicCalculate.toPostfix(calculationHistory: expression.expression)
        var textArray = parsing(items: postfix)
        
        textArray.append("=")
        let resultText = String( expression.result )
        textArray.append(resultText)
        
        self.text = textArray.reduce("", +)
    }
    
    private func parsing(items: [CalculationHistoryItem]) -> [String] {
        
        var result: String = ""
        var stack = [String]()
        
        for index in items {
            switch index {
                
            case .number(let number):
                let numberText = String(number)
                stack.append(numberText)
                
            case .operation(let operation):
                                
                switch operation.type {
                case .binary:
                    guard let numbers = stack.pop(operation.type.rawValue) else { break }
                    result = "\(numbers[0]) \(operation.symbol()) \(numbers[1])"
                case .unary:
                    guard let numbers = stack.pop(operation.type.rawValue) else { break }
                    result = "\(numbers[0]) \(operation.symbol())"
                }
                
                stack.append(result)
            }
        }
        return stack
    }
    
}
