//
//  Storage.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import Foundation


final class CalculationSettingStorage {
    
    static let lastInputKey = "lastInputKey"
    
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
    
    func removeAllHistory() {
        UserDefaults.standard.removeObject(forKey: CalculationHistoryStorage.calculationHistoryKey)
    }
    
    func getSizeOfUserDefaults() -> Int? {
        guard let libraryDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first else { return nil }
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else { return nil }
        let filepath = "\(libraryDir)/Preferences/\(bundleIdentifier).plist"
        let filesize = try? FileManager.default.attributesOfItem(atPath: filepath)
        let retVal = filesize?[FileAttributeKey.size]
        let dataSize = retVal as? Int
        return (dataSize ?? 0) / 1024
    }
    
}
