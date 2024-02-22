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

enum Operation: Int {
    
    case add = 1
    case subtract = 2
    case multiply = 3
    case divide = 4
    case precent = 5
    
    case pow2 = 101
    case pow3 = 102
    case powXY = 103
    case powYX = 104
    case powEX = 105
    case x10 = 106
    case x2 = 107
    
    case divide1 = 200
    case sqrt2x = 201
    case sqrt3x = 202
    case sqrtYX = 203
    
    case lnX = 301
    case log10X = 302
    case logY = 303
    case log2X = 304
    
    case factX = 400
    
    case sinX = 501
    case cosX = 502
    case tanX = 503
    case sinhX = 504
    case coshX = 505
    case tanhX = 506
    
}

extension Operation {
    
    func type() -> TypeOperation {
        switch self {
        case .add, .subtract, .multiply, .divide, .powXY, .powYX, .sqrtYX:
            return .binary
        default:
            return .unary
        }
    }
    
    func priority() -> Int {
        switch self {
        case .add, .subtract: return 1
        case .multiply, .divide: return 2
        default:
            return 0
        }
    }
    
}


extension Operation {
    
    func getLiterallySymbol() -> String {
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
        case .x10:
            return "10ˣ"
        case .x2:
            return "2ˣ"
        
        case .divide1:
            return "1/x"
        case .sqrt2x:
            return "√x"
        case .sqrt3x:
            return "∛x"
        case .sqrtYX:
            return "ʸ√x"
            
        case .lnX:
            return "ln"
        case .log10X:
            return "log₁₀"
        case .logY:
            return "logY"
        case .log2X:
            return "log₂"
            
        case .factX:
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
            
        case .precent:
            result = numbers[0] / 100
            
        case .pow2:
            result = pow(numbers[0], 2)
            
        case .sqrt2x:
            if numbers[0] < 0 {
                throw CalculationError.dividedByZero
            }
            result = pow(numbers[0], 0.5)
            
        case .sqrt3x:
            if numbers[0] < 0 {
                throw CalculationError.dividedByZero
            }
            result = pow(numbers[0], 1 / 3)
        case .sqrtYX:
            if numbers[0] < 0 {
                throw CalculationError.dividedByZero
            }
            result = pow(numbers[0], numbers[1])
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
        case .x10:
            result = pow(10, numbers[0])
        case .x2:
            result = pow(2, numbers[0])
        case .divide1:
            result = 1 / numbers[0]
            
        case .lnX:
            result = log(numbers[0])
        case .log10X:
            result = log10(numbers[0])
        case .logY:
            result = log(numbers[0]) / log(numbers[1])
        case .log2X:
            result = log2(numbers[0])
            
        case .factX:
            
            if numbers[0].truncatingRemainder(dividingBy: 1) == 0 {
                result = Double( factorial(Int(numbers[0])) )
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
    
    
    private func factorial(_ n: Int) -> Int {
        var result = 1
        var i = 1
        while i <= n {
            result *= i
            i += 1
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

