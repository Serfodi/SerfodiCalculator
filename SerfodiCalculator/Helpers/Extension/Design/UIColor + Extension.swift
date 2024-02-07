//
//  UIColor + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit

// MARK: - Main color

extension UIColor {
    
    static func mainColor() -> UIColor {
        .white
    }
    
    static func focusColor() -> UIColor {
        UIColor(white: 0, alpha: 0.05)
    }
    
    static func operatingButtonColor() -> UIColor {
        #colorLiteral(red: 1, green: 0.5486019254, blue: 0.635882616, alpha: 1)
    }

    static func operatingSecondButtonColor() -> UIColor {
        #colorLiteral(red: 1, green: 0.5486019254, blue: 0.635882616, alpha: 1)
    }
    
    static func numberButtonColor() -> UIColor {
        #colorLiteral(red: 0.5799446702, green: 0.815341413, blue: 0.993283093, alpha: 1)
    }
    
    static func serviceButtonColor() -> UIColor {
        #colorLiteral(red: 0.9905391335, green: 0.8197882771, blue: 0.5802722573, alpha: 1)
    }
    
    static func numpadColor() -> UIColor {
        #colorLiteral(red: 0.9729686379, green: 0.9481814504, blue: 0.8923994303, alpha: 1)
    }
    
}


// MARK: - Text color

extension UIColor {
    
    static func operatingTextColor() -> UIColor {
        #colorLiteral(red: 0.4559901953, green: 0.1281207502, blue: 0.2135271728, alpha: 1)
    }
    
    static func operatingSecondTextColor() -> UIColor {
        #colorLiteral(red: 1, green: 0.5486019254, blue: 0.635882616, alpha: 1)
    }
    
    static func numberTextColor() -> UIColor {
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    static func serviceTextColor() -> UIColor {
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
}





// MARK: - History Table Cell

extension UIColor {
    
    static func exampleColorNumber() -> UIColor {
        UIColor(white: 0.5, alpha: 0.70)
    }
    
    static func exampleColorSign() -> UIColor {
        UIColor(white: 0.25, alpha: 0.70)
    }
    
    static func exampleColorEqual() -> UIColor {
        UIColor(white: 0, alpha: 0.70)
    }
    
    static func exampleColorResult() -> UIColor {
        .black
    }
    
}
