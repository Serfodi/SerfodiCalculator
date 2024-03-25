//
//  UIView + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.03.2024.
//

import UIKit

extension UIView {
    
    func pinToBounds(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ])
    }
    
}
