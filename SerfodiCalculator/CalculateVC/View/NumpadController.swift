//
//  NumpadController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 20.02.2024.
//

import UIKit

final class NumpadController: UIView {
    
    public enum NumpadState {
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
    
    
    
}
