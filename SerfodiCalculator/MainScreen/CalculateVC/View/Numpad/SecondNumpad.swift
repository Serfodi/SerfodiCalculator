//
//  SecondNumpad.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 16.02.2024.
//

import UIKit


final class SecondNumpad: UIView, NumpadDelegate {
    
    public var delegate: NumpadDelegate?
        
    public let numpadButtons: [[NumpadButton]] = [
        [NumpadButton(.secondOperation(.pow2)),    NumpadButton(.secondOperation(.root2)),  NumpadButton(.secondOperation(.cosX)),  NumpadButton(.secondOperation(.sinX))],
        [NumpadButton(.secondOperation(.pow3)),    NumpadButton(.secondOperation(.root3)),  NumpadButton(.secondOperation(.tanX)),  NumpadButton(.secondOperation(.tanhX))],
        [NumpadButton(.secondOperation(.powXY)),   NumpadButton(.secondOperation(.rootYX)),  NumpadButton(.secondOperation(.sinhX)), NumpadButton(.secondOperation(.coshX))],
        [NumpadButton(.secondOperation(.pow10X)),     NumpadButton(.secondOperation(.precent)), NumpadButton(.secondOperation(.tanhX)), NumpadButton(.secondOperation(.pow10X))],
        [NumpadButton(.secondOperation(.divisionByOne)), NumpadButton(.secondOperation(.factorial)),   NumpadButton(.secondOperation(.lnX)),   NumpadButton(.secondOperation(.log2X))]
    ]
    
    private var mainVerticalStackView = UIStackView()
    private var spacing: CGFloat = 15
    
    /// frame высчитывается на основе `numpadButtons`
    override init(frame: CGRect) {
        let width: CGFloat = spacing * CGFloat(numpadButtons[0].count + 1) + numpadButtons[0][0].bounds.width * CGFloat(numpadButtons[0].count)
        let height: CGFloat = spacing * CGFloat(numpadButtons.count + 1) + numpadButtons[0][0].bounds.height * CGFloat(numpadButtons.count)
        let frame = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        setupView()
        setupStackView(numpadButtons: numpadButtons)
        setupConstraints()
        
        numpadButtons.forEach { array in
            array.forEach{ $0.addTarget(self, action: #selector(operating), for: .touchUpInside) }
        }
    }
    
    private func setupView() {
        backgroundColor = .numpadColor()
        layer.cornerRadius = 45
    }
    
    // MARK: - Operating
    
    @objc func operating(_ sender: UIButton) {
        sender.animationTap()
        sender.hapticSoftTap()
        delegate?.operating(sender)
    }
    
}

// MARK: Constraint

extension SecondNumpad {
    
    private func setupStackView(numpadButtons: [[NumpadButton]]) {
        var horizontalStackViews:[UIStackView] = []
        for buttons in numpadButtons {
            let stackView = UIStackView(arrangedSubviews: buttons)
            stackView.spacing = 15
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            horizontalStackViews.append(stackView)
        }
        mainVerticalStackView = UIStackView(arrangedSubviews: horizontalStackViews)
        mainVerticalStackView.axis = .vertical
        mainVerticalStackView.alignment = .fill
        mainVerticalStackView.distribution = .fillEqually
        mainVerticalStackView.spacing = 15
        self.addSubview(mainVerticalStackView)
    }
    
    private func setupConstraints() {
        
        self.widthAnchor.constraint(equalToConstant: self.bounds.width).isActive = true
        self.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        
        mainVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainVerticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        ])
        
        
        
    }
    
}
