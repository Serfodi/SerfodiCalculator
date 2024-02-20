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
    
}

/*
 
 Font Family Name = [SF Pro]
 Font Names = [["SFPro-Regular", "SFPro-Ultralight", "SFPro-Thin", "SFPro-Light", "SFPro-Medium", "SFPro-Semibold", "SFPro-Bold", "SFPro-Heavy", "SFPro-Black", "SFPro-CondensedRegular", "SFPro-CondensedUltralight", "SFPro-CondensedThin", "SFPro-CondensedLight", "SFPro-CondensedMedium", "SFPro-CondensedSemibold", "SFPro-CondensedBold", "SFPro-CondensedHeavy", "SFPro-CondensedBlack", "SFPro-ExpandedRegular", "SFPro-ExpandedUltralight", "SFPro-ExpandedThin", "SFPro-ExpandedLight", "SFPro-ExpandedMedium", "SFPro-ExpandedSemibold", "SFPro-ExpandedBold", "SFPro-ExpandedHeavy", "SFPro-ExpandedBlack", "SFPro-CompressedRegular", "SFPro-CompressedUltralight", "SFPro-CompressedThin", "SFPro-CompressedLight", "SFPro-CompressedMedium", "SFPro-CompressedSemibold", "SFPro-CompressedBold", "SFPro-CompressedHeavy", "SFPro-CompressedBlack"]]
 ------------------------------
 Font Family Name = [SF Pro Text]
 Font Names = [["SFProText-Regular"]]
 
 */


/*
static func print() {
    func printFontsNames() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            Swift.print("------------------------------")
            Swift.print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            Swift.print("Font Names = [\(names)]")
        }
    }
}
*/
