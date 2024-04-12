//
//  DataProvider.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 01.02.2024.
//

import UIKit


final class DataProvider: NSObject {
    
    var historyManager: HistoryManager
    
    init(historyManager: HistoryManager) {
        self.historyManager = historyManager
    }
    
    func reload() {
        historyManager = HistoryManager()
    }
}


extension DataProvider: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyManager.calculationsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpressionCell.reuseId, for: indexPath) as! ExpressionCell
        let calculate = historyManager.calculation(at: indexPath.row)
        cell.config(calculation: calculate)
        return cell
    }
}
