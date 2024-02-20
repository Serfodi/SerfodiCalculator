//
//  DynamicCalculate.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 31.01.2024.
//

import Foundation

final class DynamicCalculate: Calculate {
    
    public func calculate(items: [CalculationHistoryItem]) throws -> Double {
        let postfix = toPostfix(calculationHistory: items)
        return try calculating(items: postfix)
    }
    
    /// Вычисляет пример состоящий и числе и опираций `CalculationHistoryItem`.
    /// Записанный в постфексной нотации.
    ///
    /// - Parameter postfix: Массив из опираци и чисел записанный в постфиксной нотоации
    ///
    /// - Returns: Вычиселнное число для  текующий последовательности опираций и чисел
    ///
    private func calculating(items: [CalculationHistoryItem]) throws -> Double {
        
        var result: Double = 0
        var stack = [Double]()
        
        for index in items {
            switch index {
                
            case .number(let number):
                stack.append(number)
                
            case .operation(let operation):
                
                switch operation.type() {
                case .binary:
                    guard let two = stack.popLast(), let one = stack.popLast() else { break }
                    result = try operation.calculate(one, two)
                case .unary:
                    guard let one = stack.popLast() else { break }
                    result = try operation.calculate(one)
                }
                
                stack.append(result)
            }
        }
        
        guard let resultLast = stack.popLast() else { return result }
        result = resultLast
        
        return result
    }
    
    /// Транслирует последовательный массив из математических операций и числе в  постфиксную нотацию.
    /// Соблюдает приоритет операций.
    /// Отрезает последнюю не значащую операцию.
    ///
    /// Если последняя опирация была выше по приоритету, то вычисляет сначала высшие оприрации, затем остальное.
    ///
    /// - Parameter calculationHistory: Последовательный массив состоящий из чисел и опираций над ними. Первый элемент всегда число, потом опирация и тд.
    ///
    /// - Returns: Массив чисел и опираций в постфиксной нотации.
    ///
    private func toPostfix(calculationHistory: [CalculationHistoryItem]) -> [CalculationHistoryItem] {
        var items = calculationHistory
        var lastInputSign: Operation!
        
        if case .operation(let operation) = items.last {
            if operation.type() == .binary {
                items.removeLast()
                lastInputSign = operation
            }
        }
        
        var stack = [CalculationHistoryItem]()
        var output = [CalculationHistoryItem]()
         
        for index in items {
            switch index {
            case .number(_):
                output.append(index)
            case .operation(let operation):
                while let last = stack.last, case .operation(let lastOp) = last, operation.priority() <= lastOp.priority() {
                    output.append(stack.removeLast())
                }
                stack.append(index)
            }
        }
        output += stack.reversed()
                
        if let lastSign = lastInputSign {
            if case .operation(let operation) = output.last {
                if lastSign.priority() > operation.priority(), !output.isEmpty {
                    output.removeLast()
                }
            }
        }
        return output
    }
    
    
}
