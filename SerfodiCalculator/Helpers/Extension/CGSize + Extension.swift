//
//  CGSize + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 27.01.2024.
//

import Foundation

extension CGSize {
    
    static func * (size: CGSize, multiplier: CGFloat) -> CGSize {
        return CGSize(width: size.width * multiplier, height: size.height * multiplier)
    }
    
    static func <= (left: CGSize, right: CGSize) -> Bool {
        return left.width <= right.width && left.height <= right.height
    }
    
    static func > (left: CGSize, right: CGSize) -> Bool {
        return left.width > right.width && left.height > right.height
    }
    
}
