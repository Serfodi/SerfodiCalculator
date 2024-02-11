//
//  DisplayLabel.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 25.01.2024.
//

import UIKit


@objc protocol RemoveLastDigit: AnyObject {
    @objc optional func removeLastDigit()
}


/// - Important: Вы ни когда не должны использовать `Label.text` для добавления или изменения строки в label.
///              Для этого использйте
///
final class DisplayLabel: UILabel {
    
    override public var canBecomeFirstResponder: Bool { true }
    
    /// View для фокусирования выдиления.
    private let focusView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.focusColor()
        view.isHidden = true
        return view
    }()
    /// Width Constraint для `focusView`
    private var widthConstraint = NSLayoutConstraint()
    /// Height Constraint для `focusView`
    private var heightConstraint = NSLayoutConstraint()
    /// Right Constraint для `focusView`
    private var rightConstraint = NSLayoutConstraint()
    /// CenterY Constraint для `focusView`
    private var centerYConstraint = NSLayoutConstraint()
    
    /// Картеж для `Cтирание касанием`
    ///  1. Точка по x первого нажатия
    private var isErase: (CGFloat, Bool) = (0, false)
    
    weak var delegate: RemoveLastDigit?
    
    private var dynamicNumberFormatter = DynamicNumberFormatter()
    
    
    
    // MARK: - init
    
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
        resizeFocusView()
    }
    
    private func configure() {
        font = UIFont.mainDisplay()
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        setupFocusView()
    }
    
    
    /// Пытается преоброзовать текст `UILabel` в число  `Double?`
    public func getNumber() -> Double? {
        dynamicNumberFormatter.perform(text: text!)
    }
    
    /// Форматирует число и обновляет `text`
    ///
    /// В случае успеха преоброзования выводит результат на экран.
    /// ````
    /// text = try! dynamicNumberFormatter.fitInBounds(number: nsNumber) { numberText in
    ///     isFitTextInto(numberText, scale: minimumScaleFactor)
    /// }
    /// ````
    /// - Note: Вызывайте его если хотите отформатировать вывод числа с динамическим форматом.
    ///
    public func setTextLabel(number: Double) {
        let nsNumber = number as NSNumber
        text = try! dynamicNumberFormatter.fitInBounds(number: nsNumber) { numberText in
            isFitTextInto(numberText, scale: minimumScaleFactor)
        }
    }
    
    /// Форматирует и пытается преоброзовать текст `UILabel` к числу  `Double`.
    ///
    /// В случае успеха преоброзования отпровляет callback с числом. Выводит результат на экран.
    /// ````
    /// text = dynamicNumberFormatter.perform(number: number as NSNumber)
    /// ````
    /// - Attention: Если в строке есть `exponentSymbol или point` то ничего не делает.
    /// - Requires: Поле `text` не должно быть пустым.
    /// - Note: Вызывайте его если хотите отформатировать пользовательский ввод числа. Он убирает пробелы в строке и форматирует число под `Dec` формат.
    /// - Remark: Вызывайте после изменения строки ввода.
    ///
    public func formattingInput(considerPoint: Bool = false, successful: (Double) -> ()) {
        guard !dynamicNumberFormatter.isContainExponentSymbol(text!) else { return }
        guard !dynamicNumberFormatter.isContainPoint(text!) || considerPoint else { return }
        
        text = text!.replacingOccurrences(of: dynamicNumberFormatter.separator, with: "")
        
        if let number = getNumber() {
            text = dynamicNumberFormatter.perform(number: number as NSNumber)
            successful(number)
        }
    }
    
    /// Добавляет "цифру" к `text`
    ///
    /// - Parameter digit Один введеный символ.
    /// - Returns: `true` если получилось добавить новое число. `False` если не получилось (символ нарушает правила ввода числа).
    /// - Note: Следит за правельностью набора строки.
    ///
    public func inputDigit(add digit: String, successful: (Double) -> ()) {
        switch digit {
        case NumberFormatter.getPoint():
            guard !dynamicNumberFormatter.isContainPoint(text!) else { return }
            text?.append(digit)
        default:
            text?.append(digit)
        }
        
        formattingInput { number in
            successful(number)
        }
    }
    
    /// Справшивает `Label` можно ли добавить еще одну цифру.
    public func isCanAddDigit(new digit: String) -> Bool {
        /*
         1. Доболяем в текст
         2. Преоброзовываем в число
         3. Снова форматируем
         4. Смотрим. Если влазиет то true
         */
        isFitTextInto(text! + "0", scale: minimumScaleFactor)
    }
    
    /// Удаляет последнуюю цифру в `text`
    public func removeLastDigit() {
        guard !text!.contains(dynamicNumberFormatter.exponentSymbol) else { return }
        
        
        if text!.count > 2 || (!text!.contains(dynamicNumberFormatter.minusSign) && text!.count > 1) {
            text!.removeLast()
        } else {
            text! = "0"
        }
        formattingInput(considerPoint: true) { _ in }
    }
    
    public func addMinusNumber() {
        guard let _ = getNumber() else { return }
        if text!.contains(dynamicNumberFormatter.minusSign) {
            text!.removeFirst()
        } else {
            text?.insert(dynamicNumberFormatter.minusSign.first!, at: text!.startIndex)
        }
    }
    
}



