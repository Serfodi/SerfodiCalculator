//
//  CalculationItemParser.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.04.2024.
//

import Foundation

protocol ItemParser: AnyObject {
    func parsing(items: [CalculationItem], isFinal: Bool) -> [CalculationItem]
}

final class CalculationItemParser: ItemParser {
    
    func parsing(items: [CalculationItem], isFinal: Bool) -> [CalculationItem] {
        var items = items
        
        if !isFinal, let prepareItem = priorityCalculate(items: items) {
            items = prepareItem
        }
        
        removeLastBinaryOperation(items: &items)
        
        return toPostfix(items: items)
    }
    
    private func toPostfix(items: [CalculationItem]) -> [CalculationItem] {
        var stack = [CalculationItem]()
        var output = [CalculationItem]()
        for item in items {
            switch item {
            case .number(_):
                output.append(item)
            case .operation(let operation):
                while let last = stack.last, case .operation(let lastOp) = last, operation.priority >= lastOp.priority {
                    output.append(stack.removeLast())
                }
                stack.append(item)
            }
        }
        output += stack.reversed()
        return output
    }
    
    // MARK: points Inflection
    
    private func priorityCalculate(items: [CalculationItem]) -> [CalculationItem]? {
        let point = pointsInflection(items)
        if let point = point, (point + 1) < items.count {
            let slice = items[(point+1)...]
            return Array(slice)
        }
        return nil
    }
    
    private func removeLastBinaryOperation(items: inout [CalculationItem]) {
        guard let operation = items.last?.operation else { return }
        if operation.type == .binary {
            items.removeLast()
        }
    }
    
    private func pointsInflection(_ items: [CalculationItem]) -> Int? {
        var currentOperation: Operation?
        var currentIndex: Int?
        for (index, item) in items.enumerated() {
            guard let operation = item.operation else { continue }
            if currentOperation == nil {
                currentOperation = operation
                currentIndex = index
                continue
            }
            if operation.priority >= currentOperation!.priority {
                currentOperation = operation
                currentIndex = index
            }
        }
        return currentIndex
    }
}
