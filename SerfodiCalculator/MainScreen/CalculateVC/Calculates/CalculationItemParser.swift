//
//  CalculationItemParser.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.04.2024.
//

import Foundation

protocol ItemParser: AnyObject {
    func parsing(items: [CalculationItem]) -> [CalculationItem]
}

final class CalculationItemParser: ItemParser {
    
    func parsing(items: [CalculationItem]) -> [CalculationItem] {
        toPostfix(items: items)
    }
    
    private func toPostfix(items: [CalculationItem]) -> [CalculationItem] {
        var stack = [CalculationItem]()
        var output = [CalculationItem]()
        for item in items {
            switch item {
            case .number(_):
                output.append(item)
            case .operation(let operation):
                while let last = stack.last, case .operation(let lastOp) = last, operation.priority <= lastOp.priority {
                    output.append(stack.removeLast())
                }
                stack.append(item)
            }
        }
        output += stack.reversed()
        return output
    }
}
