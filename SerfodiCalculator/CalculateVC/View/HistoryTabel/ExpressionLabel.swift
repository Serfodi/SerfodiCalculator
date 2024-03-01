//
//  ExpressionLabel.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.02.2024.
//

import UIKit

class ExpressionLabel: UILabel {

    private var dynamicNumberFormatter = DynamicNumberFormatter()
    
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
        font = .example26()
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        textColor = .exampleColorEqual()
    }
   
}

// MARK: - Expression set

extension ExpressionLabel {
    
    /// Устонавливает прмер в Label
    public func expression(_ expression: Calculation) {
        let postfix = DynamicCalculate.toPostfix(calculationHistory: expression.expression)
        let textArray = parsing(Calculation(expression: postfix, result: expression.result))
        
        outputLabel(expression: textArray)
    }
    
    
    /// Парсит опирации и числа.
    /// Накладывает на них стиль. В зависимости от опирации.
    /// Банарные опирации: сложения, вычитания, умнжения, деления игнорирует. Просто накладывает атрибуты текста.
    private func parsing(_ calculate: Calculation) -> [String] {
        var result: String = ""
        var stack = [String]()
        
        for index in calculate.expression {
            
            switch index {
            case .number(let number):
                
                if let sign = calculate.firstOperation {
                    let signText = symbol(["0"], operation: sign)
                    let numberText = formatText(number: number, currentLineText: signText + "===")
                    stack.append(numberText)
                }
                
            case .operation(let operation):
                guard let items = stack.pop(operation.type.rawValue) else { break }
                
                switch operation {
                case .add, .multiply, .divide, .subtract:
                    stack.append(items[0])
                    stack.append(operation.symbol())
                    stack.append(items[1])
                    
                default:
                    result = symbol(items, operation: operation)
                    stack.append(result)
                }
            }
        }
        
        stack.append("=")
        let numberText = formatText(number: calculate.result, currentLineText: "=")
        stack.append(numberText)
        return stack
    }
    
    /// Выводит массив текста на экран.
    ///
    /// - Note: Опирации бинарного типа можно разделить на две строчки. Уранрные операнды разделять на строчки нельзя.
    ///
    /// - Parameter expression Это массив из отфармотированных чисел и бинарных опираций
    ///
    private func outputLabel(expression: [String]) {
        var expression = expression
        var text = String()
        var currentLineText = String()
        var last = String()
        
        while !expression.isEmpty {
            
            let item = expression.first!
            expression.removeFirst()
            
            currentLineText.append(item)
            
            if !isFitTextInto(currentLineText, scale: 0.99) {
                
                text.append("\n")
                text.append(last)
                
                currentLineText = ""
                currentLineText.append(item)
                currentLineText.append(last)
            }
            
            last = item
            
            text.append(item)
        }
        self.text = text
    }
    
}

/*

extension ExpressionLabel {
    
    /// Парсит опирации и числа.
    /// Накладывает на них стиль. В зависимости от опирации.
    /// Банарные опирации: сложения, вычитания, умнжения, деления игнорирует. Просто накладывает атрибуты текста.
    private func parsing2(_ calculate: Calculation) -> [NSAttributedString] {
        var result = NSAttributedString()
        var stack = [NSAttributedString]()
        
        for index in calculate.expression {
            
            switch index {
            case .number(let number):
                
                if let sign = calculate.firstOperation {
                    let signText = symbol(["0", "0"], operation: sign)
                    let numberText = formatText(number: number, currentLineText: signText + "===")
                    
                    stack.append(NSAttributedString(string: numberText))
                }
                
            case .operation(let operation):
                guard let items = stack.pop(operation.type.rawValue) else { break }
                result = symbol(items, operation: operation)
                stack.append(result)
            }
        }
        
        stack.append(NSAttributedString(string: "="))
        let numberText = formatText(number: calculate.result, currentLineText: "=")
        stack.append(NSAttributedString(string: numberText))
        
        return stack
    }
    
    
    /// Выводит массив текста на экран.
    ///
    /// - Note: Опирации бинарного типа можно разделить на две строчки. Уранрные операнды разделять на строчки нельзя.
    ///
    /// - Parameter expression Это массив из отфармотированных чисел и бинарных опираций
    ///
    private func outputLabel(expression: [NSAttributedString]) {
        var expression = expression
        let text = NSMutableAttributedString()
        var currentLineText = NSMutableAttributedString()
        var last = NSAttributedString()
        
        while !expression.isEmpty {
            
            let item = expression.first!
            expression.removeFirst()
            
            currentLineText.append(item)
            
            if !isFitTextInto(currentLineText) {
                
                text.append(NSAttributedString(string: "\n"))
                text.append(last)
                
                currentLineText = NSMutableAttributedString()
                currentLineText.append(item)
                currentLineText.append(last)
            }
            
            last = item
            
            text.append(item)
        }
        
        self.attributedText = text
    }
    
}
*/



