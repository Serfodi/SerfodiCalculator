//
//  Operation.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 24.01.2024.
//

import Foundation

enum TypeOperation: Int {
    case binary = 2
    case unary = 1
}

enum Operation: Int {
    // binary
    case add = 1
    case subtract = 2
    case multiply = 3
    case divide = 4
    case powXY = 5
    case powYX = 6
    case rootYX = 7
    
    // unary
    case precent = 8
    case pow2 = 9
    case pow3 = 10
    case powEX = 11
    case pow10X = 12
    case pow2X = 13
    case divisionByOne = 14
    case root2 = 16
    case root3 = 15
    case lnX = 17
    case log10X = 18
    case logY = 19
    case log2X = 20
    case factorial = 21
    case sinX = 22
    case cosX = 23
    case tanX = 24
    case sinhX = 25
    case coshX = 26
    case tanhX = 27
}

extension Operation {
    
    var type: TypeOperation {
        switch self {
        case .add, .subtract, .multiply, .divide, .powXY, .powYX, .rootYX:
            return .binary
        case .precent, .pow2, .pow3, .powEX, .pow10X, .pow2X,
                .divisionByOne, .root2, .root3, .lnX, .log10X, .logY, .log2X, .factorial,
                .sinX, .cosX, .tanX, .sinhX, .coshX, .tanhX:
            return .unary
        }
    }
    
    var priority: Int {
        switch self {
        case .logY, .powXY, .powYX, .rootYX:
            return 0
        case .add, .subtract:
            return 1
        case .multiply, .divide:
            return 2
        case .sinX, .cosX, .tanX, .sinhX, .coshX, .tanhX,
                .precent, .pow2, .pow3, .powEX, .pow10X, .pow2X,
                .root2, .root3, .factorial, .divisionByOne,
                .lnX, .log10X, .log2X:
            return 3
        }
    }
}

// MARK: Symbol

extension Operation {
    
    func symbol() -> String {
        switch self {
            
        case .add:
            return "+"
        case .subtract:
            return "–"
        case .multiply:
            return "×"
        case .divide:
            return "÷"
        case .precent:
            return "%"
            
        case .pow2:
            return "x²"
        case .pow3:
            return "x³"
        case .powXY:
            return "xʸ"
        case .powYX:
            return "yˣ"
        case .powEX:
            return "eˣ"
        case .pow10X:
            return "10ˣ"
        case .pow2X:
            return "2ˣ"
        
        case .divisionByOne:
            return "1/x"
        case .root2:
            return "√x"
        case .root3:
            return "∛x"
        case .rootYX:
            return "ʸ√x"
            
        case .lnX:
            return "ln"
        case .log10X:
            return "log₁₀"
        case .logY:
            return "logY"
        case .log2X:
            return "log₂"
            
        case .factorial:
            return "!x"
            
        case .sinX:
            return "sin"
        case .cosX:
            return "cos"
        case .tanX:
            return "tan"
        case .sinhX:
            return "sinh"
        case .coshX:
            return "cosh"
        case .tanhX:
            return "tanh"
        }
    }
}


// MARK: Calculate

extension Operation {
    
    func calculate(_ numbers: [Double]) throws -> Double {
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
            
        case .precent:
            result = numbers[0] / 100
            
        case .pow2:
            result = pow(numbers[0], 2)
            
        case .root2:
            if numbers[0] < 0 {
                throw CalculationError.dividedByZero
            }
            result = pow(numbers[0], 0.5)
            
        case .root3:
            if numbers[0] < 0 {
                throw CalculationError.dividedByZero
            }
            result = pow(numbers[0], 1 / 3)
        case .rootYX:
            if numbers[1] < 0 {
                throw CalculationError.dividedByZero
            }
            result = pow(numbers[0], 1 / numbers[1])
        case .pow3:
            if numbers[0] < 0 {
                throw CalculationError.dividedByZero
            }
            result = pow(numbers[0], 3)
        case .powXY:
            if numbers[0] < 0 {
                throw CalculationError.dividedByZero
            }
            result = pow(numbers[0], numbers[1])
        case .powYX:
            if numbers[1] < 0 {
                throw CalculationError.dividedByZero
            }
            result = pow(numbers[1], numbers[0])
        case .powEX:
            result = pow(exp(1), numbers[0])
        case .pow10X:
            result = pow(10, numbers[0])
        case .pow2X:
            result = pow(2, numbers[0])
        case .divisionByOne:
            result = 1 / numbers[0]
            
        case .lnX:
            result = log(numbers[0])
        case .log10X:
            result = log10(numbers[0])
        case .logY:
            result = log(numbers[0]) / log(numbers[1])
        case .log2X:
            result = log2(numbers[0])
            
        case .factorial:
            
            if numbers[0].truncatingRemainder(dividingBy: 1) == 0 {
                result = Double( factorial(numbers[0]))
            } else {
                result = approximateFactorial(for: numbers[0])
            }
            
        case .sinX:
            if abs(numbers[0]) > 1 {
                throw CalculationError.dividedByZero
            }
            result = sin(numbers[0])
            
        case .cosX:
            if abs(numbers[0]) > 1 {
                throw CalculationError.dividedByZero
            }
            result = cos(numbers[0])
        case .tanX:
            result = tanh(numbers[0])
        case .sinhX:
            result = sinh(numbers[0])
        case .coshX:
            result = cosh(numbers[0])
        case .tanhX:
            result = tanh(numbers[0])
        }
        
        try testOutRange(numbers: [result])
        return result
    }
    
    private func factorial(_ n: Double) -> Double {
        var result = 1.0
        var i = 1.0
        while i <= n {
            result *= i
            i += 1.0
        }
        return result
    }
    
    // MARK: FIX IT LOW precision
    func approximateFactorial(for number: Double) -> Double {
        let pi = Double.pi
        return sqrt(2 * pi * number) * pow(number / exp(1), number)
    }
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
