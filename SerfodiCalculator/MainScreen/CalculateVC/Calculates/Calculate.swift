//
//  Calculate.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import Foundation


protocol CalculateManager {
    var isNewInput: Bool { get }
    func endNewInput()
    func result(isFinal: Bool) async throws -> Double
    func addNumber(_ number: Double)
    func addOperation(_ operation: Operation)
    func repeatsEqual()
    func equal(result: Double, completion: @escaping ([CalculationItem]) -> ())
    func eraseAll()
}


final class Calculator {
    
    let calculating: Calculate = DynamicCalculate()
    /// Содержит исторю добавления опираций и числе по правилу: Число, опирация…
    var calculationHistory: [CalculationItem] = [.number(0)]
    
    var isInput = true
    var lastResult: Double?
    var currentOperation: Operation?
    var currentNumber: Double?
    
    // MARK: - calculate var
    
    var lastOperation: Operation? {
        calculationHistory.last?.operation
    }
    
    var lastNumber: Double? {
        calculationHistory.last?.number
    }
    
    // MARK: - func
    
    func addLastOperation() {
        guard let operation = currentOperation else { return }
        addOperation(operation)
    }
    
    func addLastNumber() {
        if let number = currentNumber {
            addNumber(number)
        } else {
            guard let result = lastResult else { return }
            addNumber(result)
        }
    }
    
    func startNewInput() { isInput = true }
    
    func removeHistory(completion: @escaping ([CalculationItem]) -> ()) {
        currentNumber = lastNumber
        completion(calculationHistory)
        calculationHistory.removeAll()
        startNewInput()
    }
    
    func reset() {
        isInput = true
        lastResult = nil
        calculationHistory = [.number(0)]
        currentOperation = nil
        currentNumber = nil
    }
}

// MARK: - Calculate Manager
extension Calculator: CalculateManager {
    
    var isNewInput: Bool { isInput }
    
    func endNewInput() { isInput = false }
        
    func result(isFinal: Bool) async throws -> Double {
        lastResult = try calculating.calculate(items: calculationHistory, isFinal: isFinal)
        return lastResult!
    }
    
    func addNumber(_ number: Double) {
        if let lastOperation = lastOperation, lastOperation.type == .unary {
            reset()
            currentOperation = lastOperation
        }
        if let _ = lastNumber { calculationHistory.removeLast() }
        calculationHistory.append(.number(number))
    }
    
    func addOperation(_ operation: Operation) {
        if let last = lastOperation, last.type == .binary {
            guard last != operation else { return }
            calculationHistory.removeLast()
        }
        calculationHistory.append(.operation(operation))
        currentOperation = operation
        startNewInput()
    }
    
    func repeatsEqual() {
        guard isNewInput else { return }
        if let lastOperation = lastOperation, lastOperation.type == .unary { return }
        guard let operation = currentOperation else { return }
        addLastOperation()
        if operation.type == .binary {
            addLastNumber()
        }
    }

    func equal(result: Double, completion: @escaping ([CalculationItem]) -> ()) {
        removeHistory(completion: completion)
        addNumber(result)
        startNewInput()
    }
    
    func eraseAll() {
        reset()
    }
}
