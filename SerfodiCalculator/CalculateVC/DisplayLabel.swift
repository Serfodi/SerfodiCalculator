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
    
    private lazy var numberFormatterDec = NumberFormatter(locate: "ru_RU")
    private lazy var numberFormatterE = NumberFormatter(style: .scientific)
    
    
    private var isErase: (CGFloat, Bool) = (0, false)
    
    override public var canBecomeFirstResponder: Bool { true }
    
    /// Отоброжаемое чило
    public var getNumber: Double? {
        guard let text = text else { return nil }
        return numberFormatterDec.number(from: text)?.doubleValue
    }
    
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
        resizeFocusView(textSize())
        
        // - @fix it
        if isFirstResponder {
            focusView.isHidden = true
            UIMenuController.shared.hideMenu()
        }
        //
    }
    
    private func configure() {
        setupFocusView()
    }
    
    /// Формотирует и устонавливает число в лейбел
    /// Вызыватся после того как получено число.
    /// В методах опираций или =
    public func setTextLabel(number: Double) {
        // Пытаемся преоброзовать к нормальному виду
        guard let numberDecText = numberFormatterDec.string(from: NSNumber(value: number)) else { return }
        
        
        // Проверяем влезает ли текст в лейбел или нет
        if isFitTextInto(numberDecText) {
            text = numberDecText
        } else {
            // в случае если нет, то делаем E
            
            text = fitFormatter(number, numberFormatterE.maximumFractionDigits).string(from: NSNumber(value: number))
            
        }
    }
    
    private func fitFormatter(_ number: Double, _ n: Int) -> NumberFormatter {
        let formatter = numberFormatterE
        formatter.maximumFractionDigits = n
        let numberDecText = numberFormatterE.string(from: NSNumber(value: number))
        if isFitTextInto(numberDecText) {
            return formatter
        } else {
            return fitFormatter(number, n - 1)
        }
    }
    
    
    
    
    /// Выполянет формотирования текста.
    /// Вызывается для формотирования ввода чисел.
    /// Формат всегда `Dec`
    public func performFormattingLabel() {
        guard let text = text,
              let numberText = numberFormatterDec.number(from: text)?.doubleValue
        else { return }
        self.text = numberFormatterDec.string(from: NSNumber(value: numberText))!
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
            // MARK:  @fix it
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
    
    private func resizeFocusView(_ textSize: CGSize) {
        let radius = bounds.height / 4
        rightConstraint.constant = radius / 2
        widthConstraint.constant = textSize.width + radius
        heightConstraint.constant = textSize.height + (radius * minimumScaleFactor)
        focusView.layoutIfNeeded()
        focusView.layer.cornerRadius = radius
    }
    
    private func setupFocusView() {
        addSubview(focusView)
        focusView.translatesAutoresizingMaskIntoConstraints = false
                
        focusView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
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


// MARK: - Animation Error


extension DisplayLabel {
    
    public func animationError() {
        let snake = CABasicAnimation(keyPath: "position")
        snake.duration = 0.1
        snake.repeatCount = 3
        snake.autoreverses = true
        
        snake.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 5, y: center.y))
        snake.toValue = NSValue(cgPoint: CGPoint(x: center.x + 5, y: center.y))
        
        let colorAnimation = CABasicAnimation(keyPath: "backgroundColor")
        colorAnimation.fromValue = UIColor.clear.cgColor
        colorAnimation.toValue = #colorLiteral(red: 0.9568627477, green: 0.8265123661, blue: 0.7767734047, alpha: 1).cgColor
        colorAnimation.duration = 0.4
        colorAnimation.autoreverses = true
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 0.8
        animationGroup.animations = [colorAnimation, snake]
        
        layer.add(animationGroup, forKey: "groupAnimation")
        
        hapticSoftTap()
    }
    
    private func hapticSoftTap() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
}
