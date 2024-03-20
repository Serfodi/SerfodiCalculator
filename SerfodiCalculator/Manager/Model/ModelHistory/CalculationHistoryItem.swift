//
//  CalculationHistoryItem.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import Foundation


enum CalculationHistoryItem {
    /// Число
    case number(Double)
    /// Опирация
    case operation(Operation)
    
}


// MARK: Codable

extension CalculationHistoryItem: Codable {
    
    enum CodingKeys: String, CodingKey {
        case number
        case operation
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .number(let value):
            try container.encode(value, forKey: CodingKeys.number)
        case .operation(let value):
            try container.encode(value.rawValue, forKey: CodingKeys.operation)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let number = try container.decodeIfPresent(Double.self, forKey: .number) {
            self = .number(number)
            return
        }
        
        if let rawOperation = try container.decodeIfPresent(Int.self, forKey: .operation),
        let operation = Operation(rawValue: rawOperation) {
            self = .operation(operation)
            return
        }
        
        throw CalculationHistoryItemError.itemNotFound
    }
    
}


