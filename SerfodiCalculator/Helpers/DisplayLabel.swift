//
//  DisplayLabel.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import UIKit

final class DisplayLabel: UILabel {
    
    private let focusView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.05)
        view.isHidden = true
        return view
    }()
    private var widthConstraint = NSLayoutConstraint()
    private var heightConstraint = NSLayoutConstraint()
    private var rightConstraint = NSLayoutConstraint()
    
    private lazy var numberFormatter = NumberFormatter(locate: "ru_RU")
    
    public var labelNumber: Double {
        get {
            (numberFormatter.number(from: text ?? "0") ?? 0).doubleValue
        }
        set {
            text = numberFormatter.string(from: NSNumber(value: newValue))
        }
    }
    
    private var isErase: (CGFloat, Bool) = (0, false)
    
    override public var canBecomeFirstResponder: Bool { true }
    
    
    // MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        sharedInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
        sharedInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = bounds.height / 4
        
        // - @fix it
        if isFirstResponder {
            focusView.isHidden = true
            UIMenuController.shared.hideMenu()
        }
        //
        
        let textSize = textSize()
        let radius = bounds.height / 4
        rightConstraint.constant = radius / 2
        widthConstraint.constant = textSize.width + radius
        heightConstraint.constant = textSize.height
        focusView.layoutIfNeeded()
        focusView.layer.cornerRadius = radius
    }
    
    
    private func configure() {
        setupFocusView()
    }
    
}


// MARK: - Touches Erase

extension DisplayLabel {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocate = touches.first?.location(in: self) else { return }
        isErase.0 = touchLocate.x
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocate = touches.first?.location(in: self) else { return }
        if !isErase.1 && touchLocate.x - isErase.0 > 20 {
            isErase.1 = true
            if let text = text, text.count > 1 {
                self.text!.removeLast()
            } else {
                text = "0"
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isErase = (0, false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isErase = (0, false)
    }
    
}


// MARK: - shared Init / copy

extension DisplayLabel {
    
    private func sharedInit() {
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(showMenu(sender:))
        ))
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
        UIMenuController.shared.hideMenu()
        focusView.isHidden = true
    }
    
    @objc func showMenu(sender: Any?) {
        becomeFirstResponder()
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: self, rect: focusView.frame)
            focusView.isHidden = false
        }
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(copy(_:)))
    }
    
}


// MARK: - Focus View

extension DisplayLabel {
    
    private func setupFocusView() {
        addSubview(focusView)
        focusView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            focusView.topAnchor.constraint(equalTo: topAnchor),
            focusView.bottomAnchor.constraint(equalTo: bottomAnchor)
//            focusView.leftAnchor.constraint(lessThanOrEqualTo: leftAnchor)
        ])
        heightConstraint = NSLayoutConstraint(item: focusView,
                                             attribute: .height,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .height,
                                             multiplier: 0,
                                             constant: 0)
        widthConstraint = NSLayoutConstraint(item: focusView,
                                             attribute: .width,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .width,
                                             multiplier: 0,
                                             constant: 0)
        rightConstraint = NSLayoutConstraint(item: focusView,
                                             attribute: .right,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .right,
                                             multiplier: 1,
                                             constant: 0)
        rightConstraint.isActive = true
        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }
    
}

