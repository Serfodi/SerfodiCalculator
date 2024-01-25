//
//  Storage.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import Foundation


struct Calculation {
    let expression: [CalculationHistoryItem]
    let result: Double
}

extension Calculation: Codable {}


final class CalculationHistoryStorage {
    
    static let calculationHistoryKey = "calculationHistoryKey"
    
    func setHistory(calculation: [Calculation]) {
        if let encoder = try? JSONEncoder().encode(calculation) {
            UserDefaults.standard.set(encoder, forKey: CalculationHistoryStorage.calculationHistoryKey)
        }
    }
    
    func loadHistory() -> [Calculation] {
        if let data = UserDefaults.standard.data(forKey: CalculationHistoryStorage.calculationHistoryKey) {
            return (try? JSONDecoder().decode([Calculation].self, from: data)) ?? []
        }
        return []
    }
    
}


final class CalculationHistoryStorageString {
    
    static let calculationHistoryKey = "calculationHistoryStringKey"
    
    func setHistory(calculation: [String]) {
        UserDefaults.standard.set(calculation, forKey: CalculationHistoryStorageString.calculationHistoryKey)
    }
    
    func loadHistory() -> [String] {
        if let data = UserDefaults.standard.stringArray(forKey: CalculationHistoryStorageString.calculationHistoryKey) {
            return data
        }
        return []
    }
    
}
