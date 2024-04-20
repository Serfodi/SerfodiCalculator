//
//  ExpressionLatexLabel.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 07.04.2024.
//

import SwiftMath
import UIKit

class ExpressionMathCell: UITableViewCell, ExpressinCellConfiguration {
    
    static let reuseId = "ExpressionMathCell"
    
    private let dynamicNumberFormatter = DynamicNumberFormatter()
    private let generateLatex = GenerationLatex()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.scrollsToTop = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isUserInteractionEnabled = false
        scrollView.transform = CGAffineTransform(scaleX: -1, y: 1)
        return scrollView
    }()
    
    private let mathLabel: MTMathUILabel = {
        let label = MTMathUILabel()
        let font = MainFontAppearance.exampleFont
        let size = font.pointSize
        label.contentInsets = MTEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        label.font = MTFontManager().defaultFont
        label.fontSize = size
        label.textAlignment = .right
        label.textColor = HistoryAppearance.HistoryCellExample.resultColor.color()
        label.transform = CGAffineTransform(scaleX: -1, y: 1)
        return label
    }()
    
    public var cellHeight: CGFloat {
        mathLabel.intrinsicContentSize.height
    }
    
    // MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        scrollView.frame = self.bounds
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.addSubview(scrollView)
        self.contentView.addGestureRecognizer(scrollView.panGestureRecognizer)
        scrollView.addSubview(mathLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.contentSize = mathLabel.intrinsicContentSize
        mathLabel.frame = mathLabel.intrinsicContentSize.leftCentered(in: scrollView.rectInside())
    }
    
    
    // MARK: - override ExpressinCellConfiguration
    
    func config(calculation: Calculation) {
        mathLabel.latex = generateLatex.generate(expression: calculation, formatting: { number in
            do {
                return try dynamicNumberFormatter.fitInBounds(number: number) { numberText in
                    let attString = NSAttributedString(string: numberText, font: MainFontAppearance.exampleFont, textColor: .black)
                    return attString.size().width < (self.bounds.width / 2)
                }
            } catch {
                return String(describing: number)
            }
        })
    }
}


private extension UIScrollView {
    
    func updateScrollContentInset() {
        
        
        
    }
    
    func rectInside() -> CGRect {
        CGRect(origin: .zero,
               size: CGSize(width: self.bounds.width > self.contentSize.width ? self.bounds.width : self.contentSize.width,
                            height: self.bounds.height > self.contentSize.height ? self.bounds.height : self.contentSize.height))
    }
    
}
