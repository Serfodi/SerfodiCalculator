//
//  UILabel + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import UIKit

extension UILabel {
    
    /// Возврощяет размер текста соглосованный с рамкой `UILabel`.
    ///
    /// - Returns: Если рамка текста превышает рамку `UILabel`, то вернет `UILabel.bounds`
    ///
    public func fitTextSize() -> CGSize {
        let size = textSize()
        return size > bounds.size ? bounds.size : size
    }
    
    /// Размер текста в `UILabel`
    public func textSize() -> CGSize {
        guard let text = text else { return CGSize.zero }
        let size = text.size(font: font)
        return CGSize(width: size.width, height: size.height * scale())
    }
    
    /// Можно ли записать текст в `UILabel`.
    public func isFitTextInto(_ text: String?) -> Bool {
        guard let text = text else { return true }
        let size = text.size(font: font)
        return size <= bounds.size
    }
    
    /// - Returns: `minimumScaleFactor`
    private func scale() -> CGFloat {
        adjustsFontSizeToFitWidth ? minimumScaleFactor : 1
    }
    
}
