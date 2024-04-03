//
//  ButtonContentConfiguration.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 14.03.2024.
//

import Foundation
import UIKit

class ButtonCellContentView: UIView, UIContentView {
    
    var button: UIButton = {
       let button = UIButton(type: .roundedRect)
        button.backgroundColor = SettingColorAppearance.ButtonCell.normalColor.color()
        button.setTitleColor(SettingColorAppearance.ButtonCell.titleColor.color(), for: .normal)
        button.layer.cornerRadius = 10
        button.titleLabel?.font = Font.att(size: 17, weight: .bold)
        return button
    }()
    
    private var currentConfiguration: ButtonCellContentConfiguration!
    
    var configuration: UIContentConfiguration {
            get {
                currentConfiguration
            }
            set {
                guard let newConfiguration = newValue as? ButtonCellContentConfiguration else {
                    return
                }
                apply(configuration: newConfiguration)
            }
        }
    
    init(configuration: ButtonCellContentConfiguration) {
        super.init(frame: .zero)
        configView()
        apply(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configView() {
        addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 40),
            button.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            button.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            button.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
    
    private func apply(configuration: ButtonCellContentConfiguration) {
        
        guard currentConfiguration != configuration else {
            return
        }
        
        currentConfiguration = configuration
        button.setTitle(configuration.buttonText, for: .normal)
        button.addAction(configuration.action!, for: .allTouchEvents)
    }
    
}
