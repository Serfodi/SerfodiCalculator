//
//  PullButton.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 16.02.2024.
//

import UIKit

class PullButton: UIButton {

    override func draw(_ rect: CGRect) {
        // Drawing code
        
        let _ = setStyle(in: rect, color: .focusColor())
    }
    
//    func image(in rect: CGRect, color: UIColor) -> UIImage {
//        UIGraphicsBeginImageContext(rect.size)
//
//        let _ = setStyle(in: rect, color: color)
//
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image!
//    }
    
    private func setStyle(in rect: CGRect, color: UIColor) -> UIBezierPath {
        let size = CGSize(width: 12, height: 56)
        let x = (rect.width - size.width) / 2
        let y = (rect.height - size.height) / 2
        let point = CGPoint(x: x, y: y)
        let path = UIBezierPath(roundedRect: CGRect(origin: point, size: size), cornerRadius: size.width / 2)
        color.setFill()
        path.fill()
        return path
    }
    
}
