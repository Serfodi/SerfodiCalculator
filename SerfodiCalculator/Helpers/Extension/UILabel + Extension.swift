//
//  UILabel + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import UIKit


// MARK:  Text Size

extension UILabel {
    
    /// Размер текста в `UILabel`
    ///
    public func textSize() -> CGSize {
        let size = size(text)
        return CGSize(width: size.width, height: size.height)
    }

    /// Можно ли записать текст в `UILabel`
    ///
    /// - Returns: `true`  Если текст вписывается в рамку этого `UILabel`
    ///
    /// - Remark: Учитывает `AttributedString`
    ///
    public func isFitTextInto(_ text: String?) -> Bool {
        let size = size(text)
        return size <= bounds.size
    }
    
    
    /// - Returns: `minimumScaleFactor` если есть
    ///
    /// - Remark: Не учитывает текущий **Scale Factor**
    ///
    /// - Bug: Испрпвить что бы scale текста был текущем.
    ///
//    public func scale() -> CGFloat {
//        adjustsFontSizeToFitWidth ? minimumScaleFactor : 1
//    }
    
    /// Размер текста в `UILabel`
    ///
    /// - Requires: `font != nil`
    ///
    /// - Attention: `NSAttributedString`: для вычисления размера  учитывает только __`UIFont`__.
    ///  Другие атрибуты не учитвыются.
    ///
    public func size(_ text: String?) -> CGSize {
        guard let text = text else { return CGSize.zero }
        return text.size(withAttributes: [NSAttributedString.Key.font: font!])
    }
    
}
