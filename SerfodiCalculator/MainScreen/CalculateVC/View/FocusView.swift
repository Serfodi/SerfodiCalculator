//
//  FocusView.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 30.03.2024.
//

import UIKit

final class FocusView: UIView {
    
    private var label: UILabel
    private var widthConstraint: NSLayoutConstraint!
    private let radius: CGFloat = 17
    private var inRect: CGRect {
        label.frame
    }
    private var hight: CGFloat {
        label.font.lineHeight
    }
    
    init (for label: UILabel) {
        self.label = label
        super.init(frame: .zero)
        label.addSubview(self)
        pined()
        configuration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configuration() {
        backgroundColor = DisplayLabelAppearance.focusColor.color()
        layer.cornerRadius = radius
        isHidden = true
    }
    
    public func fitToSize(_ size: CGSize) {
        let newSize = size.width > inRect.size.width ? inRect.size : size
        widthConstraint.constant = newSize.width + radius
    }
    
    private func pined() {
        self.translatesAutoresizingMaskIntoConstraints = false
        widthConstraint = NSLayoutConstraint(item: self,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: nil,
                                             attribute: .width,
                                             multiplier: 1,
                                             constant: 0)
        widthConstraint.isActive = true
        self.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: label.rightAnchor, constant: radius / 2.0).isActive = true
        self.heightAnchor.constraint(equalToConstant: hight).isActive = true
    }
}
