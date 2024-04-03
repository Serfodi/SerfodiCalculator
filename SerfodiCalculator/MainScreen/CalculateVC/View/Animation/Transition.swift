//
//  Transition.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 31.03.2024.
//

import UIKit

extension CALayer {
    
    func animationTransition() {
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        add(transition, forKey: nil)
    }
    
}
