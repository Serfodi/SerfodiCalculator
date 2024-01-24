//
//  UIButton + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.01.2024.
//

import UIKit

extension UIButton {
    
    public func animationTap() {
        let scaleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        scaleAnimation.values = [1, 0.9, 1]
        scaleAnimation.keyTimes = [0, 0.2, 1]
        
        let opacityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opacityAnimation.values = [0.4, 0.8, 1]
        opacityAnimation.keyTimes = [0, 0.2, 1]
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.5
        animationGroup.animations = [scaleAnimation, opacityAnimation]
        
        layer.add(animationGroup, forKey: "groupAnimation")        
    }
    
    
    // MARK: - FeedbackGenerator
    
    public func hapticLightTap() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    public func hapticMediumTap() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    /*
    func hapticRigidTap() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
    */
     
    public func hapticSoftTap() {
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.impactOccurred()
    }
    
    public func hapticHeavyTap() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
}
