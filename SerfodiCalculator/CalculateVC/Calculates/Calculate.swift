//
//  Calculate.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import Foundation


protocol Calculate {
    func calculate(items: [CalculationHistoryItem]) throws -> Double
}

final class Calculator {
    
    /// Содержит исторю добавления опираций и числе по правилу: Число, опирация…
    private var calculationHistory: [CalculationHistoryItem] = []
    
    /// Кол-во элементов в `calculationHistory`
    public var count: Int {
        calculationHistory.count
    }
    
    private let calculating: Calculate = DynamicCalculate()
    
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
    
    
    
    // MARK: - Calculating
    
    /// Вычисляет текущий пример.
    public func calculateResult() throws -> Double {
        try calculating.calculate(items: calculationHistory)
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
