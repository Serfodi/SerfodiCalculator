//
//  Storage.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import Foundation


final class CalculationHistoryStorage {
    
    static let calculationHistoryKey = "calculationHistoryKey"
    static let lastInputKey = "lastInputKey"
    
    func setData(_ data: Double) {
        UserDefaults.standard.set(data, forKey: CalculationHistoryStorage.lastInputKey)
    }
    
    func load() -> Double {
        UserDefaults.standard.double(forKey: CalculationHistoryStorage.lastInputKey)
    }
    
    func setData(_ data: [Calculation]) {
        if let encoder = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoder, forKey: CalculationHistoryStorage.calculationHistoryKey)
        }
    }
    
    func load() -> [Calculation] {
        if let data = UserDefaults.standard.data(forKey: CalculationHistoryStorage.calculationHistoryKey) {
            return (try? JSONDecoder().decode([Calculation].self, from: data)) ?? []
        }
        return []
    }
}
