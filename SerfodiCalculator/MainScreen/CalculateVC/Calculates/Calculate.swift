//
//  Calculate.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import Foundation


final class Calculator {
private
    /// Содержит исторю добавления опираций и числе по правилу: Число, опирация…
    var calculationHistory: [CalculationHistoryItem] = []
    
    let calculating: Calculate = DynamicCalculate()
    
    var currentOperation: Operation!
    var currentNumber: Double!
    
    var lastOperation: Operation? {
        calculationHistory.last?.operation
    }
    
    var lastNumber: Double? {
        calculationHistory.last?.number
    }
}

extension Calculator: CalculateManager {
    
    var countItems: Int {
        calculationHistory.count
    }
    
    func result() async throws -> Double {
        try calculating.calculate(items: calculationHistory)
    }
    
    /// Добалвяет новое число в массив: `calculationHistory`
    public func addNumber(_ number: Double) {
        if let _ = lastNumber { calculationHistory.removeLast() }
        calculationHistory.append(.number(number))
    }
    
    /// Добалвяет новоы знак в массив: "calculationHistory"
    public func addOperation(_ operation: Operation) {
        if let sign = lastOperation, sign.type == .binary {
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
    
    public func addLastOperation() {
        guard let lastOperation = currentOperation else { return }
        switch lastOperation.type {
        case .binary:
            guard let lastNumber = currentNumber else { return }
            addOperation(lastOperation)
            addNumber(lastNumber)
        case .unary:
            addOperation(lastOperation)
        }
    }
    
    public func removeHistory(completion: @escaping ([CalculationHistoryItem]) -> ()) {
        completion(calculationHistory)
        currentNumber = lastNumber
        calculationHistory.removeAll()
    }
    
    func eraseAll() {
        calculationHistory.removeAll()
        currentNumber = nil
        currentOperation = nil
    }
}
