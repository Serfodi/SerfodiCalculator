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
//        self.rowHeight = UITableView.automaticDimension
        self.register(ExpressionMathCell.self, forCellReuseIdentifier: ExpressionMathCell.reuseId)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorStyle = .none
        self.alwaysBounceVertical = true
    }
}
