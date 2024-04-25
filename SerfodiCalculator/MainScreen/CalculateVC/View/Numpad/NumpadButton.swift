//
//  NumpadButton.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 07.02.2024.
//

import UIKit

enum ButtonStyle {
    case secondOperation(Operation)
    case number(Int)
}

final class NumpadButton: UIButton {
    private let size = CGSize(width: 60, height: 60)
    private let font = Font.att(size: 24)
    
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
        backgroundColor = NumpadAppearance.OperatingSecondButton.normalColor.color()
        setTitleColor(NumpadAppearance.OperatingSecondButton.titleColor.color(), for: .normal)
        layer.cornerRadius = 30
        
        switch buttonStyle {
        case .secondOperation(let operation):
            
            setTitle(operation.symbol(), for: .normal)
            tag = operation.rawValue
        case .number(let number):
            setTitle("\(number)", for: .normal)
            tag = number
        }
        
        self.titleLabel?.font = font
    }
    
//    override func actions(forTarget target: Any?, forControlEvent controlEvent: UIControl.Event) -> [String]? {
//        super.actions(forTarget: target, forControlEvent: controlEvent)
//        return super.actions(forTarget: target, forControlEvent: controlEvent)
//    }
}
