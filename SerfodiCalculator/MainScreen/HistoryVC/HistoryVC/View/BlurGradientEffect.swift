//
//  BlurGradientEffect.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 24.01.2024.
//

import UIKit

final class BlurView: UIVisualEffectView {
    
    enum StyleGradient {
        case non
        case linear (linearGradientPosition)
        case doubleLine (NSNumber, NSNumber) /// plato position
        
        enum linearGradientPosition {
            case up (NSNumber) /// start point
            case down (NSNumber) /// start point
            case left (CGFloat)
            case right (CGFloat)
        }
    }
    
    private var gradientLayer = CAGradientLayer()
    
    // MARK: init
    
    init (styleGradient: StyleGradient = .non) {
        super.init(effect: UIBlurEffect(style: .regular))
        configurationView()
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
            case .left(let start):
                fixGradientColor()
                gradientLayer.startPoint = CGPoint(x: start, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
                gradientLayer.colors = [CGColor(gray: 0, alpha: 1), CGColor(gray: 0, alpha: 0)]
                layer.mask = gradientLayer
            case .right(let start):
                fixGradientColor()
                gradientLayer.startPoint = CGPoint(x: start, y: 0)
                gradientLayer.endPoint = CGPoint(x: 1, y: 0)
                gradientLayer.colors = [CGColor(gray: 0, alpha: 0), CGColor(gray: 0, alpha: 1)]
                layer.mask = gradientLayer
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
    
    private func configurationView() {
        isUserInteractionEnabled = false
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
            vfxSubView.backgroundColor = HistoryAppearance.backgroundBlurColor.color()
        }
    }
}
