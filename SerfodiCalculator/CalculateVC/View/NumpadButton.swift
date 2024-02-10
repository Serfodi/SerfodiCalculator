//
//  NumpadButton.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 07.02.2024.
//

import UIKit

/// Стиль кнопки
enum ButtonStyle {
    case number(String)
    case operation(String)
    case secondOperation(Operation)
    case service(String)
    
    func color() -> (UIColor, UIColor) {
        switch self {
        case .number:
            return (.numberButtonColor(), .numberTextColor())
        case .operation:
            return (.operatingButtonColor(), .operatingTextColor())
        case .secondOperation:
            return (.operatingSecondButtonColor(), .operatingSecondTextColor())
        case .service:
            return (.serviceButtonColor(), .serviceTextColor())
        }
    }
    
}




final class NumpadButton: UIButton {


    let buttonStyle: ButtonStyle
    
    init(buttonStyle: ButtonStyle) {
        self.buttonStyle = buttonStyle
        super.init(type: .system)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let color = buttonStyle.color()
        backgroundColor = color.0
        setTitleColor(color.1, for: .normal)
        switch buttonStyle {
        case .number(let text):
            setTitle(text, for: .normal)
        case .operation(let text):
            setTitle(text, for: .normal)
        case .secondOperation(let operation):
            setTitle(operation.rawValue, for: .normal)
        case .service(let text):
            setTitle(text, for: .normal)
        }
    }
    
    
    
}
