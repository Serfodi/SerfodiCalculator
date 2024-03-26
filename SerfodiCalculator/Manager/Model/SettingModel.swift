//
//  SettingModel.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 15.03.2024.
//

import Foundation

struct Setting: Codable {
    var environmentSetting: EnvironmentSetting
    var generalSetting: GeneralSetting
    var dataSetting: DataSetting
    var designSetting: DesignSetting
}

struct EnvironmentSetting: Codable {
    var lastResult: Double!
    
    func setDefault() -> Self {
        .init(lastResult: 0)
    }
}

struct DataSetting: Codable {
    var isSaveHistory: Bool!
    
    func setDefault() -> Self {
        .init(isSaveHistory: true)
    }
}

struct GeneralSetting: Codable {
    var isClicks: Bool!
    var isSound: Bool!
    var isVibration: Bool!
    
    func setDefault() -> Self {
        .init(isClicks: true,
              isSound: true,
              isVibration: true)
    }
}

struct DesignSetting: Codable {
    var isDarkStyle:  Bool!
    
    func setDefault() -> Self {
        .init(isDarkStyle: false)
    }
}

extension Setting {
    
    static func setDefault() -> Self {
        .init(environmentSetting: EnvironmentSetting().setDefault(),
              generalSetting: GeneralSetting().setDefault(),
              dataSetting: DataSetting().setDefault(),
              designSetting: DesignSetting().setDefault())
    }
    
}
