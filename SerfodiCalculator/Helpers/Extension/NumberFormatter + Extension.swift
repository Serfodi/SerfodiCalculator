//
//  NumberFormatter + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import Foundation

extension NumberFormatter {

    convenience init(style: NumberFormatter.Style) {
        self.init()
        locale = Locale(identifier: "ru_RU")
        numberStyle = style
        
        usesGroupingSeparator = false
        minusSign = "-"
        
        nilSymbol = "Нет числа!"
        positiveInfinitySymbol = "∞ не придел!"
    }

    
    static func getPoint() -> String {
        let formatter = self.init()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.numberStyle = .decimal
        return formatter.currencyDecimalSeparator
    }
    
    
    
}
