//
//  UILabel + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import UIKit


// MARK:  Text Size

extension UILabel {
    
    public func size(text: String?) -> CGSize {
        guard let text = text else { return CGSize.zero }
        return text.size(withAttributes: [NSAttributedString.Key.font: font!])
    }
    
    public func size(text: String?, scale width: CGFloat = 1.0, _ height: CGFloat = 1.0) -> CGSize {
        guard let text = text else { return CGSize.zero }
        let size = text.size(withAttributes: [NSAttributedString.Key.font: font!])
        return CGSize(width: size.width * width, height: size.height * height)
    }
    
    public func textSize() -> CGSize {
        size(text: text)
    }

    public func textSize(scale width: CGFloat = 1.0, _ height: CGFloat = 1.0) -> CGSize {
        return size(text: text, scale: width, height)
    }
    
    public func isFitTextInto(_ text: String?) -> Bool {
        let size = size(text: text)
        return size <= bounds.size
    }
    
    public func isFitTextInto(_ text: String?, scale width: CGFloat = 1.0, _ height: CGFloat = 1.0) -> Bool {
        let size = size(text: text, scale: width, height)
        return size <= bounds.size
    }
    
}

extension UILabel {
    
}
