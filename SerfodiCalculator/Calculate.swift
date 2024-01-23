//
//  Calculate.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import Foundation

enum Operation: String {
    
    case add = "+"
    case subtract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self{
        case .add:
            return number1 + number2
        case .subtract:
            return number1 - number2
        case .multiply:
            return number1 * number2
        case .divide:
            if number2 == 0 {
                throw CalculationError.dividedByZero
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

enum CalculationHistoryItem: Equatable {
    /// Число
    case number(Double)
    /// Опирация
    case operation(Operation)
    
}

final class Calculator {
    
    private var calculationHistory: [CalculationHistoryItem] = []
    
    
    public var lastOperation: Operation? {
        if case .operation(let operation) = calculationHistory.last {
            return operation
        }
        return nil
    }
    
    public var lastNumber: Double? {
        if case .number(let number) = calculationHistory.last {
            return number
        }
        return nil
    }
    
    private var currentResult: Double = 0
    
    
    public func calculateResult(completion: @escaping (Double?, Error?) -> Void) {
        do {
            let postfix = toPostfix(calculationHistory: calculationHistory)
            let result = try calculate(postfix: postfix)
            currentResult = result
            completion(result, nil)
        } catch (let error) {
            completion(nil, error)
        }
    }
    
    public func addNumber(_ number: Double) {
        if let lastNumber = lastNumber, lastNumber != number {
            calculationHistory.removeLast()
        }
        calculationHistory.append(.number(number))
    }
    
    public func addOperation(_ operation: Operation) {
        if let lastOperation = lastOperation, lastOperation != operation {
            calculationHistory.removeLast()
        }
        calculationHistory.append(.operation(operation))
    }
    
    public func removeLastOperation() {
        if let _ = lastOperation {
            calculationHistory.removeLast()
        }
    }
    
    public func removeLastNumber() {
        if let _ = lastNumber {
            calculationHistory.removeLast()
        }
    }
    
    
    
    public func removeHistory(completion: @escaping ([CalculationHistoryItem]) -> ()) {
        var newHistory: [CalculationHistoryItem] = [ .number(currentResult) ]
        if let number = calculationHistory.popLast(), let operation = calculationHistory.popLast() {
            newHistory.append(operation)
            newHistory.append(number)
        }
        completion(calculationHistory)
        calculationHistory.removeAll()
        calculationHistory = newHistory
    }
    
    public func removeHistory() {
        calculationHistory.removeAll()
    }
    
    
    
    
    private func toPostfix(calculationHistory: [CalculationHistoryItem]) -> [CalculationHistoryItem] {
        var items = calculationHistory
        var lastOperator: Operation!
        
        if case .operation(let operation) = items.last {
            items.removeLast()
            lastOperator = operation
        }
        
        var stack = [CalculationHistoryItem]()
        var output = [CalculationHistoryItem]()
         
        for index in items {
            if case .number(_) = index {
                output.append(index)
            } else if case .operation(let operation) = index {
                while let last = stack.last, case .operation(let lastOp) = last, operation.priority() <= lastOp.priority() {
                    output.append(stack.removeLast())
                }
                stack.append(index)
            }
        }
        output += stack.reversed()
        
        if let op = lastOperator, op.priority() > 1, !output.isEmpty {
            output.removeLast()
        }
        
        return output
    }
    
    private func calculate(postfix: [CalculationHistoryItem]) throws -> Double {
        
        guard case .number(let lastNumber) = calculationHistory.first else { return 0 }
        var result = lastNumber
        
        var stack = [Double]()
        
        for index in postfix {
            if case .number(let number) = index {
                stack.append(number)
                result = number
                
            } else if case .operation(let operation) = index {
                guard let two = stack.popLast(), let one = stack.popLast() else { return result }
                let calculate = try operation.calculate(one, two)
                stack.append(calculate)
                result = calculate
            }
        }
        
        guard let resultLast = stack.popLast() else { return result }
        result = resultLast
        
        return result
    }
    
    
}
