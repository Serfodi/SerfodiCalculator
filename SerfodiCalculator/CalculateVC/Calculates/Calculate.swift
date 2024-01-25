//
//  Calculate.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import Foundation

final class Calculator {
    
    /// Содержит исторю добавления опираций и числе по правилу: Число, опирация…
    private var calculationHistory: [CalculationHistoryItem] = []
    
    /// Кол-во элементов в `calculationHistory`
    public var count: Int {
        calculationHistory.count
    }
    
    /// Предпоследния опирация
    private var currentOperation: Operation!
    /// Предпоследнее число
    private var currentNumber: Double!
    
    
    private var lastOperation: Operation? {
        if case .operation(let operation) = calculationHistory.last {
            return operation
        }
        return nil
    }
    
    private var lastNumber: Double? {
        if case .number(let number) = calculationHistory.last {
            return number
        }
        return nil
    }
    
    
    
    // MARK: - Calculate
    
    /// Вычисляет текущий пример.
    public func calculateResult() throws -> Double {
        let postfix = toPostfix(calculationHistory: calculationHistory)
        let result = try calculate(postfix: postfix)
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
            items.removeLast()
            lastInputSign = operation
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
    
    /// Вычисляет пример состоящий и числе и опираций `CalculationHistoryItem`.
    /// Записанный в постфексной нотации.
    ///
    /// - Parameter postfix: Массив из опираци и чисел записанный в постфиксной нотоации
    ///
    /// - Returns: Вычиселнное число для  текующий последовательности опираций и чисел
    ///
    private func calculate(postfix: [CalculationHistoryItem]) throws -> Double {
        guard postfix.count >= 2 else { throw CalculationError.fewOperations }
        
        var result: Double = 0
        var stack = [Double]()
        
        for index in postfix {
            switch index {
            case .number(let number):
                stack.append(number)
            case .operation(let operation):
                switch operation {
                case .add, .subtract, .multiply, .divide:
                    guard let two = stack.popLast(), let one = stack.popLast() else { break }
                    result = try operation.calculate(one, two)
                }
                stack.append(result)
            }
        }
        guard let resultLast = stack.popLast() else { return result }
        result = resultLast
        
        return result
    }
    
    
    
    
    // MARK: - Add items
    
    /// Добалвяет новое число в массив: `calculationHistory`
    public func addNumber(_ number: Double) {
        if let _ = lastNumber { calculationHistory.removeLast() }
        calculationHistory.append(.number(number))
    }
    
    /// Добалвяет новоы знак в массив: "calculationHistory"
    public func addOperation(_ operation: Operation) {
        if let sign = lastOperation {
            if sign != operation {
                calculationHistory.removeLast()
                calculationHistory.append(.operation(operation))
                currentOperation = operation
            }
        } else {
            calculationHistory.append(.operation(operation))
            currentOperation = operation
        }
    }
    
    /// Добовляет опирации для повторного вычисления при нажатии на `Равно "="`.
    /// Берет последнии действия, если они есть, и добовляет их в масив `calculationHistory`
    public func addLastOperation() {
        guard let lastNumber = currentNumber,
              let lastOperation = currentOperation
        else { return }
        addOperation(lastOperation)
        addNumber(lastNumber)
    }
    
    
    
    // MARK: - Remove
    
    public func removeLastOperation() {
        guard let _ = lastOperation else { return }
        calculationHistory.removeLast()
    }
    
    /// Удаляет массив исории `calculationHistory`
    /// Запоминает последнее введое число `lastNumber`
    ///
    /// - Parameter completion: Принимает текущию массив `calculationHistory` до удаления.
    ///
    public func removeHistory(completion: @escaping ([CalculationHistoryItem]) -> ()) {
        completion(calculationHistory)
        currentNumber = lastNumber
        calculationHistory.removeAll()
    }
    
    public func removeAll() {
        calculationHistory.removeAll()
        currentNumber = nil
        currentOperation = nil
    }
    
}
