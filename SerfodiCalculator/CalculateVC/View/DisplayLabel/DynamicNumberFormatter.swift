//
//  DynamicNumberFormatter.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 27.01.2024.
//

import UIKit



final class DynamicNumberFormatter {
    
    private var numberFormatterDec = {
       let formatter = NumberFormatter(style: .decimal)
        formatter.usesGroupingSeparator = true
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 1
        formatter.maximumSignificantDigits = 15
        return formatter
    }()
    private var numberFormatterE: NumberFormatter = {
        let formatter = NumberFormatter(style: .scientific)
        formatter.usesSignificantDigits = true
        formatter.exponentSymbol = "e"
        formatter.minimumSignificantDigits = 1
        formatter.maximumSignificantDigits = 17
        return formatter
    }()
    
    public var exponentSymbol: String {
        numberFormatterE.exponentSymbol
    }
    public var point: String {
        numberFormatterDec.currencyDecimalSeparator
    }
    public var separator: String {
        numberFormatterDec.currencyGroupingSeparator
    }
    public var minusSign: String {
        numberFormatterDec.minusSign
    }
    
    
    /// Функция  подбирает формат числа под заданную рамку.
    ///
    /// - Parameters:
    /// number число которое будет форматироваться
    /// size размер рамки
    ///
    public func fitInBounds(number: NSNumber, isFit textInto: (String) -> Bool ) throws -> String {
        
        let numberText = perform(formatter: numberFormatterDec, number: number)
        guard !textInto(numberText) else { return numberText }
        
        if number.doubleValue.truncatingRemainder(dividingBy: 1) != 0 {
            // Уменьшения точности после точки
            if let text = lessPrecise(number, numberFormatterDec, textInto) {
                return text
            }
        }
        
        if let text = lessPrecise(number, numberFormatterE, textInto) {
            return text
        }
        
        throw DynamicNumberFormatterError.fitFormattingFailure(number: number)
    }
    
    /// Функция уменьшения точности для форматера
    private func lessPrecise(_ number: NSNumber, _ formatter: NumberFormatter, _ textInto: (String) -> Bool) -> String? {
        let form = formatter
        var numberText: String?
        let max = form.maximumSignificantDigits
        for i in 1..<max {
            numberText = perform(formatter: formatter, number: number)
            if textInto(numberText!) {
                return numberText
            } else {
                form.maximumSignificantDigits = max - i
            }
        }
        return nil
    }
    
    
    private func perform(formatter: NumberFormatter, number: NSNumber) -> String {
        formatter.string(from: number)!
    }
    
    
    
    /// Выполняет форматирование текста. Использует `numberFormatterDec`
    public func perform(number: NSNumber) -> String {
        numberFormatterDec.string(from: number)!
    }
    
    /// Пробует выполнить преоброзование текста  через `numberFormatterDec`  в число.
    public func perform(text: String) -> Double? {
        numberFormatterDec.number(from: text)?.doubleValue
    }
    
}


/**
 
 Производит деление с форматированием периодической дроби
 ````
 func convert(num: 1, denominator: 3) -> 0.(3)
 ````
  - Note: Нужно знать делимое
 
 */
/*
extension DynamicNumberFormatter {
    
    private func convert(num: Double, denominator: Double) {
        var numerator = num
        
        let integer_part = "\( Int((numerator / denominator).rounded(.towardZero)) )"
        
        var ans = ""
        var l: [Double] = []
        
        numerator = numerator.truncatingRemainder(dividingBy: denominator)
        
        l.append(numerator)
        
        
        if numerator == 0 {
            print(integer_part)
            return
        }
        
        while true {
            
            if numerator == 0 {
                print("\(integer_part).\(ans)")
                return
            }
            
            let digit = (numerator * 10.0 / denominator).rounded(.towardZero)
            numerator = (numerator * 10.0).truncatingRemainder(dividingBy: denominator)
            
            ans += "\(Int(digit))"
            
            if !l.contains(numerator) {
                l.append(numerator)
            } else {
                print("\(integer_part).(\(ans))")
                print(l)
                return
            }
        }
    }
    
    
}
*/

