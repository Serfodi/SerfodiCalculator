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
        
        
//        transitionContext.
        
        /// 2 Получаем доступ к представлению на котором происходит анимация (которое участвует в переходе).
        let containerView = transitionContext.containerView
        containerView.backgroundColor = UIColor.clear
        
        /// 3 Закругляем углы наших вью при транзишене.
        fromVC.view.layer.masksToBounds = true
        toVC.view.layer.masksToBounds = true
//        fromVC.view.layer.cornerRadius = Spec.cornerRadius
//        toVC.view.layer.cornerRadius = Spec.cornerRadius
        
        /// 4 Отвечает за актуальную ширину containerView
        // Swipe progress == width
        let width = containerView.frame.width

        /// 5 Начальное положение fromViewController.view (текущий видимый VC)
        var offsetLeft = fromVC.view.frame
        
//        let finishToColor = toVC.view.backgroundColor // Серый цвет куда
//        let finishFromColor = fromVC.view.backgroundColor // откуда Белый цвет
        
        let finishToColor: UIColor = .systemGroupedBackground // Серый цвет куда
        let finishFromColor: UIColor = .white // откуда Белый цвет
        
        
        /// 6 Устанавливаем начальные значения для fromViewController и toVC
        switch operation {
        case .push:
            offsetLeft.origin.x = 0
            toVC.view.frame.origin.x = width
            toVC.view.transform = .identity
            toVC.view.backgroundColor = finishFromColor
            toVC.view.alpha = 0.5
            
            toVC.view.layer.cornerRadius = 0
            
        case .pop:
            offsetLeft.origin.x = width
            toVC.view.frame.origin.x = 0
            toVC.view.transform = Spec.minimumScale
            
            toVC.view.layer.cornerRadius = Spec.cornerRadius
        }
        
        /// 7 Перемещаем toVC.view над/под fromViewController.view, в зависимости от транзишена
        switch operation {
        case .push:
            containerView.insertSubview(toVC.view, aboveSubview: fromVC.view)
        case .pop:
            containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        }
        
        // Так как мы уже определили длительность анимации, то просто обращаемся к ней
        let duration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            
            /// 8. Выставляем финальное положение вью-контроллеров для анимации и трансформируем их.
            let moveViews = {
                toVC.view.frame = fromVC.view.frame
                fromVC.view.frame = offsetLeft
            }

            switch self.operation {
            case .push:
                moveViews()
                
                toVC.view.transform = .identity
                toVC.view.backgroundColor = finishToColor
                toVC.view.alpha = 1
                toVC.view.layer.cornerRadius = 0
                
                fromVC.view.transform = Spec.minimumScale
                fromVC.view.layer.cornerRadius = Spec.cornerRadius
                
            case .pop:
                // нижняя когда я убираю влево
                toVC.view.transform = .identity
                toVC.view.layer.cornerRadius = 0
                
                // верхния когда я убираю влево
                fromVC.view.transform = .identity
                fromVC.view.backgroundColor = finishFromColor
                fromVC.view.alpha = 0.4
                fromVC.view.layer.cornerRadius = Spec.cornerRadius
                
                
                moveViews()
            }
            
        }, completion: { _ in
            
            ///9.  Убираем любые возможные трансформации и скругления
            toVC.view.transform = .identity
            fromVC.view.transform = .identity
            
//            fromVC.view.layer.masksToBounds = true
//            fromVC.view.layer.cornerRadius = 0
            
//            toVC.view.layer.masksToBounds = true
//            toVC.view.layer.cornerRadius = 0
     
//            toVC.view.backgroundColor = finishToColor
//            fromVC.view.backgroundColor = finishFromColor
            
            /// 10. Если переход был отменен, то необходимо удалить всё то, что успели сделали. То есть необходимо удалить toVC.view из контейнера.
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

