//
//  HistoryTableViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 09.03.2024.
//

import UIKit

protocol ExpressinCellConfiguration {
    func config(calculation: Calculation)
}

final class HistoryTableView: UITableView {

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.backgroundColor = .clear
        self.tintColor = .clear
        self.rowHeight = UITableView.automaticDimension
        self.register(ExpressionMathCell.self, forCellReuseIdentifier: ExpressionMathCell.reuseId)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorStyle = .none
        self.alwaysBounceVertical = false
        
        self.updateTableContentInset()
    }
}

extension HistoryTableView {
        
    /// Переворачивает таблицу
    public func updateTableContentInset() {
        let numRows = numberOfRows(inSection: 0)
        var contentInsetTop = bounds.size.height
        for i in 0..<numRows {
            let rowRect = rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        contentInset = UIEdgeInsets(top: contentInsetTop + 5, left: 0, bottom: 5, right: 0)
    }
}
