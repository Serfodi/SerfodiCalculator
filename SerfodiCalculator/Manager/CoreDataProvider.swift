//
//  CoreDataProvider.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 15.04.2024.
//

import UIKit


final class CoreDataProvider: NSObject {
    
    var historyManager: CoreDataManager
    
    init(historyManager: CoreDataManager) {
        self.historyManager = historyManager
    }
    
    func addCalculate(_ calculation: Calculation) {
        let historyCalculation = HistoryCalculation(calculation: calculation, date: Date())
        historyManager.add(historyCalculation)
    }
    
}


extension CoreDataProvider: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        historyManager.calculationsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExpressionMathCell.reuseId, for: indexPath) as! ExpressionMathCell
        let calculate = historyManager.calculation(at: indexPath.row)
        cell.config(calculation: calculate.calculation)
        return cell
    }
    
}
