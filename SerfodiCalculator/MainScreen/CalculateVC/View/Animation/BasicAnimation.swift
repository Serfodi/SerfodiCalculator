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
        
        snake.fromValue = NSValue(cgPoint: CGPoint(x: frame.origin.x - 3, y: frame.origin.y))
        snake.toValue = NSValue(cgPoint: CGPoint(x: frame.origin.x + 3, y: frame.origin.y))
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor.clear.cgColor
        colorAnimation.toValue = #colorLiteral(red: 0.9568627477, green: 0.8265123661, blue: 0.7767734047, alpha: 1).cgColor
        colorAnimation.duration = durationColor
        colorAnimation.autoreverses = true
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = durationColor * 2 + 0.1 * 3
        animationGroup.animations = [colorAnimation, snake]
        
        add(animationGroup, forKey: "groupAnimation")
    }
    
}
