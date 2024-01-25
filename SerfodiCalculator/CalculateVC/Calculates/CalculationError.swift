//
//  CalculationError.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import Foundation

// MARK: Calculation Error

/// Ошибки связанные с вычислениями
enum CalculationError: Error {
    case dividedByZero
    case fewOperations
    case outOfRang
}


// MARK: Decoder Error

/// Ошибки связанные с получением данных из памяти
enum CalculationHistoryItemError: Error {
    case itemNotFound
}
