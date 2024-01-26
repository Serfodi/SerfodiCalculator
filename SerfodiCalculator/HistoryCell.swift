//
//  HistoryCell.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.01.2024.
//

import UIKit

final class HistoryCell: UITableViewCell {
    
    static let reuseId = "historyCell"
    
    private lazy var numberFormatter = NumberFormatter(locate: "ru_RU")
    
    @IBOutlet weak var label: UILabel!
    
    public func config(calculation: Calculation) {
        backgroundColor = .clear
        label.text = expressionString(calculation)
    }
    
    private func expressionString(_ calculation: Calculation) -> String {
        var text: String = ""
        for item in calculation.expression {
            switch item{
            case .number(let number):
                text += numberFormatter.string(from: NSNumber(value: number))!
            case .operation(let sign):
                text += sign.rawValue
            }
        }
        text += "=" + numberFormatter.string(from: NSNumber(value: calculation.result))!
        return text
    }
    
    override func prepareForReuse() {
        label.text = ""
    }
    
}
