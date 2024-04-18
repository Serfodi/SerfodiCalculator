//
//  BasicAnimation.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 30.03.2024.
//

import UIKit

extension CALayer {
    
    func errorAnimation() {
        let durationColor = 0.5
        
        let snake = CABasicAnimation(keyPath: "position")
        snake.duration = 0.1
        snake.repeatCount = 3
        snake.autoreverses = true
        
        snake.fromValue = NSValue(cgPoint: CGPoint(x: frame.midX - 3, y: frame.midY))
        snake.toValue = NSValue(cgPoint: CGPoint(x: frame.midX + 3, y: frame.midY))
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor.clear.cgColor
        colorAnimation.toValue = EnvironmentColorAppearance.mainErrorColor.color().cgColor
        colorAnimation.duration = durationColor
        colorAnimation.autoreverses = true
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = durationColor * 2 + 0.1 * 3
        animationGroup.animations = [colorAnimation, snake]
        
        add(animationGroup, forKey: "groupAnimation")
    }
    
}
