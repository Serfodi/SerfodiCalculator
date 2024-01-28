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
    case multiply = "×"
    case divide = "÷"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        try testOutRange(numbers: number1, number2)
        var result: Double = number2
        switch self {
        case .add:
            result = number1 + number2
        case .subtract:
            result = number1 - number2
        case .multiply:
            result = number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.dividedByZero
            }
            result = number1 / number2
        }
        try testOutRange(numbers: result)
        return result
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

extension Operation {
    
    func testOutRange(numbers: Double...) throws {
        var test = true
        for number in numbers {
            if number == 0 { continue }
            test = abs(number) < Double.greatestFiniteMagnitude && test
            test = abs(number) > abs(5E-300)  && test
        }
        if !test {
            throw CalculationError.outOfRang
        }
    }
    
}

