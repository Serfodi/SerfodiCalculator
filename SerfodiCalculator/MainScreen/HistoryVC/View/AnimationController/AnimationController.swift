//
//  AnimationController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 27.03.2024.
//

import UIKit

class AnimationController: NSObject {
    
    private let animationDuration: Double
    private let animationType: AnimationType
    
    enum AnimationType {
        case push
        case pop
    }
    
    // MARK: init
    
    init(animationDuration: Double, animationType: AnimationType) {
        self.animationDuration = animationDuration
        self.animationType = animationType
    }
    
}

extension AnimationController: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        TimeInterval(exactly: animationDuration) ?? 0
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let toVC = transitionContext.viewController(forKey: .to),
              let fromVC = transitionContext.viewController(forKey: .from)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        switch animationType {
        case .push:
            transitionContext.containerView.addSubview(toVC.view)
            presentAnimation(with: transitionContext, viewToAnimation: toVC.view)
        case .pop:
            transitionContext.containerView.addSubview(toVC.view)
            transitionContext.containerView.addSubview(fromVC.view)
            dismissAnimation(with: transitionContext, viewToAnimation: fromVC.view)
        }
        
    }
    
    func presentAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimation: UIView) {
        viewToAnimation.clipsToBounds = true
        viewToAnimation.transform = CGAffineTransform(scaleX: 0, y: 0)
        let transitionDuration = transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: transitionDuration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut) {
            viewToAnimation.transform = CGAffineTransform(scaleX: 1, y: 1)
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
    func dismissAnimation(with transitionContext: UIViewControllerContextTransitioning, viewToAnimation: UIView) {
        let transitionDuration = transitionDuration(using: transitionContext)
        
//        let scale = CGAffineTransform(scaleX: 0.3, y: 0.3)
//        let moveOut = CGAffineTransform(translationX: -viewToAnimation.frame.width, y: 0)
        
        UIView.animate(withDuration: transitionDuration) {
            
            viewToAnimation.alpha = 0
            
        } completion: { _ in
            transitionContext.completeTransition(true)
        }
    }
    
}
