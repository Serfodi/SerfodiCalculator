//
//  UIColor + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit

// MARK: - Main color

extension UIColor {
    
    static func blurColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return .clear
            case .dark:
                return UIColor.black.withAlphaComponent(0.1)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    static func focusColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return  UIColor(white: 0, alpha: 0.07)
            case .dark:
                return  UIColor(white: 1, alpha: 0.2)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    static func pullHighlightedButton() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return  UIColor(white: 0, alpha: 0.04)
            case .dark:
                return  UIColor(white: 1, alpha: 0.3)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    static func operatingSelectedButtonColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return .white
            case .dark:
                return .black
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    static func operatingButtonColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return #colorLiteral(red: 1, green: 0.5486019254, blue: 0.635882616, alpha: 1)
            case .dark:
                return #colorLiteral(red: 0.537254902, green: 0.3333333333, blue: 0.4588235294, alpha: 1)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    static func operatingSecondButtonColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return #colorLiteral(red: 0.7882352941, green: 0.7960784314, blue: 0.6470588235, alpha: 1)
            case .dark:
                return #colorLiteral(red: 0.537254902, green: 0.3333333333, blue: 0.4588235294, alpha: 1)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    static func operatingSelectedSecondButtonColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return .white
            case .dark:
                return .black
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    
    
    static func numberButtonColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return #colorLiteral(red: 0.5803921569, green: 0.8156862745, blue: 0.9921568627, alpha: 1)
            case .dark:
                return #colorLiteral(red: 0.2039215686, green: 0.1764705882, blue: 0.3137254902, alpha: 1)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
        
    }
    
    static func serviceButtonColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return #colorLiteral(red: 0.9921568627, green: 0.8196078431, blue: 0.5803921569, alpha: 1)
            case .dark:
                return #colorLiteral(red: 0.7098039216, green: 0.6470588235, blue: 0.6274509804, alpha: 1)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
        
    }
    
    static func numpadColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return #colorLiteral(red: 0.9729686379, green: 0.9481814504, blue: 0.8923994303, alpha: 1)
            case .dark:
                return #colorLiteral(red: 0.1254901961, green: 0.1215686275, blue: 0.1411764706, alpha: 1)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
}


// MARK: - Text color

extension UIColor {
    
    static func operatingTextColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return #colorLiteral(red: 0.4549019608, green: 0.1294117647, blue: 0.2117647059, alpha: 1)
            case .dark:
                return #colorLiteral(red: 0.7882352941, green: 0.7137254902, blue: 0.7450980392, alpha: 1)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    static func operatingSecondTextColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return #colorLiteral(red: 0.1294117647, green: 0.3058823529, blue: 0.2039215686, alpha: 1)
            case .dark:
                return #colorLiteral(red: 0.7882352941, green: 0.7137254902, blue: 0.7450980392, alpha: 1)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
        
    }
    
    static func numberTextColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case .dark:
                return #colorLiteral(red: 0.737254902, green: 0.7411764706, blue: 0.7529411765, alpha: 1)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    
    static func serviceTextColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            case .dark:
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
        
    }
    
}





// MARK: - History Table Cell

extension UIColor {
    
    static func exampleColorNumber() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(white: 0.5, alpha: 0.70)
            case .dark:
                return UIColor(white: 0.5, alpha: 0.70)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    static func exampleColorSign() -> UIColor {
        
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return UIColor(white: 0.25, alpha: 0.70)
            case .dark:
                return UIColor(white: 0.75, alpha: 0.70)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    static func exampleColorEqual() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return  UIColor(white: 0, alpha: 0.70)
            case .dark:
                return  UIColor(white: 1, alpha: 0.70)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    static func exampleColorResult() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return  .black
            case .dark:
                return UIColor(white: 1, alpha: 0.90)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
}


// MARK: - Setting Controller

extension UIColor {
    
    static func cellButtonColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return #colorLiteral(red: 0.2941176471, green: 0.6509803922, blue: 0.9764705882, alpha: 1)
            case .dark:
                return #colorLiteral(red: 0.2941176471, green: 0.6509803922, blue: 0.9764705882, alpha: 1)
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
    static func cellButtonTextColor() -> UIColor {
        return UIColor.init {
            switch $0.userInterfaceStyle {
            case .light, .unspecified:
                return .white
            case .dark:
                return .white
            @unknown default:
                assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                return .white
            }
        }
    }
    
}


// MARK: - HELPS

extension UIColor {
    
    convenience init(rgb: UInt32) {
        self.init(red: CGFloat((rgb >> 16) & 0xff) / 255.0, green: CGFloat((rgb >> 8) & 0xff) / 255.0, blue: CGFloat(rgb & 0xff) / 255.0, alpha: 1.0)
    }
    
}
