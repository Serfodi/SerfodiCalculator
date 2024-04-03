//
//  ExpressionLabel.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 11.03.2024.
//

import UIKit

final class ExpressionLabel: UILabel {
    
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
        font = .example26()
        textAlignment = .right
        lineBreakMode = .byTruncatingTail
        numberOfLines = 4
        textColor = HistoryAppearance.HistoryCellExample.numberColor.color()
    }
    
    public func setExpression(_ expression: Calculation) {
        attributedText = expressionString(expression, lengthLine: maximumDigitsInLine())
    }
    
}

extension ExpressionLabel {

    /// Возврощяет максимальное кол-во символов в строке
    private func maximumDigitsInLine() -> Int {
        let oneDigitWidth = size(text: "2").width
        let roundWidth = round(oneDigitWidth * 10) / 10
        let lengthLine = Int( bounds.width / roundWidth)
        return lengthLine
    }


    // MARK: @FIX IT

    private func expressionString(_ calculation: Calculation, lengthLine: Int) -> NSMutableAttributedString {
        let text = NSMutableAttributedString()
        
        let maxWidth = lengthLine
        var currentWidth = maxWidth
        
        // 14 + 4
        // sin45
        
        for item in calculation.expression {
            switch item{
            case .number(let number):
                
                let numberText = formatText(number: number, width: maxWidth - 1)
                
                if currentWidth - numberText.count < 2 {
                    let textS: String = text.string
                    let last = String(textS.suffix(1))
                    text.append(NSAttributedString(string: "\n"))
                    let testSign = createAtt(text: last, color: HistoryAppearance.HistoryCellExample.signColor.color())
                    text.append(testSign)
                    currentWidth = maxWidth - 1
                }
                
                let textAS = NSAttributedString(string: numberText)
                text.append(textAS)
                
                currentWidth -= numberText.count
                
            case .operation(let sign):
                
                let symbolSign = getSign(sign)
                let testSign = createAtt(text: symbolSign, color: HistoryAppearance.HistoryCellExample.signColor.color())
                
                text.append(testSign)
                currentWidth -= 1
                
                if currentWidth - sign.symbol().count == 0 {
                    text.append(NSAttributedString(string: "\n"))
                    text.append(testSign)
                    currentWidth = maxWidth
                }
            }
        }
        
        let numberText = formatText(number: calculation.result, width: maxWidth - 1)
        
        if currentWidth - numberText.count < 0  {
            text.append(createAtt(text: "=", color: HistoryAppearance.HistoryCellExample.equalColor.color()))
            text.append(NSAttributedString(string: "\n"))
        }
        
        text.append(createAtt(text: "=", color: HistoryAppearance.HistoryCellExample.equalColor.color()))
        text.append(createAtt(text: numberText, color: HistoryAppearance.HistoryCellExample.resultColor.color()))
        
        return text
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

// MARK: Draw sign

extension ExpressionLabel {
    
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
