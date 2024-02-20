//
//  SettingManager.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 01.02.2024.
//

import Foundation
import UIKit

struct Setting: Codable {
    
    var lastResult: Double!
    
}

/// Отвечает за состояние всего приложение.
///
/// Набор настроек.
final class SettingManager {
    
    static let shared = SettingManager()
    
    private let storage = CalculationSettingStorage()
    
    public var setting: Setting = Setting() // fix it
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        setting.lastResult = storage.load()
    }
    deinit {
        save()
    }
    
    public var getLastResult: Double {
        setting.lastResult
    }
    
    public func saveLastResult(result: Double) {
        setting.lastResult = result
    }
    
    @objc private func save() {
        storage.setData(setting.lastResult)
    }
    
}
