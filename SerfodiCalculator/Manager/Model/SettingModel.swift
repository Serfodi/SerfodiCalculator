//
//  SettingModel.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 15.03.2024.
//

import Foundation

struct Setting: Codable {
    
    var lastResult: Double!
    var isSaveHistoryData: Bool!
 
}

extension Setting {
    
    static func setDefault() -> Self {
        .init(lastResult: 0, isSaveHistoryData: true)
    }
    
}


