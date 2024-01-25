//
//  BlurGradientEffect.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 24.01.2024.
//

import Foundation

import UIKit

class BlurGradientView: UIVisualEffectView {

    private let gradientLayer = CAGradientLayer()
    
    var locationsGradient: [NSNumber] = [0, 1]
    
    var colors:[CGColor] = [UIColor.black.cgColor, UIColor.white.cgColor]
        
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        effect = UIBlurEffect(style: .light)
        
        backgroundColor = .clear
        
        gradientLayer.locations = locationsGradient
        gradientLayer.colors = colors
        
        layer.mask = gradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.locations = locationsGradient
        gradientLayer.colors = colors
        gradientLayer.frame = bounds
    }
}
