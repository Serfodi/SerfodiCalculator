//
//  String + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 26.01.2024.
//

import UIKit

extension String {
    
    public func size(font: UIFont) -> CGSize {
        size(withAttributes: [NSAttributedString.Key.font: font])
    }
    
}

