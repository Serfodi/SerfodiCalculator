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

extension SettingManager {
    
    public func setGeneralSetting(_ set: GeneralSetting) {
        setting.generalSetting = set
        save()
    }
    public func getGeneralSetting() -> GeneralSetting {
        setting.generalSetting
    }
    
    public func setEnvironmentSetting(_ set: EnvironmentSetting) {
        setting.environmentSetting = set
        save()
    }
    public func getEnvironmentSetting() -> EnvironmentSetting {
        setting.environmentSetting
    }
    
    public func setDataSetting(_ set: DataSetting) {
        setting.dataSetting = set
        save()
    }
    public func getDataSetting() -> DataSetting {
        setting.dataSetting
    }
}
