//
//  NumpadView.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 07.02.2024.
//

import UIKit

protocol NumpadDelegate: AnyObject {
    func number(_ sender: NumpadButton)
    func operating(_ sender: NumpadButton)
    func equal()
    func reset()
}


class NumpadView: UIView {

    private let buttonSize = CGSize(width: 60, height: 60)
    private let padding: CGFloat = 15
    
    weak var delegate: NumpadDelegate?
    
    private let numberButton: [NumpadButton] = [
        NumpadButton(buttonStyle: .number(NumberFormatter.getPoint())),
        NumpadButton(buttonStyle: .number("0")),
        NumpadButton(buttonStyle: .number("1")),
        NumpadButton(buttonStyle: .number("2")),
        NumpadButton(buttonStyle: .number("3")),
        NumpadButton(buttonStyle: .number("4")),
        NumpadButton(buttonStyle: .number("5")),
        NumpadButton(buttonStyle: .number("6")),
        NumpadButton(buttonStyle: .number("7")),
        NumpadButton(buttonStyle: .number("8")),
        NumpadButton(buttonStyle: .number("9"))
    ]
    
    override init(frame: CGRect) {
        let size = CGSize(width: 315, height: 390)
        let frame = CGRect(origin: .zero, size: size)
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .numpadColor()
        layer.cornerRadius = buttonSize.height / 2 + padding
    }
    
    private func setTarget() {
        
        
        
    }
    
    
    @objc func numberTap(_ sender: NumpadButton) {
        sender.animationTap()
        sender.hapticLightTap()
        delegate?.number(sender)
    }
    
    @objc func operatingTap(_ sender: NumpadButton) {
        delegate?.operating(sender)
    }
    
    @objc func equalTap() {
        delegate?.equal()
    }
    
    @objc func resetTap() {
        delegate?.reset()
    }
    
}
