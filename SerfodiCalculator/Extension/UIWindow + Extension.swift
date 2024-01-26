//
//  UIWindow + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import UIKit

extension UIApplication {
    
    func getStatusBarFrame() -> CGRect {
        let windowScene = connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.getStatusBarFrame() ?? .zero
    }
    
}

extension UIWindow {
    
    func getStatusBarFrame() -> CGRect {
        self.windowScene?.statusBarManager?.statusBarFrame ?? .zero
    }
    
}
