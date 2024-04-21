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
    
    var lastSection: Int? {
        let lastSection = numberOfSections
        guard lastSection > 0 else { return nil }
        return lastSection - 1
    }
    
    var lastRows: Int? {
        guard let lastSection = lastSection else { return nil }
        let numRows = numberOfRows(inSection: lastSection)
        guard numRows > 0 else { return nil }
        return numRows - 1
    }
    
    func lastIndexPath() -> IndexPath? {
        guard let lastSection = lastSection,
              let lastRows = lastRows
        else { return nil }
        let lastIndex = IndexPath(row: lastRows, section: lastSection)
        return lastIndex
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
