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

enum CalculationHistoryItem {
    /// Число
    case number(Double)
    /// Опирация
    case operation(Operation)
    
}


final class Calculator {
    
    var calculationHistory: [CalculationHistoryItem] = []
    
    public var count: Int {
        calculationHistory.count
    }
    
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
    
    
    public func calculateResult(completion: @escaping (Double?, Error?) -> Void) {
        do {
            let postfix = toPostfix(calculationHistory: calculationHistory)
            let result = try calculate(postfix: postfix)
            completion(result, nil)
        } catch (let error) {
            completion(nil, error)
        }
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
                
        if let op = lastOperator {
            if case .operation(let operation) = output.last {
                if op.priority() > operation.priority(), !output.isEmpty {
                    output.removeLast()
                }
            }
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
        
        print("=\(result)")
        return result
    }
    
    
    public func addNumber(_ number: Double) {
        calculationHistory.append(.number(number))
        print(number)
    }
    
    public func addOperation(_ operation: Operation) {
        if let ope = lastOperation {
            if ope != operation {
                removeLastOperation()
                calculationHistory.append(.operation(operation))
                print("\(ope.rawValue) -> \(operation.rawValue)")
            }
        } else {
            calculationHistory.append(.operation(operation))
            print(operation.rawValue)
        }
    }
    
    public func removeLastOperation() {
        if let op = lastOperation {
            calculationHistory.removeLast()
            print("Удалили знак: \(op.rawValue)")
        }
    }
    
    public func removeLastNumber() {
        if let nn = lastNumber {
            calculationHistory.removeLast()
            print("Удалили число: \(nn)")
        }
    }
    
    
    public func removeHistory(completion: @escaping ([CalculationHistoryItem]) -> ()) {
        completion(calculationHistory)
        calculationHistory.removeAll()
        print("Удалили все.")
    }
    public func removeHistory() {
        calculationHistory.removeAll()
        print("Удалили все.")
    }
    
    
    
    
}
