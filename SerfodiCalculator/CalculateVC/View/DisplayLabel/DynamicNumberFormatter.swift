//
//  DynamicNumberFormatter.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 27.01.2024.
//

import UIKit


/// Форматирует число.
///
/// Может изменять стиль форматирования и подстраивать его под оприделеные ограничения.
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
    
    /// Проверяет есть ли точка в записи числа
    public func isContainPoint(_ text: String) -> Bool {
        text.contains(point)
    }
    /// Проверяет есть ли експонетна в записи числа
    public func isContainExponentSymbol(_ text: String) -> Bool {
        text.contains(exponentSymbol)
    }
    
    /// Функция  подбирает формат числа под заданную рамку.
    ///
    /// - Parameters:
    /// number число которое будет форматироваться
    /// size размер рамки
    ///
    public func fitInBounds(number: NSNumber, isFit textInto: (String) -> Bool ) throws -> String {
        if let text = lessPrecise(number, numberFormatterDec, textInto) {
            return text
        }
        if let text = lessPrecise(number, numberFormatterE, textInto) {
            return text
        }
        throw DynamicNumberFormatterError.fitFormattingFailure(number: number)
    }
    
    
    /// Функция уменьшения точности для форматера
    ///
    /// Это нужно что можно было увместить число на экран, если появлются переодичная дробь или очень большое число.
    private func lessPrecise(_ number: NSNumber,
                             _ formatter: NumberFormatter,
                             _ textInto: (String) -> Bool) -> String?
    {
        let max = formatter.maximumSignificantDigits
        for i in 1...max {
            let text = perform(formatter: formatter, number: number)
            if textInto(text) {
                return text
            }
            formatter.maximumSignificantDigits = max - i
        }
        defer {
            formatter.maximumSignificantDigits = max
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

