//
//  InputNumber.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 01.02.2024.
//

import Foundation

class InputNumberText {
    
    var number: Double = 0
    
    public func convert(text: String?) -> Double {
        guard let text = text else { return 0 }
        return 0
    }
    
    public func convert(number: Double) -> String {
        ""
    }
    
    /// Принимает символ числа для добавления
    ///
    /// - Returns: Число Double
    public func add(digit: String, _ successful: (Double) -> ()) {
        
    }

    public func removeLast(_ successful: (Double) -> ()) -> Double {
        0
    }
    
}
