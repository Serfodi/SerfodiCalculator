//
//  InstantPanGestureRecognizer.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 20.02.2024.
//

import UIKit


class InstantPanGestureRecognizer: UIPanGestureRecognizer {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if (self.state == UIGestureRecognizer.State.began) { return }
        super.touchesBegan(touches, with: event)
        self.state = UIGestureRecognizer.State.began
    }
    
}
