//
//  NumpadView.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 07.02.2024.
//

import UIKit

protocol NumpadDelegate: AnyObject {
    func number(_ sender: UIButton)
    func minusNum(_ sender: UIButton)
    func operating(_ sender: UIButton)
    func equal(_ sender: UIButton)
    func reset(_ sender: UIButton)
}

//@IBDesignable
final class NumpadView: UIView {

    var delegate: NumpadDelegate?

    @IBOutlet var numpadButtons: [UIButton]!
    @IBOutlet var padView: UIView!
    
    private var currentOperationButton: UIButton? = UIButton() {
        didSet {
            guard let button = oldValue else { return }
            guard button != currentOperationButton else { return }
            button.backgroundColor = UIColor.operatingButtonColor()
            button.isSelected = false
        }
        willSet {
            guard let button = newValue else { return }
            guard button != currentOperationButton else { return }
            button.backgroundColor = UIColor.operatingSelectedButtonColor()
            button.isSelected = true
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        backgroundColor = .clear
        
        guard let view = loadViewFromXib() else { return }
        
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
        delegate?.number(sender)
    }
    
    @IBAction func minusTap(_ sender: UIButton) {
        sender.animationTap()
        sender.hapticLightTap()
        delegate?.minusNum(sender)
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
        delegate?.equal(sender)
    }
    
    @IBAction func resetTap(_ sender: UIButton) {
        sender.hapticHeavyTap()
        sender.animationTap()
        currentOperationButton = nil
        delegate?.reset(sender)
    }
    
}
