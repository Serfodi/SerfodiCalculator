//
//  HistoryCell.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.01.2024.
//

import UIKit

final class HistoryCell: UITableViewCell {
    
    static let reuseId = "historyCell"
    
    private lazy var numberFormatterDec = NumberFormatter(locate: "ru_RU")
    private lazy var numberFormatterE = NumberFormatter(style: .scientific)
    
    @IBOutlet weak var label: UILabel!
    
    public func config(calculation: Calculation) {
        backgroundColor = .clear
        expressionString(calculation)
    }
    
    private func expressionString(_ calculation: Calculation) {
        var text: String = ""
        for item in calculation.expression {
            switch item{
            case .number(let number):
                if number > 100000000000 {
                    text += numberFormatterE.string(from: NSNumber(value: number))!
                } else {
                    text += numberFormatterDec.string(from: NSNumber(value: number))!
                }
            case .operation(let sign):
                text += sign.rawValue
            }
        }
        text += "="
        let index = text.count
        
        var result = ""
        
        if calculation.result > 100000000000 {
            result = numberFormatterE.string(from: NSNumber(value: calculation.result))!
        } else {
            result = numberFormatterDec.string(from: NSNumber(value: calculation.result))!
        }
        
        text += result
        
        let attributedQuote = NSMutableAttributedString(string: text)
        let range = NSRange(location: index, length: result.count)
        attributedQuote.addAttribute(.foregroundColor, value: UIColor.numberButtonColor(), range: range)
        
        label.attributedText = attributedQuote
        
//        return attributedQuote
    }
    
    override func prepareForReuse() {
        label.text = ""
    }
    
}
