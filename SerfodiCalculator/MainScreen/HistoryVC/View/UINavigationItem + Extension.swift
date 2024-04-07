//
//  UINavigationItem + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.03.2024.
//

import UIKit


extension UINavigationItem {
    
    func makeDone(target: AnyObject, action: Selector) {
        rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: target, action: action)
    }
    
}

