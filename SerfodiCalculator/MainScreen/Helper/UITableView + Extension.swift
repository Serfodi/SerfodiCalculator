//
//  UITableView + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 20.04.2024.
//

import UIKit

extension UITableView {
    
    public func scrollToBottom(animated: Bool = true) {
        guard let lastIndex = lastIndexPath() else { return }
        self.scrollToRow(at: lastIndex, at: .bottom, animated: animated)
    }
        
    var lastRows: Int? {
        let numRows = numberOfRows(inSection: 0)
        guard numRows > 0 else { return nil }
        return numRows
    }
    
    func lastIndexPath() -> IndexPath? {
        guard let lastRows = lastRows else { return nil }
        let lastIndex = IndexPath(row: lastRows - 1, section: 0)
        return lastIndex
    }
    
    func animatedInsertLastRow() {
        let rows = numberOfRows(inSection: 0)
        performBatchUpdates {
            insertRows(at: [IndexPath(row: rows, section: 0)], with: .bottom)
        }
        scrollToBottom(animated: true)
    }
}

extension UITableView {
        
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
        contentInset = UIEdgeInsets(top: contentInsetTop + 15, left: 0, bottom: 15, right: 0)
    }
    
    public func reversInset() {
        contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    
}
