//
//  Calculate.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import Foundation


final class Calculator {
    
    var isInput = true
    
private
    /// Содержит исторю добавления опираций и числе по правилу: Число, опирация…
    var calculationHistory: [CalculationItem] = []
    
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
    
    var isNewInput: Bool {
        isInput
    }
    
    var countItems: Int {
        calculationHistory.count
    }
    
    func result() async throws -> Double {
        try calculating.calculate(items: calculationHistory)
    }
    
    public func addNumber(_ number: Double) {
        if let _ = lastNumber { calculationHistory.removeLast() }
        calculationHistory.append(.number(number))
    }
    
    public func addOperation(_ operation: Operation) {
        if let sign = lastOperation, sign.type == .binary {
            guard sign != operation else { return }
            calculationHistory.removeLast()
            calculationHistory.append(.operation(operation))
            currentOperation = operation
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
    
    public func removeHistory(completion: @escaping ([CalculationItem]) -> ()) {
        completion(calculationHistory)
        calculationHistory.removeAll()
    }
    
    func eraseAll() {
        calculationHistory.removeAll()
        currentNumber = nil
        currentOperation = nil
    }
}
