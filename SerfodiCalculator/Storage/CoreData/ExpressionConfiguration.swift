//
//  ExpressionConfiguration.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 10.04.2024.
//

import Foundation

class ExpressionConfiguration: NSObject {
    
    let expression: [CalculationHistoryItem]
    
    init(expression: [CalculationHistoryItem]) {
        self.expression = expression
        super.init()
    }
}
