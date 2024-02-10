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
    
    /// Цвет не влияет на блюр. Играет роль толька alpha.
    private var colors:[CGColor] = []
    
    private var style: UIBlurEffect.Style = .light
    
    init (location: [NSNumber] = [0, 1],
          colors:[CGColor] = [CGColor(gray: 0, alpha: 1), CGColor(gray: 0, alpha: 0)])
    {
        super.init(effect: UIBlurEffect(style: .regular))
        self.colors = colors
        self.location = location
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private func configure() {
        
        if let vfxSubView = self.subviews.first(where: {
            String(describing: type(of: $0)) == "_UIVisualEffectSubview"
        }) {
            vfxSubView.backgroundColor = .blurColor()
        }
        
        gradientLayer.locations = location
        gradientLayer.colors = colors
        layer.mask = gradientLayer
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if let vfxSubView = self.subviews.first(where: {
            String(describing: type(of: $0)) == "_UIVisualEffectSubview"
        }) {
            vfxSubView.backgroundColor = .blurColor()
        }
    }
    
}

