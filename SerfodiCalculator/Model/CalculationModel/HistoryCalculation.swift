//
//  HistoryCalculation.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 17.04.2024.
//

import Foundation

struct HistoryCalculation {
    let calculation: Calculation
    let date: Date
}

extension HistoryCalculation: Codable {}
