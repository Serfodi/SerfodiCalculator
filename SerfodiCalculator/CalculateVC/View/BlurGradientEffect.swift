//
//  BlurGradientEffect.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 24.01.2024.
//

import Foundation

import UIKit
 

final class BlurGradientView: UIVisualEffectView {
    
    private var gradientLayer = CAGradientLayer()
    
    private var location: [NSNumber] = []
    
    private var colors:[CGColor] = []
    
    init (blur: UIBlurEffect.Style = .light,
          location: [NSNumber] = [0, 1],
          colors:[CGColor] = [CGColor(gray: 0, alpha: 1), CGColor(gray: 0, alpha: 0)])
    {
        super.init(effect: UIBlurEffect(style: blur))
        self.colors = colors
        self.location = location
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func configure() {
        backgroundColor = .clear
        gradientLayer.locations = location
        gradientLayer.colors = colors
        layer.mask = gradientLayer
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
