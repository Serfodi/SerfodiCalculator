//
//  ButtonCellContentConfiguration.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 13.03.2024.
//

import UIKit

// MARK: ButtonCellContentConfiguration
 
struct ButtonCellContentConfiguration: UIContentConfiguration, Hashable {
    
    var buttonText: String?
    var action: UIAction?
    
    func makeContentView() -> UIView & UIContentView {
        ButtonCellContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> ButtonCellContentConfiguration {
        self
    }
    
}