// MARK: Touches Erase

extension DisplayLabel {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let touchLocate = touch.location(in: self)
        isErase.0 = touchLocate.x
        
        if touch.view != focusView {
            hideCopyMenu()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touchLocate = touches.first?.location(in: self) else { return }
        
        if !isErase.1 && touchLocate.x - isErase.0 > 20 {
            isErase.1 = true
            delegate?.removeLastDigit?()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isErase = (0, false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        isErase = (0, false)
    }
    
}


// MARK:  shared Init / copy

extension DisplayLabel {
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return (action == #selector(copy(_:)))
    }
    
    private func sharedInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(hideFocusView), name: UIMenuController.willHideMenuNotification, object: nil)
        isUserInteractionEnabled = true
        addGestureRecognizer(UILongPressGestureRecognizer(
            target: self,
            action: #selector(showMenu(sender:))
        ))
    }
    
    override func copy(_ sender: Any?) {
        UIPasteboard.general.string = text
        hideCopyMenu()
    }
    
    @objc func showMenu(sender: Any?) {
        becomeFirstResponder()
        resizeFocusView()
        focusView.isHidden = false
        let menu = UIMenuController.shared
        if !menu.isMenuVisible {
            menu.showMenu(from: self, rect: focusView.frame)
        }
    }
    
    @objc private func hideFocusView() {
        focusView.isHidden = true
    }
    
    private func hideCopyMenu() {
        let menu = UIMenuController.shared
        if menu.isMenuVisible {
            menu.hideMenu()
        }
    }
    
    
}


// MARK:  Focus View

extension DisplayLabel {
    
    private func resizeFocusView() {
        
        let textSize = textSize()
        
        var width: CGFloat = textSize.width
        var hight: CGFloat = textSize.height
        
        let radius = bounds.height / 4
        
        if textSize.width > bounds.width {
            hight = bounds.height * minimumScaleFactor
            width = bounds.width + hight / 4 * minimumScaleFactor
            centerYConstraint.constant = (1 - minimumScaleFactor) * 10
            rightConstraint.constant = radius / 2 * minimumScaleFactor
        } else {
            width = textSize.width + radius
            hight = textSize.height + radius
            rightConstraint.constant = radius / 2
        }
        
        widthConstraint.constant = width
        heightConstraint.constant = hight
        
        focusView.layoutIfNeeded()
        focusView.layer.cornerRadius = radius
    }
    
    private func setupFocusView() {
        addSubview(focusView)
        focusView.translatesAutoresizingMaskIntoConstraints = false
        centerYConstraint = NSLayoutConstraint(item: focusView,
                                               attribute: .centerY,
                                             relatedBy: .equal,
                                             toItem: self,
                                             attribute: .centerY,
                                             multiplier: 1,
                                             constant: 0)
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
        centerYConstraint.isActive = true
    }
    
}


// MARK:  Animation Error

extension DisplayLabel: CAAnimationDelegate {
    
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
        
//        animationGroup.stop
        
        animationGroup.delegate = self
        
        layer.add(animationGroup, forKey: "groupAnimation")
        
        hapticSoftTap()
    }
    
    private func hapticSoftTap() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
 
    
    func animationDidStart(_ anim: CAAnimation) {
      
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    
    }
    
}