// MARK: operation

extension ExpressionLabel {
    
    private func symbol(_ numbers: [String], operation: Operation) -> String {
        switch operation {
        case .add, .subtract, .multiply, .divide:
            return operation.symbol()
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
            return "sin(" + numbers[0] + ")"
        case .cosX:
            return "cos(" + numbers[0] + ")"
        case .tanX:
            return "tan(" + numbers[0] + ")"
        case .sinhX:
            return "sinh(" + numbers[0] + ")"
        case .coshX:
            return "cosh(" + numbers[0] + ")"
        case .tanhX:
            return "tanh(" + numbers[0] + ")"
        }
    }
    
    /*
    
    // fix it
    private func symbol(_ numbers: [NSAttributedString], operation: Operation) -> NSMutableAttributedString {
        let result = NSMutableAttributedString()
        switch operation {
        case .add:
            result.append(numbers[0])
            result.append(NSAttributedString(string: "+"))
            result.append(numbers[1])
        case .subtract:
            result.append(numbers[0])
            result.append(NSAttributedString(string: "-"))
            result.append(numbers[1])
        case .multiply:
            result.append(numbers[0])
            result.append(NSAttributedString(string: "×"))
            result.append(numbers[1])
        case .divide:
            result.append(numbers[0])
            result.append(NSAttributedString(string: "÷"))
            result.append(numbers[1])
        case .powXY:
            result.append(numbers[0])
            result.append(addAtt(numbers[1].string, script: .superscripts))
        case .powYX:
            result.append(numbers[1])
            result.append(addAtt(numbers[0].string, script: .superscripts))
        case .rootYX:
            result.append(addAtt(numbers[0].string, script: .non))
            result.append(NSAttributedString(string: "√"))
            result.append(numbers[1])
        case .precent:
            result.append(numbers[0])
            result.append(NSAttributedString(string: "%"))
        case .pow2:
            result.append(numbers[0])
            result.append(addAtt("2", script: .superscripts))
        case .pow3:
            result.append(numbers[0])
            result.append(addAtt("3", script: .superscripts))
        case .powEX:
            result.append(NSAttributedString(string: "E"))
            result.append(addAtt(numbers[0].string, script: .superscripts))
        case .pow10X:
            result.append(NSAttributedString(string: "10"))
            result.append(addAtt(numbers[0].string, script: .superscripts))
        case .pow2X:
            result.append(NSAttributedString(string: "2"))
            result.append(addAtt(numbers[0].string, script: .superscripts))
        case .divisionByOne:
            ()
        case .root2:
            result.append(NSAttributedString(string: "√"))
            result.append(numbers[0])
        case .root3:
            result.append(addAtt("3", script: .non))
            result.append(NSAttributedString(string: "√"))
            result.append(numbers[1])
        case .lnX:
            ()
        case .log10X:
            ()
        case .logY:
            ()
        case .log2X:
            ()
        case .factorial:
            ()
        case .sinX:
            ()
        case .cosX:
            ()
        case .tanX:
            ()
        case .sinhX:
            ()
        case .coshX:
            ()
        case .tanhX:
            ()
        }
        return result
    }
    
    */
}


