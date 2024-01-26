//
//  UILabel + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import UIKit

extension UILabel {
    
    public func textSize() -> CGSize {
        (text! as NSString).size(withAttributes: [NSAttributedString.Key.font: self.font!])
    }
    
    public func animationError() {
        let snake = CABasicAnimation(keyPath: "position")
        snake.duration = 0.1
        snake.repeatCount = 3
        snake.autoreverses = true
        
        snake.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        snake.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor.clear.cgColor
        colorAnimation.toValue = #colorLiteral(red: 0.9568627477, green: 0.8265123661, blue: 0.7767734047, alpha: 1).cgColor
        colorAnimation.duration = 0.4
        colorAnimation.autoreverses = true
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.8
        animationGroup.animations = [colorAnimation, snake]
        
        layer.add(animationGroup, forKey: "groupAnimation")
        
        hapticSoftTap()
    }
    
    private func hapticSoftTap() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    
}
