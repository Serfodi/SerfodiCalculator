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

extension Calculation: Codable {}
