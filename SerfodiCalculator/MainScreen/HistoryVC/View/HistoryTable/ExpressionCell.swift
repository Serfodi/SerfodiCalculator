//
//  ExpressionLatexLabel.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 07.04.2024.
//

import SwiftMath
import UIKit

class ExpressionCell: UITableViewCell {
    
    static let reuseId = "ExpressionCell"
    
    private let dynamicNumberFormatter = DynamicNumberFormatter()
    private let generateLatex = GenerationLatex()
    
    private let label = MTMathUILabel()
    
    // MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configurLayoutLabel()
        configurLabel()
        configurCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func fitNumberInLabel(_ number: NSNumber) -> String {
        return try! dynamicNumberFormatter.fitInBounds(number: number) { numberText in
            label.latex = numberText
            return label.intrinsicContentSize.width < self.bounds.width - 35
        }
    }
    
    /// Функция настройки из контролера
    public func config(calculation: Calculation) {
        label.latex = generateLatex.generate(expression: calculation, formatting: { number in
            return fitNumberInLabel(number)
        }, isFit: { text in
            label.latex = text
            return label.intrinsicContentSize.width < self.bounds.width - 35
        })
    }
}

private extension ExpressionCell {
 
    private func configurLabel() {
        let font = MainFontAppearance.exampleFont
        let size = font.pointSize
//        label.font = MTFontManager().defaultFont
        label.fontSize = size
        label.textAlignment = .right
        label.textColor = HistoryAppearance.HistoryCellExample.resultColor.color()
        label.backgroundColor = .clear
    }
    
    private func configurCell() {
        self.backgroundColor = .clear
    }
    
    private func configurLayoutLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
}
