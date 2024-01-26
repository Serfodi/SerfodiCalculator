//
//  NumberFormatter + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import Foundation

extension NumberFormatter {
    
    convenience init(locate: String = "ru_RU") {
        self.init()
        usesGroupingSeparator = false
        locale = Locale(identifier: locate)
        numberStyle = .decimal
    }
    
}
