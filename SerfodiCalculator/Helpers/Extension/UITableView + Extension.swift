//
//  UITableView + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 24.01.2024.
//

import UIKit

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
        contentInset = UIEdgeInsets(top: contentInsetTop, left: 0, bottom: 10, right: 0)
    }
    
    /// Переворачивает таблицу показывает последнуюю ячейку
    public func showLastCell(animated: Bool = true) {
        let numRows = numberOfRows(inSection: 0)
        guard numRows > 0 else { return }
        let lastIndex = NSIndexPath(row: numRows - 1, section: 0)
        scrollToRow(at: lastIndex as IndexPath, at: .bottom, animated: animated)
    }
    
    
}
