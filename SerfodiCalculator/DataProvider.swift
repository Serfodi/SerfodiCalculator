//
//  DataProvider.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 01.02.2024.
//

import UIKit


final class DataProvider: NSObject {
    
    public var historyManager: HistoryManager?
    
}

extension DataProvider: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let manager = historyManager else { return 0 }
        return manager.calculationsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HistoryCell.reuseId, for: indexPath) as! HistoryCell
        guard let manager = historyManager else { fatalError("HistoryManager is nil!") }
        let calculate = manager.calculation(at: indexPath.row)
        cell.config(calculation: calculate)
        return cell
    }
    
}
