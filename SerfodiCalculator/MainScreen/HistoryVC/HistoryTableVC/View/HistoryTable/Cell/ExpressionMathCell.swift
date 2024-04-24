//
//  ExpressionLatexLabel.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 07.04.2024.
//

import SwiftMath
import UIKit

class ExpressionMathCell: UITableViewCell {
    
    enum Padding {
        static let scroll: CGFloat = 14
        static let label: CGFloat = 10
        static let cell: CGFloat = 2
    }
    
    static let reuseId = String(describing: ExpressionMathCell.self)
    
    private let dynamicNumberFormatter = DynamicNumberFormatter()
    private let generateLatex = GenerationLatex()
    
    private let scrollView: ContentScrollView = {
        let scrollView = ContentScrollView()
        scrollView.isUserInteractionEnabled = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: Padding.scroll, bottom: 0, right: Padding.scroll)
        return scrollView
    }()
    
    private var heightConstraint: NSLayoutConstraint!
    
    private let mathLabel: MTMathUILabel = {
        let label = MTMathUILabel()
        label.transform = CGAffineTransform(scaleX: -1, y: 1)
        let font = MainFontAppearance.exampleFont
        let size = font.pointSize
        label.contentInsets = MTEdgeInsets(top: Padding.label, left:  Padding.label, bottom:  Padding.label, right:  Padding.label)
        label.font = MTFontManager().defaultFont
        label.fontSize = size
        label.textAlignment = .right
        label.labelMode = .text
        label.textColor = HistoryAppearance.HistoryCellExample.resultColor.color()
        return label
    }()
    
    // MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.transform = CGAffineTransform(scaleX: -1, y: 1)
        self.contentView.addSubview(scrollView)
        self.contentView.addGestureRecognizer(scrollView.panGestureRecognizer)
        scrollView.addView(mathLabel)
        scrollLayoutConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func config(calculation: Calculation) {
        mathLabel.latex = generateLatex.generate(expression: calculation, formatting: { number in
            return dynamicNumberFormatter.perform(number)
        })
        heightConstraint.constant = mathLabel.intrinsicContentSize.height + 2 * Padding.cell
        layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mathLabel.latex = ""
    }
}

// MARK: - Layout
private extension ExpressionMathCell {
    func scrollLayoutConfiguration() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor)
        ])
        heightConstraint = scrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0)
        heightConstraint.priority = .defaultHigh
        heightConstraint.isActive = true
    }
}
