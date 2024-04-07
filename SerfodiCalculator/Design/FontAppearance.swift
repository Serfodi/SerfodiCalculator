//
//  FontAppearance.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 03.04.2024.
//

import UIKit

enum MainFontAppearance {
    
    static let mainLabelFont = Font.att(size: 50, design: .regular, weight: .medium)
    static let exampleFont = Font.att(size: 26, design: .regular, weight: .medium)
    
    static let firstFont = Font.att(size: 17, design: .regular, weight: .medium)
    static let secondFont = Font.att(size: 26, design: .regular, weight: .medium)
    
}

enum NumpadFontAppearance {
    static let numberFont = Font.att(size: 30, design: .regular, weight: .medium)
}
