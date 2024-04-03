//
//  UIFount + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 27.01.2024.
//

import UIKit

// MARK: - Color for History Table Cell

extension UIFont {
    
    static func example26() -> UIFont {
        Font.att(size: 26, design: .regular, weight: .medium)
    }
    
    static func numpad35() -> UIFont {
        Font.att(size: 35, design: .regular, weight: .medium)
    }
    
    static func numpad(size: Int) -> UIFont {
        Font.att(size: CGFloat(size), design: .regular, weight: .medium)
    }
    
    static func SFProSemibold(size: Int) -> UIFont {
        Font.att(size: CGFloat(size), design: .regular, weight: .semibold)
    }
    
}


