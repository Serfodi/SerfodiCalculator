//
//  WhiteNavigationBar.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 27.03.2024.
//

import UIKit


final class WhiteNavigationController: UINavigationController {
    
    private lazy var percentDrivenInteractiveTransition: UIPercentDrivenInteractiveTransition? = nil
    private lazy var operation: AnimationController.AnimationType? = nil
    
    private var interactiveGesture = UIPanGestureRecognizer()
    
    public var isPopEnabled: Bool = true {
        didSet {
            interactiveGesture.isEnabled = isPopEnabled
        }
    }
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        navigationBar.shadowImage = UIImage()
        
        let bounds = navigationBar.bounds
        let view = UIView(frame: bounds)
        view.backgroundColor = NavigationAppearance.backgroundColor.color()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationBar.setBackgroundImage(view.snapshot, for: .default)
        
        delegate = self
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        interactiveGesture.addTarget(self, action: #selector(handlePanGesture(_:)))
        interactiveGesture.delegate = self
        view.addGestureRecognizer(interactiveGesture)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let bounds = navigationBar.bounds
        let view = UIView(frame: bounds)
        view.backgroundColor = NavigationAppearance.backgroundColor.color()
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        navigationBar.setBackgroundImage(view.snapshot, for: .default)
    }
}

extension WhiteNavigationController: UIGestureRecognizerDelegate {
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        let velocity = panGesture.velocity(in: view)
        var percent: CGFloat {
            switch operation {
            case .push:
                return abs(min(panGesture.translation(in: view).x, 0)) / view.frame.width
            case .pop:
                return max(panGesture.translation(in: view).x, 0) / view.frame.width
            default:
                return max(panGesture.translation(in: view).x, 0) / view.frame.width
            }
        }
        
        switch panGesture.state {
        case .began:
            percentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
            percentDrivenInteractiveTransition?.completionCurve = .easeInOut
            if velocity.x > 0 {
                operation = .pop
                popViewController(animated: true)
            } else {
                operation = .push
            }
        case .changed:
            percentDrivenInteractiveTransition?.update(percent)
        case .ended:
            if percent > 0.4 || velocity.x > 1200 {
                percentDrivenInteractiveTransition?.finish()
            } else {
                percentDrivenInteractiveTransition?.cancel()
            }
            percentDrivenInteractiveTransition = nil
        case .cancelled, .failed:
            percentDrivenInteractiveTransition?.cancel()
            percentDrivenInteractiveTransition = nil
        default:
            break
        }
    }
}


extension WhiteNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return StoryBaseAnimatedTransitioning(operation: .push)
        case .pop:
            return StoryBaseAnimatedTransitioning(operation: .pop)
        default:
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        percentDrivenInteractiveTransition
    }
}
