//
//  Array + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.02.2024.
//

import Foundation

extension Array where Element: Numeric {
    
    /// [1, 2, 3].pop(2) -> [3, 2]
    mutating func pop(_ numberPopLast: Int) -> [Element]? {
        var array: [Element] = []
        
        for _ in 0..<numberPopLast {
            guard let last = popLast() else { return nil }
            array.append(last)
        }
        return array.reversed()
    }
    
}
