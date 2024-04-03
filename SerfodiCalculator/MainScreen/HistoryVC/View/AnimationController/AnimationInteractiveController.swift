//
//  AnimationInteractiveController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 27.03.2024.
//

import UIKit


class StoryBaseAnimatedTransitioning: NSObject {
    
    private enum Spec {
        static let animationDuration: TimeInterval = 0.25
        static let cornerRadius: CGFloat = 20
        static let minimumScale = CGAffineTransform(scaleX: 0.85, y: 0.85)
    }
    
    private let operation: AnimationController.AnimationType
    
    init(operation: AnimationController.AnimationType) {
        self.operation = operation
    }
}

extension StoryBaseAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        /// Получаем доступ к представлению на котором происходит анимация (которое участвует в переходе).
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.clear
        
        /// Закругляем углы наших вью при транзишене.
        fromVC.view.layer.masksToBounds = true
        toVC.view.layer.masksToBounds = true
        
        /// Отвечает за актуальную ширину containerView
        // Swipe progress == width
        let width = containerView.frame.width

        /// Начальное положение fromViewController.view (текущий видимый VC)
        var offsetLeft = fromVC.view.frame
        
        
        /// Устанавливаем начальные значения для fromViewController и toVC
        switch operation {
        case .push:
            offsetLeft.origin.x = 0
            toVC.view.frame.origin.x = width
            toVC.view.transform = .identity
            toVC.view.layer.cornerRadius = 0
        case .pop:
            offsetLeft.origin.x = width
            toVC.view.frame.origin.x = 0
            toVC.view.transform = Spec.minimumScale
            toVC.view.layer.cornerRadius = Spec.cornerRadius
        }
        
        /// Перемещаем toVC.view над/под fromViewController.view, в зависимости от транзишена
        switch operation {
        case .push:
            containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
        case .pop:
            containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        
        // Так как мы уже определили длительность анимации, то просто обращаемся к ней
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            
            let moveViews = {
                toVC.view.frame = fromVC.view.frame
                fromVC.view.frame = offsetLeft
            }

            switch self.operation {
            case .push:
                moveViews()
                toVC.view.transform = .identity
                toVC.view.layer.cornerRadius = 0
                fromVC.view.transform = Spec.minimumScale
                fromVC.view.layer.cornerRadius = Spec.cornerRadius
            case .pop:
                toVC.view.transform = .identity
                toVC.view.layer.cornerRadius = 0
                fromVC.view.transform = .identity
                fromVC.view.layer.cornerRadius = Spec.cornerRadius
                moveViews()
            }
        }, completion: { _ in
            
            toVC.view.transform = .identity
            fromVC.view.transform = .identity
            
            if transitionContext.transitionWasCancelled {
                toVC.view.removeFromSuperview()
            }
            containerView.backgroundColor = .clear
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Spec.animationDuration
    }
}