// MARK: - Formatting

extension ExpressionLabel {
    
    private func formatText(number: Double, currentLineText: String) -> String {
        try! dynamicNumberFormatter.fitInBounds(number: number as NSNumber) { numberText in
            isFitTextInto(numberText + currentLineText)
        }
    }
    
    /*
    
    private func formatText(number: Double, currentLineText: NSMutableAttributedString, att: (String) -> NSAttributedString) -> NSAttributedString {
        let numberText = try! dynamicNumberFormatter.fitInBounds(number: number as NSNumber)
        { numberText in
            let line = NSMutableAttributedString()
            let textAtt = att(numberText)
            line.append(textAtt)
            line.append(currentLineText)
            return isFitTextInto(line)
        }
        return att(numberText)
    }
    
    private func addAtt(_ text: String, script: Script) -> NSAttributedString {
        let att: [NSAttributedString.Key : Any] = [
            .font: UIFont.exampleScript(),
            .baselineOffset: UIFont.exampleScript().pointSize * script.rawValue
        ]
        return NSAttributedString(string: text, attributes: att)
    }
    
    private func addAttNumber(_ numberText: String) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black,
                          .font: UIFont.example26()]
        let attributedQuote = NSAttributedString(string: numberText, attributes: attributes)
        return attributedQuote
    }
    
    private enum Script: CGFloat {
        case non = 0.6
        case superscripts = 1
        case subscripts = -1
    }
 
     */
     
}


/*
 
 // MARK: @FIX IT
 
 private func expressionString(_ calculation: Calculation) {
     let text = NSMutableAttributedString()
     
     var currentLine = ""
     
     for item in calculation.expression {
         switch item{
         case .number(let number):
             
             let numberText = formatText(number: number, currentLineText: "0")
             
             if !isFitText(currentLineText: currentLine, addingText: numberText) {
                 let textS: String = text.string
                 let last = String(textS.suffix(1))
                 text.append(NSAttributedString(string: "\n"))
                 let testSign = createAtt(text: last, color: .exampleColorSign())
                 text.append(testSign)
                 currentLine = last
             }
             
             let textAS = NSAttributedString(string: numberText)
             text.append(textAS)
             
             currentLine.append(numberText)
             
         case .operation(let sign):
             
             let symbolSign = getSign(sign)
             let testSign = createAtt(text: symbolSign, color: .exampleColorSign())
             
             text.append(testSign)
             currentLine.append(symbolSign)
             
         }
     }
     
     let numberText = formatText(number: calculation.result, currentLineText: "0")
     
     if !isFitText(currentLineText: currentLine, addingText: numberText)  {
         text.append(createAtt(text: "=", color: .exampleColorEqual()))
         text.append(NSAttributedString(string: "\n"))
     }
     
     text.append(createAtt(text: "=", color: .exampleColorEqual()))
     text.append(createAtt(text: numberText, color: .exampleColorResult()))
     
     numberLabel.attributedText = text
 }
 
 private func isFitText(currentLineText: String, addingText: String) -> Bool {
     let text = currentLineText + addingText
     return self.numberLabel.isFitTextInto(text)
 }
 
 /// Форматирует число
 private func formatText(number: Double, currentLineText: String) -> String {
     try! dynamicNumberFormatter.fitInBounds(number: number as NSNumber) { numberText in
         isFitText(currentLineText: currentLineText, addingText: numberText)
     }
 }
 
 /// Накидывает атрибуты
 private func createAtt(text attributedString: String, color: UIColor) -> NSAttributedString {
     let attributes = [NSAttributedString.Key.foregroundColor: color]
     let attributedQuote = NSAttributedString(string: attributedString, attributes: attributes)
     return attributedQuote
 }
 
 
 
 */
