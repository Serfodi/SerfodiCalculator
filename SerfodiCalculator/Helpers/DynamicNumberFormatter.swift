//
//  DynamicNumberFormatter.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 27.01.2024.
//

import UIKit


final class DynamicNumberFormatter {
    
    private lazy var numberFormatterDec = {
       let formatter = NumberFormatter(style: .decimal)
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 1
        formatter.maximumSignificantDigits = 17
        return formatter
    }()
    
    private var numberFormattersE: NumberFormatter = {
        let formatter = NumberFormatter(style: .scientific)
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 1
        formatter.maximumSignificantDigits = 17
        return formatter
    }()
    
    public var exponentSymbol: String {
        numberFormattersE.exponentSymbol
    }
    
    /// Функция  подбирает формат числа под заданную рамку.
    ///
    /// - Parameters:
    /// number число которое будет форматироваться
    /// size размер рамки
    ///
    func fitInBounds(number: NSNumber, isFit textInto: (String) -> Bool ) {
        var numberText = perform(formatter: numberFormatterDec, number: number)
        guard !textInto(numberText) else { return }
        var maxSD = numberFormattersE.maximumSignificantDigits
        while (maxSD > 0) {
            numberText = perform(formatter: numberFormattersE, number: number)
            if textInto(numberText) { return }
            maxSD -= 1
            numberFormattersE.maximumSignificantDigits = maxSD
        }
    }
    
    ///
    func fitInBounds(number: NSNumber, isFit textInto: (String) -> Bool ) -> String {
        
        var numberText = perform(formatter: numberFormatterDec, number: number)
        
        guard !textInto(numberText) else { return numberText }
        
        var maxSD = numberFormattersE.maximumSignificantDigits
        
        while (maxSD > 0) {
            
            numberText = perform(formatter: numberFormattersE, number: number)
            if textInto(numberText) {
                return numberText
            }
            maxSD -= 1
            numberFormattersE.maximumSignificantDigits = maxSD
        }
        
        return "Нет числа!"
    }
    
    
    
    private func perform(formatter: NumberFormatter, number: NSNumber) -> String {
        formatter.string(from: number)!
    }
    
    /// Выполняет форматирование текста `numberFormatterDec`
    public func perform(number: NSNumber) -> String {
        numberFormatterDec.string(from: number)!
    }
    
    /// Выполняет преоброзование текста `numberFormatterDec`
    public func perform(text: String) -> Double? {
        numberFormatterDec.number(from: text)?.doubleValue
    }
    
    
}
