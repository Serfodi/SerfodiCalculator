//
//  DynamicNumberFormatter.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 27.01.2024.
//

import UIKit

// MARK:  Цепочка отвественностей

/// Форматирует число.
///
/// Может изменять стиль форматирования и подстраивать его под оприделеные ограничения.
final class DynamicNumberFormatter {
    
    static private let maximumSignificantDigits = 15
    
    private var numberFormatterDec = {
       let formatter = NumberFormatter(style: .decimal)
        formatter.usesGroupingSeparator = true
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 1
        formatter.maximumSignificantDigits = DynamicNumberFormatter.maximumSignificantDigits
        return formatter
    }()
    
    private var numberFormatterE: NumberFormatter = {
        let formatter = NumberFormatter(style: .scientific)
        formatter.usesSignificantDigits = true
        formatter.exponentSymbol = "e"
        formatter.minimumSignificantDigits = 1
        formatter.maximumSignificantDigits = DynamicNumberFormatter.maximumSignificantDigits
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
    
    /// Выполняет форматирование текста. Использует `numberFormatterDec`
    public func performDec(number: NSNumber) -> String {
        numberFormatterDec.string(from: number)!
    }
    
    /// Пробует выполнить преоброзование текста  через `numberFormatterDec`  в число.
    public func perform(text: String) -> Double? {
        numberFormatterDec.number(from: text)?.doubleValue
    }
    
    private func perform(formatter: NumberFormatter, number: NSNumber) -> String {
        formatter.string(from: number)!
    }
    
//    private func perform(formatter: NumberFormatter, number: NSNumber, maximumSignificantDigits: Int) -> String {
//        formatter.maximumSignificantDigits = maximumSignificantDigits
//        return formatter.string(from: number)!
//    }
    
    
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
    
    public func perform(_ number: NSNumber) -> String {
        if number.stringValue.count > DynamicNumberFormatter.maximumSignificantDigits {
            return perform(formatter: numberFormatterE, number: number)
        }
        return perform(formatter: numberFormatterDec, number: number)
    }
    
    
    /// Функция уменьшения точности для форматера
    ///
    /// Это нужно что можно было увместить число на экран, если появлются переодичная дробь или очень большое число.
    private func lessPrecise(_ number: NSNumber,
                             _ formatter: NumberFormatter,
                             _ textInto: (String) -> Bool) -> String?
    {
        let max = DynamicNumberFormatter.maximumSignificantDigits
        for i in 1...max {
            let text = perform(formatter: formatter, number: number)
            if textInto(text) {
                formatter.maximumSignificantDigits = max
                return text
            }
            formatter.maximumSignificantDigits = max - i
        }
        defer {
            formatter.maximumSignificantDigits = DynamicNumberFormatter.maximumSignificantDigits
        }
        return nil
    }
}

