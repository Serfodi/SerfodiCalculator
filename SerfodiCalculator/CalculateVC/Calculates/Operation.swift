//
//  Operation.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 24.01.2024.
//

import Foundation

enum TypeOperation {
    case binary
    case unary
}

enum Operation: String {
    case add = "+"
    case subtract = "–"
    case multiply = "×"
    case divide = "÷"
    case pow2 = "x²"
    
    func type() -> TypeOperation {
        switch self {
        case .add, .subtract, .multiply, .divide: return .binary
        case .pow2: return .unary
        }
    }
    
    func priority() -> Int {
        switch self {
        case .add, .subtract: return 1
        case .multiply, .divide: return 2
        case .pow2: return 0
        }
    }
    
}

// MARK: Calculate

extension Operation {
    
    func calculate(_ numbers: Double...) throws -> Double {
        try testOutRange(numbers: numbers)
        
        var result: Double = numbers[0]
        switch self {
        case .add:
            result = numbers[0] + numbers[1]
        case .subtract:
            result = numbers[0] - numbers[1]
        case .multiply:
            result = numbers[0] * numbers[1]
        case .divide:
            if numbers[1] == 0 {
                throw CalculationError.dividedByZero
            }
            result = numbers[0] / numbers[1]
        case .pow2:
            result = pow(numbers[0], 2)
        }
        
        try testOutRange(numbers: [result])
        return result
    }
    
    
//    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
//        try testOutRange(numbers: number1, number2)
//
//        var result: Double = number2
//        switch self {
//        case .add:
//            result = number1 + number2
//        case .subtract:
//            result = number1 - number2
//        case .multiply:
//            result = number1 * number2
//        case .divide:
//            if number2 == 0 {
//                throw CalculationError.dividedByZero
//            }
//            result = number1 / number2
//        }
//
//        try testOutRange(numbers: result)
//        return result
//    }
    
}

// MARK: Test

extension Operation {
    
    func testOutRange(numbers: [Double]) throws {
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

