//
//  Calculation.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import UIKit

struct Calculation {
    let expression: [CalculationHistoryItem]
    let result: Double
}

extension Calculation {
    
    private var firstOperationItem: CalculationHistoryItem? {
        expression.first { item in
            if case .operation(_) = item {
                return true
            }
            return false
        }
    }
    
    public var firstOperation: Operation? {
        if case let .operation(oper) = firstOperationItem {
            return oper
        }
        return nil
    }
    
}

extension Calculation: Codable {}
