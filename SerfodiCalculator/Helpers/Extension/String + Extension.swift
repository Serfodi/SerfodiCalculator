//
//  String + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 26.01.2024.
//

import UIKit

extension String {
    
    /// Размер текста с заданным шрифтом
    public func size(font: UIFont) -> CGSize {
        size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
//    public func isFitTextSize(text: String, font: UIFont, size: CGSize) -> Bool {
//        let sizeText = self.size(font: font)
//        return sizeText.width <= size.width && sizeText.height <= size.height
//    }
    
}

