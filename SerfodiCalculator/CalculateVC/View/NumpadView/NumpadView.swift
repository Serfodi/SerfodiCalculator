//
//  NumpadView.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 07.02.2024.
//

import UIKit

@objc protocol NumpadDelegate: AnyObject {
    func operating(_ sender: UIButton)
    @objc optional func number(_ sender: UIButton)
    @objc optional func minusNum(_ sender: UIButton)
    @objc optional func equal(_ sender: UIButton)
    @objc optional func reset(_ sender: UIButton)
}

//@IBDesignable
final class NumpadView: UIView {

    var delegate: NumpadDelegate?

    @IBOutlet var numpadButtons: [UIButton]!
    @IBOutlet var padView: UIView!
    
    private let longPressGesture = UILongPressGestureRecognizer()
    private let swipeGesture = UISwipeGestureRecognizer()
    
    private var currentOperationButton: UIButton? = UIButton() {
        didSet {
            guard let button = oldValue else { return }
            guard button != currentOperationButton else { return }
            button.backgroundColor = .operatingButtonColor()
            button.isSelected = false
        }
        willSet {
            guard let button = newValue else { return }
            guard button != currentOperationButton else { return }
            button.backgroundColor = .operatingSelectedButtonColor()
            button.isSelected = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        backgroundColor = .clear
        
//        addGesture()
        
        longPressGesture.delegate = self
//        swipeGesture.delegate = self
        
        guard let view = loadViewFromXib() else { return }
        
//        view.addGestureRecognizer(pressesGesture)
        view.layer.cornerRadius = 45
        view.backgroundColor = .numpadColor()
        
        addSubview(view)
    }
        
    private func loadViewFromXib() -> UIView? {
        Bundle.main.loadNibNamed("NumpadView", owner: self, options: nil)?.first as? UIView
    }
    
    @IBAction func numberTap(_ sender: UIButton) {
        sender.animationTap()
        sender.hapticLightTap()
        currentOperationButton = nil
        delegate?.number!(sender)
    }
    
    @IBAction func minusTap(_ sender: UIButton) {
        sender.animationTap()
        sender.hapticLightTap()
        delegate?.minusNum!(sender)
    }
    
    @IBAction func operatingTap(_ sender: UIButton) {
        sender.animationTap()
        sender.hapticSoftTap()
        currentOperationButton = sender
        delegate?.operating(sender)
    }
    
    @IBAction func equalTap(_ sender: UIButton) {
        sender.hapticMediumTap()
        sender.animationTap()
        currentOperationButton = nil
        delegate?.equal!(sender)
    }
    
    @IBAction func resetTap(_ sender: UIButton) {
        sender.hapticHeavyTap()
        sender.animationTap()
        currentOperationButton = nil
        delegate?.reset!(sender)
    }
    
}

// Touch

extension NumpadView: UIGestureRecognizerDelegate {
    
    private func addGesture() {
        swipeGesture.addTarget(self, action: #selector(handleSwipe(_:)))
        swipeGesture.direction = .right
        addGestureRecognizer(swipeGesture)
        longPressGesture.addTarget(self, action: #selector(handleLongPress(_:)))
        addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            hapticMediumTap()
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform(scaleX: 1.03, y: 1.03)
            })
        } else if gestureRecognizer.state == .ended {
            UIView.animate(withDuration: 0.3, animations: {
                self.transform = CGAffineTransform.identity
            })
        }
    }
    
    @objc func handleSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
        
  
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.longPressGesture && otherGestureRecognizer == self.swipeGesture {
            return true
        }
        return false
    }
 

    
}


extension NumpadView {
    
    public func hapticMediumTap() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
}
