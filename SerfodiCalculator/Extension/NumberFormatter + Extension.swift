//
//  NumberFormatter + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import Foundation

extension NumberFormatter {
    
    convenience init(locate: String = "ru_RU", style: NumberFormatter.Style = .decimal ) {
        self.init()
        locale = Locale(identifier: locate)
        numberStyle = style
        usesGroupingSeparator = false
        
        minimumIntegerDigits = 1
        maximumFractionDigits = 14
        
        nilSymbol = "Нет числа!"
    }
    
    
}
