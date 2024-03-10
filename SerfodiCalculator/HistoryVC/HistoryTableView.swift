//
//  HistoryTableViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 09.03.2024.
//

import UIKit

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
        
        self.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseId)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateTableContentInset()
        self.separatorStyle = .none
    }
    
}
