//
//  UILabel + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import UIKit

extension UILabel {
    
    /// Размер текущего текста с учетом `minimumScaleFactor`
    public func textSize() -> CGSize {
        let size = sizeText()
        if size.width > self.bounds.width {
            let hight = size.height * minimumScaleFactor
            return CGSize(width: self.bounds.width, height: hight)
        }
        return size
    }
    
    /// Размер текста
    public func sizeText() -> CGSize {
        guard let text = text else { return CGSize.zero }
        return text.size(font: font)
    }
    
    /// Размер текста
    public func sizeText(_ text: String) -> CGSize {
        text.size(font: font)
    }
    
    /// Влазиет ли текст.
    ///
    /// `true` - текст меньше.
    ///
    /// C учетом `minimumScaleFactor`
    public func sizeToText() -> Bool {
        (sizeText().width + "0".size(font: font).width) * minimumScaleFactor < self.bounds.width
    }
    
    
    /// Влазиет ли текст.
    ///
    /// `true` - текст меньше.
    ///
    /// C учетом `minimumScaleFactor`
    public func sizeToText(_ text: String) -> Bool {
        (sizeText(text).width) * minimumScaleFactor < self.bounds.width
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
