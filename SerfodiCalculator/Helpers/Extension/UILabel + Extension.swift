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
    /// - Requires: `font != nil`
    ///
    /// - Attention: `NSAttributedString`: для вычисления размера  учитывает только __`UIFont`__.
    ///   Другие атрибуты не учитываются.
    ///
    public func size(text: String?) -> CGSize {
        guard let text = text else { return CGSize.zero }
        return text.size(withAttributes: [NSAttributedString.Key.font: font!])
    }
    
    /// Размер текста в `UILabel`
    ///
    /// - Requires: `font != nil`
    ///
    /// - Attention: `NSAttributedString`: для вычисления размера  учитывает только __`UIFont`__.
    ///   Другие атрибуты не учитываются.
    ///
    public func size(text: String?, scale width: CGFloat = 1.0, _ height: CGFloat = 1.0) -> CGSize {
        guard let text = text else { return CGSize.zero }
        let size = text.size(withAttributes: [NSAttributedString.Key.font: font!])
        return CGSize(width: size.width * width, height: size.height * height)
    }
    
    
    /// Размер текста в `UILabel`
    public func textSize() -> CGSize {
        size(text: text)
    }

    /// Размер текста в `UILabel`
    ///
    /// - Parameter scale: Множетели приминяются к размеру текста
    ///
    public func textSize(scale width: CGFloat = 1.0, _ height: CGFloat = 1.0) -> CGSize {
        return size(text: text, scale: width, height)
    }
    
    /// Можно ли записать текст в `UILabel`
    ///
    /// - Returns: `true`  Если текст вписывается в рамку этого `UILabel`
    ///
    /// - Remark: Учитывает `AttributedString`
    ///
    public func isFitTextInto(_ text: String?) -> Bool {
        let size = size(text: text)
        return size <= bounds.size
    }
    
    /// Можно ли записать текст в `UILabel`
    public func isFitTextInto(_ text: String?, scale width: CGFloat = 1.0, _ height: CGFloat = 1.0) -> Bool {
        let size = size(text: text, scale: width, height)
        return size <= bounds.size
    }
    
    
}
