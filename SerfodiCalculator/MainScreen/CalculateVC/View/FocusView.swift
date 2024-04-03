//
//  FocusView.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 30.03.2024.
//

import UIKit

final class FocusView: UIView {
    
    private let radius = { $0 / 4.0 }
    private var forBounds: CGRect
    
    init (for bounds: CGRect) {
        self.forBounds = bounds
        super.init(frame: .zero)
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        backgroundColor = DisplayLabelAppearance.focusColor.color()
        isHidden = true
    }
    
    public func fitToSize(_ size: CGSize) {
        let radius = radius(bounds.height)
        let x = forBounds.maxX - size.width
        let y = forBounds.origin.y
        let point = CGPoint(x: x, y: y)
        frame = CGRect(origin: point, size: size + radius)
        layer.cornerRadius = radius
    }
}
