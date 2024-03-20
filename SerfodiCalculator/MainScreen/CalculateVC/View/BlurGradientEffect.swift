//
//  BlurGradientEffect.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 24.01.2024.
//

import Foundation
import UIKit
 

final class BlurView: UIVisualEffectView {
    
    enum StyleGradient {
        case non
        case linear (linearGradientPosition)
        case doubleLine (NSNumber, NSNumber) /// plato position
        
        
        enum linearGradientPosition {
            case up (NSNumber) /// start point
            case down (NSNumber) /// start point
        }
    }
    
    private var gradientLayer = CAGradientLayer()
    
    
    // MARK: init
    
    init (styleGradient: StyleGradient = .non) {
        super.init(effect: UIBlurEffect(style: .regular))
        switch styleGradient {
        case .non:
            return
            
        case .linear(let positionStyle):
            switch positionStyle {
            case .up(let start):
                configureGradient(
                    location: [start, 1],
                    colors: [CGColor(gray: 0, alpha: 1), CGColor(gray: 0, alpha: 0)])
            case .down(let start):
                configureGradient(
                    location: [start, 1],
                    colors: [CGColor(gray: 0, alpha: 0), CGColor(gray: 0, alpha: 1)])
            }
            
        case .doubleLine(let start, let end):
           configureGradient(
            location: [0, start, end, 1],
            colors: [
                CGColor(gray: 0, alpha: 0),
                CGColor(gray: 0, alpha: 1),
                CGColor(gray: 0, alpha: 1),
                CGColor(gray: 0, alpha: 0)
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    
    private func configureGradient(location: [NSNumber], colors: [CGColor]) {
        fixGradientColor()
        gradientLayer.locations = location
        gradientLayer.colors = colors
        layer.mask = gradientLayer
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        fixGradientColor()
    }
}


private extension BlurView {
    
    /*
     Если взять обычный градиент и наложить его на черный фон, то он становиться серым, а ожидалось черный.
     */
    func fixGradientColor() {
        if let vfxSubView = self.subviews.first(where: {
            String(describing: type(of: $0)) == "_UIVisualEffectSubview"
        }) {
            vfxSubView.backgroundColor = .blurColor()
        }
    }
    
}
