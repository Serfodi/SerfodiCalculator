//
//  NumpadController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 20.02.2024.
//

import UIKit

protocol NumpadOperationDelegate: AnyObject {
    func operating(_ operation: Operation)
}

protocol NumpadServiceDelegate: AnyObject {
    func number(_ num: String)
    func minusNum()
    func equal()
    func reset()
}

protocol NumpadDelegate: NumpadServiceDelegate, NumpadOperationDelegate {}

@objc protocol NumpadButtonDelegate: AnyObject {
    func operating(_ sender: UIButton)
    @objc optional func number(_ sender: UIButton)
    @objc optional func minusNum(_ sender: UIButton)
    @objc optional func equal(_ sender: UIButton)
    @objc optional func reset(_ sender: UIButton)
}

final class NumpadController: UIView {
    
    weak var delegate: NumpadDelegate?
    
    enum NumpadState {
        case general
        case second
        
        var opposite: NumpadState {
            switch self {
            case .second:
                return .general
            case .general:
                return .second
            }
        }
    }
    
    private var setting: GeneralSetting {
        SettingManager().getGeneralSetting()
    }
    
    private var currentState: NumpadState = .general
    
    private lazy var swipeLRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.addTarget(self, action: #selector(swipeL))
        recognizer.direction = .right
        return recognizer
    }()
    private lazy var swipeRRecognizer: UISwipeGestureRecognizer = {
        let recognizer = UISwipeGestureRecognizer()
        recognizer.addTarget(self, action: #selector(swipeR))
        recognizer.direction = .left
        return recognizer
    }()
    private lazy var panRecognizer: InstantPanGestureRecognizer = {
        let recognizer = InstantPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(dragSwipe(recognizer:)))
        return recognizer
    }()
    private lazy var popupOffset: CGFloat = {
        var constraint = bounds.width
        constraint -= (constraint - numpadView.frame.width) / 2
        return constraint
    }()
    
    private var numpadView = NumpadView()
    private var secondNumpadView = SecondNumpad()
    private var pullButton = PullButton()
    
    
    private var runningAnimators = [UIViewPropertyAnimator]()
    private var animationProgress = [CGFloat]()
    private var centerNumpadConstraint: NSLayoutConstraint!
    
    // MARK: init
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        backgroundColor = .clear
        setupConstrains()
        numpadView.addGestureRecognizer(swipeLRecognizer)
        secondNumpadView.addGestureRecognizer(swipeRRecognizer)
        pullButton.addGestureRecognizer(panRecognizer)
        numpadView.delegate = self
        secondNumpadView.delegate = self
    }
}


// MARK: Delegate

extension NumpadController: NumpadButtonDelegate {
    
    func operating(_ sender: UIButton) {
        if setting.isVibration {
            sender.hapticSoftTap()
        }
        if setting.isClicks {
            sender.animationTap()
        }
        guard let operation = Operation(rawValue: sender.tag) else { return }
        delegate?.operating(operation)
    }
    
    func number(_ sender: UIButton) {
        if setting.isClicks {
            if setting.isVibration {
                sender.hapticLightTap()
            }
        }
        sender.animationTap()
        delegate?.number("\(sender.tag)")
    }
    
    func minusNum(_ sender: UIButton) {
        if setting.isClicks {
            if setting.isVibration {
                sender.hapticLightTap()
            }
        }
        sender.animationTap()
        delegate?.minusNum()
    }
    
    func equal(_ sender: UIButton) {
        if setting.isClicks {
            if setting.isVibration {
                sender.hapticMediumTap()
            }
        }
        sender.animationTap()
        delegate?.equal()
    }
    
    func reset(_ sender: UIButton) {
        if setting.isClicks {
            if setting.isVibration {
                sender.hapticHeavyTap()
            }
        }
        sender.animationTap()
        delegate?.reset()
    }
}


// MARK: Touch

extension NumpadController {
    
    @objc private func swipeL() {
        animateTransitionIfNeeded(to: .second, duration: 0.45)
    }
    
    @objc private func swipeR() {
        animateTransitionIfNeeded(to: .general, duration: 0.45)
    }
    
    @objc private func dragSwipe(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animateTransitionIfNeeded(to: currentState.opposite, duration: 1)
            runningAnimators.forEach { $0.pauseAnimation() }
            animationProgress = runningAnimators.map { $0.fractionComplete }
            
        case .changed:
            // variable setup
            let translation = recognizer.translation(in: pullButton)
            var fraction = translation.x / popupOffset
            
            // adjust the fraction for the current state and reversed state
            if currentState == .second { fraction *= -1 }
            if runningAnimators[0].isReversed { fraction *= -1 }
            
            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }
            
        case .ended:
            // variable setup
            let xVelocity = recognizer.velocity(in: pullButton).x
            let shouldClose = xVelocity < 0
            
            // if there is no motion, continue all animations and exit early
            if xVelocity == 0 {
                runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }
            
            // reverse the animations based on their current state and pan motion
            switch currentState {
            case .second:
                if !shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .general:
                if shouldClose && !runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && runningAnimators[0].isReversed { runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            
            // continue all animations
            runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
        default:
            ()
        }
    }

    private func animateTransitionIfNeeded(to state: NumpadState, duration: TimeInterval) {
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }
        
        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            
            switch state {
            case .general:
                self.centerNumpadConstraint.constant = 0
            case .second:
                self.centerNumpadConstraint.constant = self.popupOffset
            }
            self.layoutIfNeeded()
        })
        
        // the transition completion block
        transitionAnimator.addCompletion { position in
            
            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            @unknown default:
                fatalError()
            }
            
            // manually reset the constraint positions
            switch self.currentState {
            case .general:
                self.centerNumpadConstraint.constant = 0
            case .second:
                self.centerNumpadConstraint.constant = self.popupOffset
            }
            
            // remove all running animators
            self.runningAnimators.removeAll()
        }
        
        transitionAnimator.startAnimation()
        runningAnimators.append(transitionAnimator)
    }
}

// MARK: - Constrains

extension NumpadController {
    
    private func setupConstrains() {
        addSubview(numpadView)
        addSubview(secondNumpadView)
        addSubview(pullButton)

        numpadView.translatesAutoresizingMaskIntoConstraints = false
        secondNumpadView.translatesAutoresizingMaskIntoConstraints = false
        pullButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            numpadView.topAnchor.constraint(equalTo: topAnchor),
            numpadView.bottomAnchor.constraint(equalTo: bottomAnchor),
            numpadView.heightAnchor.constraint(equalToConstant: 390),
            numpadView.widthAnchor.constraint(equalToConstant: 315)
        ])
        
        centerNumpadConstraint = NSLayoutConstraint(
            item: numpadView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1,
            constant: 0)
        centerNumpadConstraint.isActive = true
        
        let width = (UIScreen.main.bounds.width - 315) / 2
        
        NSLayoutConstraint.activate([
            pullButton.trailingAnchor.constraint(equalTo: numpadView.leadingAnchor),
            pullButton.leadingAnchor.constraint(equalTo: secondNumpadView.trailingAnchor),
            pullButton.widthAnchor.constraint(equalToConstant: width),
            pullButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            pullButton.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        secondNumpadView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        secondNumpadView.trailingAnchor.constraint(equalTo: pullButton.leadingAnchor).isActive = true
    }
}
