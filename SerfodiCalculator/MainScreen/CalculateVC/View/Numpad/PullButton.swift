//
//  PullButton.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 16.02.2024.
//

import UIKit

final class PullButton: UIButton {
    let color = NumpadAppearance.PullButton.normalColor.color()
    let size = CGSize(width: 12, height: 56)
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: size.centered(in: rect), cornerRadius: size.width / 2)
        color.setFill()
        path.fill()
    }
}
