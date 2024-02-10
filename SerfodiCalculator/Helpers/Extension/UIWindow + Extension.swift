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
    
    func getStyle() -> UIUserInterfaceStyle {
        let windowScene = connectedScenes.first as? UIWindowScene
        return windowScene!.windows.first!.getStyle()
    }
    
}

extension UIWindow {
    
    func getStatusBarFrame() -> CGRect {
        self.windowScene?.statusBarManager?.statusBarFrame ?? .zero
    }
    
    func getStyle() -> UIUserInterfaceStyle {
        overrideUserInterfaceStyle
    }
    
}
