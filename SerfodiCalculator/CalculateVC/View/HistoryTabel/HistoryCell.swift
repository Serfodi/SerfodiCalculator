//
//  HistoryCell.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.01.2024.
//

import UIKit

/**
 
 Использовать форму E только если число занимат больше половыны всего лейбла.
 
 Нельзя разделять числа на два строки.
 
 Если пример не влазиет в две строки то, ответ будет выводится справа на отдельном view. Для просмотра больше нужно нажать на него.
 
 Размеры могут менятся динамически. Кол-во разрешеных строк на вывод примера тоже. Кол-во строк
 
 1. Запретить раздиление чисел на два обзаца
 
 
 */
final class HistoryCell: UITableViewCell {
    
    static let reuseId = "historyCell"
    
    private var dynamicNumberFormatter = DynamicNumberFormatter()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .example26()
        label.textAlignment = .right
        label.lineBreakMode = .byTruncatingTail
        label.numberOfLines = 4
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.95
        label.textColor = .exampleColorNumber()
        return label
    }()
    
    private var calculation: Calculation!
    
    
    // MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .focusColor()
        bgColorView.layer.cornerRadius = 4
        selectedBackgroundView = bgColorView
        
        setupNumberLabel()
        numberLabel.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNumberLabel()
    }
    
    override func prepareForReuse() {
        numberLabel.text = ""
        calculation = nil
    }
    
    
    /// Функция настройки из контролера
    public func config(calculation: Calculation) {
        self.calculation = calculation
        expressionString(calculation)
    }
    
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
                
//                if currentWidth - sign.symbol().count == 0 {
//                    text.append(NSAttributedString(string: "\n"))
//                    text.append(testSign)
//                    currentWidth = maxWidth
//                }
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
    
}

// MARK: Draw sign

extension HistoryCell {
    
    private func getSign(_ sign: Operation ) -> String {
        switch sign {
        case .pow2:
            return "²"
        case .pow3:
            return "³"
        case .factorial:
            return "!"
        default:
            return sign.symbol()
        }
    }
    
}



// MARK: - Constraint

extension HistoryCell {
    
    private func setupNumberLabel() {
        addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            numberLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            numberLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        ])
    }
    
}


