//
//  UIFount + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 27.01.2024.
//

import UIKit

// MARK: - Color for History Table Cell

extension UIFont {
    
    static func mainDisplay() -> UIFont {
        UIFont(name: "SFPro-Medium", size: 50)!
    }
    
    static func example26() -> UIFont {
        UIFont(name: "SFPro-Medium", size: 26)!
    }
    
    static func numpad35() -> UIFont {
        UIFont(name: "SFPro-Medium", size: 35)!
    }
    
    static func numpad(size: Int) -> UIFont {
        UIFont(name: "SFPro-Medium", size: CGFloat(size))!
    }
    
    static func SFProSemibold(size: Int) -> UIFont {
        UIFont(name: "SFPro-Semibold", size: CGFloat(size))!
    }
    
}


