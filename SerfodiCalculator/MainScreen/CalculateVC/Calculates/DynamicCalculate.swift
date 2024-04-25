//
//  DynamicCalculate.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 31.01.2024.
//

import Foundation

protocol Calculate {
    func calculate(items: [CalculationItem]) throws -> Double
}

final class DynamicCalculate: Calculate {
    
    let parser: ItemParser = CalculationItemParser()
    
    public func calculate(items: [CalculationItem]) throws -> Double {
        let postfix = parser.parsing(items: items)
        return try calculating(items: postfix)
    }
    
    private func calculating(items: [CalculationItem]) throws -> Double {
        var result: Double = 0
        var stack = [Double]()
        
        for index in items {
            switch index {
                
            case .number(let number):
                stack.append(number)
                
            case .operation(let operation):
                guard let numbers = stack.pop(operation.type.rawValue) else { break }
                result = try operation.calculate(numbers)
                stack.append(result)
            }
        }
        
        guard let resultLast = stack.popLast() else { return result }
        result = resultLast
        
        return result
    }
}
