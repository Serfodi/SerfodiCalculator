//
//  ResponderChainActionSenderType.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 18.04.2024.
//

import UIKit



protocol ResponderChainActionSenderType {}

/// Отпровляет 'Action to nil' по цепочке ответчиков
extension ResponderChainActionSenderType {
    
    func sendNilTargetedAction(selector: Selector, sender: AnyObject?, forEvent event: UIEvent? = nil) -> Bool {
        UIApplication.shared.sendAction(selector, to: nil, from: sender, for: event)
    }
}
