//
//  CalculationError.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import Foundation

// MARK: - Calculation Error

/// Ошибки связанные с вычислениями
enum CalculationError: Error {
    case dividedByZero
    case outOfRang
}


// MARK: - Decoder Error

/// Ошибки связанные с получением данных из памяти
enum CalculationHistoryItemError: Error {
    case itemNotFound
}


// MARK: - Dynamic Number Formatter Error

enum DynamicNumberFormatterError: Error {
    case fitFormattingFailure(number: NSNumber)
    
    func description() -> String {
        switch self {
        case .fitFormattingFailure(let number):
            return "Не получилось вписать число по заданному предикату! Переданное число: \(number)"
        }
    }
}
