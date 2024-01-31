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
        
//        roundingMode = .floor
        
        nilSymbol = "Нет числа!"
        positiveInfinitySymbol = "∞ не придел!"
    }

}
