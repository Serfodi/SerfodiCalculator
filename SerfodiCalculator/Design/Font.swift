//
//  Font.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 15.03.2024.
//

import UIKit

public struct Font {
    
    public enum Design {
        case regular
        
        var key: String {
            switch self {
            case .regular:
                return "SFPro"
            }
        }
    }
    
    public enum Weight {
        case regular
        case medium
        case semibold
        case bold
        case heavy
        
        var key: String {
            switch self {
            case .regular:
                return "Regular"
            case .medium:
                return "Medium"
            case .semibold:
                return "Semibold"
            case .bold:
                return "Bold"
            case .heavy:
                return "Heavy"
            }
        }
    }
    
    static func att(size: CGFloat, design: Design = .regular,  weight: Weight = .regular) -> UIFont {
        let descriptor = design.key + "-" + weight.key
        return UIFont(name: descriptor, size: size)!
    }
}


public extension NSAttributedString {
    
    convenience init(string: String, font: UIFont? = nil, textColor: UIColor = UIColor.black) {
        var attributes: [NSAttributedString.Key: AnyObject] = [:]
        if let font = font {
            attributes[NSAttributedString.Key.font] = font
        }
        attributes[NSAttributedString.Key.foregroundColor] = textColor
        self.init(string: string, attributes: attributes)
    }
}



/*
 
 Font Family Name = [SF Pro]
 Font Names = [
 ["SFPro-Regular", "SFPro-Ultralight", "SFPro-Thin", "SFPro-Light", "SFPro-Medium", "SFPro-Semibold", "SFPro-Bold", "SFPro-Heavy", "SFPro-Black", "SFPro-CondensedRegular", "SFPro-CondensedUltralight", "SFPro-CondensedThin", "SFPro-CondensedLight", "SFPro-CondensedMedium", "SFPro-CondensedSemibold", "SFPro-CondensedBold", "SFPro-CondensedHeavy", "SFPro-CondensedBlack", "SFPro-ExpandedRegular", "SFPro-ExpandedUltralight", "SFPro-ExpandedThin", "SFPro-ExpandedLight", "SFPro-ExpandedMedium", "SFPro-ExpandedSemibold", "SFPro-ExpandedBold", "SFPro-ExpandedHeavy", "SFPro-ExpandedBlack", "SFPro-CompressedRegular", "SFPro-CompressedUltralight", "SFPro-CompressedThin", "SFPro-CompressedLight", "SFPro-CompressedMedium", "SFPro-CompressedSemibold", "SFPro-CompressedBold", "SFPro-CompressedHeavy", "SFPro-CompressedBlack"]]
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
