//
//  HistoryTableViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 09.03.2024.
//

import UIKit

final class HistoryTableView: UITableView {

    private var isFitCell = true
    
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
        self.register(ExpressionCell.self, forCellReuseIdentifier: ExpressionCell.reuseId)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateTableContentInset()
        self.separatorStyle = .none
        self.alwaysBounceVertical = false
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
        contentInset = UIEdgeInsets(top: contentInsetTop, left: 0, bottom: 10, right: 0)
    }
    
    public func scrollToBottom(animated: Bool = true) {
        guard let lastIndex = lastIndexPath() else { return }
        self.scrollToRow(at: lastIndex as IndexPath, at: .bottom, animated: animated)
    }
}

extension UITableView {
    
    func lastIndexPath() -> IndexPath? {
        let lastSection = numberOfSections
        guard lastSection > 0 else { return nil }
        let numRows = numberOfRows(inSection: lastSection - 1)
        guard numRows > 0 else { return nil }
        let lastIndex = NSIndexPath(row: numRows - 1, section: 0)
        return lastIndex as IndexPath
    }
}
