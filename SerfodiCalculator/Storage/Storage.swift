//
//  Storage.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import Foundation


final class CalculationSettingStorage {
    
    static let lastInputKey = "lastInputKey"
    
    func setData(_ data: Double) {
        UserDefaults.standard.set(data, forKey: CalculationSettingStorage.lastInputKey)
    }
    
    func load() -> Double {
        UserDefaults.standard.double(forKey: CalculationSettingStorage.lastInputKey)
    }
    
}

final class CalculationHistoryStorage {
    
    static let calculationHistoryKey = "calculationHistoryKey"
    
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
