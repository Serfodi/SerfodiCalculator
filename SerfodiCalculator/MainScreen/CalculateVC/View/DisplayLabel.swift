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

final class DisplayLabel: UILabel {
    
    private enum Appearance {
        static let minimumScaleFactor = 0.9
        static let font = MainFontAppearance.mainLabelFont
        static let adjustsFontSizeToFitWidth = true
        static let cornerRadius = { $0 / 4.0 }
        static let colorFont = EnvironmentColorAppearance.mainTextColor.color()
    }
    
    private var setting: EnvironmentSetting {
        SettingManager().getEnvironmentSetting()
    }
    
    private var focusView: FocusView!
    
    override public var canBecomeFirstResponder: Bool { true }
    
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
        focusView.fitToSize(textSize())
    }
    
    private func configure() {
        font = Appearance.font
        textColor = Appearance.colorFont
        minimumScaleFactor = Appearance.minimumScaleFactor
        adjustsFontSizeToFitWidth = Appearance.adjustsFontSizeToFitWidth
        layer.cornerRadius = Appearance.cornerRadius(bounds.height)
        focusView = FocusView(for: self)
    }
    
    /// Пытается преоброзовать текст `UILabel` в число  `Double?`
    public func getNumber() -> Double? {
        dynamicNumberFormatter.perform(text: text!)
    }
    
    /// Форматирует число и обновляет `text`
    /// В случае успеха преоброзования выводит результат на экран.
    public func setTextLabel(number: Double) {
        let nsNumber = number as NSNumber
        text = try! dynamicNumberFormatter.fitInBounds(number: nsNumber) { numberText in
            isFitTextInto(numberText, scale: minimumScaleFactor)
        }
        let setting = EnvironmentSetting(lastResult: getNumber())
        SettingManager().setEnvironmentSetting(setting)
    }
    
    /// Добавляет "цифру" к `text` и форматирует его.
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
    
    public func isCanAddDigit(new digit: String) -> Bool {
        isFitTextInto(text! + "0", scale: minimumScaleFactor)
    }
    
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
    
    public func clearInput() {
        setTextLabel(number: 0)
    }
    
    public func showError(labelText: String = "  Ошибка!") {
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(10.0), range: NSRange(location: labelText.count - 1, length: 1))
        attributedText = attributedString
        layer.errorAnimation()
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
}

// MARK: - Formatting input

extension DisplayLabel {
    
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
