//
//  UIColor + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit

extension UIColor {
    
    static func mainColor() -> UIColor {
        .white
    }
    
    static func padViewColor() -> UIColor {
        UIColor(red: 247/255, green: 242/255, blue: 229/255, alpha: 1)
    }
    
    static func numberButtonColor() -> UIColor {
        UIColor(red: 161/255, green: 206/255, blue: 249/255, alpha: 1)
    }
    
    static func operatingButtonColor() -> UIColor {
        UIColor(red: 246/255, green: 211/255, blue: 156/255, alpha: 1)
    }
    
    static func serviceButtonColor() -> UIColor {
        UIColor(red: 231/255, green: 150/255, blue: 165/255, alpha: 1)
    }
    
    static func operatingFountColor() -> UIColor {
        UIColor(white: 0.3, alpha: 1)
    }
    
}
