//
//  CGSize + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 27.01.2024.
//

import Foundation

public extension CGSize {
    
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

public extension CGSize {
    
    func centered(in rect: CGRect) -> CGRect {
        return CGRect(origin: CGPoint(x: rect.minX + floor((rect.width - self.width) / 2.0), y: rect.minY + floor((rect.height - self.height) / 2.0)), size: self)
    }
    
    func centered(around position: CGPoint) -> CGRect {
        return CGRect(origin: CGPoint(x: position.x - self.width / 2.0, y: position.y - self.height / 2.0), size: self)
    }
    
}
