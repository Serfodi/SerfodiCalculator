//
//  NumpadButton.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 07.02.2024.
//

import UIKit

/// Стиль кнопки
enum ButtonStyle {
    case secondOperation(Operation)
    
    func color() -> (UIColor, UIColor) {
        switch self {
        case .secondOperation:
            return (.operatingSecondButtonColor(), .operatingSecondTextColor())
        }
    }
    
}


final class NumpadButton: UIButton {

    private let size = CGSize(width: 60, height: 60)

    let buttonStyle: ButtonStyle
    
    init(_ buttonStyle: ButtonStyle) {
        self.buttonStyle = buttonStyle
        super.init(frame: CGRect(origin: .zero, size: size))
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let color = buttonStyle.color()
        backgroundColor = color.0
        setTitleColor(color.1, for: .normal)
        layer.cornerRadius = 30
        
        switch buttonStyle {
        case .secondOperation(let operation):
            setTitle(operation.getLiterallySymbol(), for: .normal)
            tag = operation.rawValue
        }
        
        self.titleLabel?.font = .numpad(size: 22)
    }
    
}
