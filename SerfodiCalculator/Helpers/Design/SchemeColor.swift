//
//  SchemeColor.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 30.03.2024.
//


import UIKit

struct SchemeColor {
    
    let light: UIColor
    let dark: UIColor
    
    func color() -> UIColor {
        UIColor { trainCollection in
            switch trainCollection.userInterfaceStyle {
            case .unspecified, .light:
                return light
            default:
                return dark
            }
        }
    }
}
