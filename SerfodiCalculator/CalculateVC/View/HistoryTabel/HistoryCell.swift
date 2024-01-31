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
        label.textColor = .exampleColorNumber()
        return label
    }()
    
    private var calculation: Calculation!
    
    
    // MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setupNumberLabel()
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
        expressionString(calculation, lengthLine: maximumDigitsInLine())
    }
    
    /// Возврощяет максимальное кол-во символов в строке
    private func maximumDigitsInLine() -> Int {
        let oneDigitWidth = numberLabel.size(text: "2").width
        let roundWidth = round(oneDigitWidth * 10) / 10
        let lengthLine = Int( bounds.width / roundWidth)
        return lengthLine
    }
    
    
    // MARK: @FIX IT
    
    private func expressionString(_ calculation: Calculation, lengthLine: Int ) {
        let text = NSMutableAttributedString()
        
        let maxWidth = lengthLine
        var currentWidth = maxWidth
        
        for item in calculation.expression {
            switch item{
            case .number(let number):
                // 1. Форматируем число.
                let numberText = formatText(number: number, width: maxWidth - 1)
                
                if currentWidth - numberText.count < 2 {
                    let textS: String = text.string
                    let last = String(textS.suffix(1))
                    text.append(NSAttributedString(string: "\n"))
                    let testSign = createAtt(text: last, color: .exampleColorSign())
                    text.append(testSign)
                    currentWidth = maxWidth - 1
                }
                
                let textAS = NSAttributedString(string: numberText)
                text.append(textAS)
                
                currentWidth -= numberText.count
                
            case .operation(let sign):
                let testSign = createAtt(text: sign.rawValue, color: .exampleColorSign())
                text.append(testSign)
                currentWidth -= 1
                
                if currentWidth - sign.rawValue.count == 0 {
                    text.append(NSAttributedString(string: "\n"))
                    text.append(testSign)
                    currentWidth = maxWidth
                }
            }
        }
        
        let numberText = formatText(number: calculation.result, width: maxWidth - 1)
        
        if currentWidth - numberText.count < 0  {
            text.append(createAtt(text: "=", color: .exampleColorEqual()))
            text.append(NSAttributedString(string: "\n"))
        }
        
        text.append(createAtt(text: "=", color: .exampleColorEqual()))
        text.append(createAtt(text: numberText, color: .exampleColorResult()))
        
        numberLabel.attributedText = text
    }
    
    
    private func isFitNumber(inLine width: Int, forText number: String) -> Bool {
        width - number.count > 0
    }
    
    
    /// Форматирует число
    private func formatText(number: Double, width: Int ) -> String {
        try! dynamicNumberFormatter.fitInBounds(number: number as NSNumber) { numberText in
            isFitNumber(inLine: width, forText: numberText)
        }
    }
    
    /// Накидывает атрибуты
    private func createAtt(text attributedString: String, color: UIColor) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.foregroundColor: color]
        let attributedQuote = NSAttributedString(string: attributedString, attributes: attributes)
        return attributedQuote
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
