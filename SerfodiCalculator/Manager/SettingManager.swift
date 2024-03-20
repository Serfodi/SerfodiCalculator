//
//  SettingManager.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 01.02.2024.
//

import Foundation
import UIKit

/// Отвечает за состояние всего приложение.
///
/// Набор настроек приложения
final class SettingManager {
    
    private let storage = CalculationSettingStorage()
    
    private var setting: Setting!
    
    // MARK: init
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(save), name: UIApplication.willResignActiveNotification, object: nil)
        setting = storage.load()
    }
    deinit {
        save()
    }
    
    @objc public func save() {
        storage.setData(setting)
    }
    
    public func setSetting(_ setting: Setting) {
        self.setting = setting
        save()
    }
    
    public func getSetting() -> Setting {
        self.setting
    }
    
}
