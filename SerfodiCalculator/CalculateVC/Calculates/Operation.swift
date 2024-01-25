//
//  Operation.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 24.01.2024.
//

import Foundation

enum Operation: String {
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self {
        case .add:
            if number1 + number2 >= Double.greatestFiniteMagnitude || number1 + number2 <= Double.leastNonzeroMagnitude {
                throw CalculationError.outOfRang
            }
            return number1 + number2
        case .subtract:
            if number1 - number2 >= Double.greatestFiniteMagnitude || number1 - number2 <= Double.leastNonzeroMagnitude {
                throw CalculationError.outOfRang
            }
            return number1 - number2
        case .multiply:
            if number1 * number2 >= Double.greatestFiniteMagnitude || number1 * number2 <= Double.leastNonzeroMagnitude {
                throw CalculationError.outOfRang
            }
            return number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.dividedByZero
            }
            if number1 / number2 >= Double.greatestFiniteMagnitude || number1 / number2 <= Double.leastNonzeroMagnitude {
                throw CalculationError.outOfRang
            }
            return number1 / number2
        }
    }
    
    func priority() -> Int {
        switch self{
        case .add: return 1
        case .subtract: return 1
        case .multiply: return 2
        case .divide: return 2
        }
    }
    
}