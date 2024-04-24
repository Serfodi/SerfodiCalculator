//
//  Storage.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import Foundation


final class CalculationSettingStorage {
    
    static let lastInputKey = "SettingKey"
    
    func setData(_ data: Setting) {
        if let encoder = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encoder, forKey: CalculationSettingStorage.lastInputKey)
        }
    }
    
    func load() -> Setting {
        if let data = UserDefaults.standard.data(forKey: CalculationSettingStorage.lastInputKey) {
            return (try? JSONDecoder().decode(Setting.self, from: data)) ?? Setting.setDefault()
        }
        return Setting.setDefault()
    }
}
