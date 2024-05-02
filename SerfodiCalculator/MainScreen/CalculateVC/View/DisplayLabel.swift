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

protocol InputManager {
    var number: Double? { get }
    func input(_ digit: String)
    func input(_ number: Double)
    func inputMinus()
    func removeLast()
    func clear()
    func showError()
}


final class DisplayLabel: UILabel {
    
    override public var canBecomeFirstResponder: Bool { true }
    
    weak var delegate: RemoveLastDigit?
    
private
    
    enum Appearance {
        static let minimumScaleFactor = 0.9
        static let font = MainFontAppearance.mainLabelFont
        static let adjustsFontSizeToFitWidth = true
        static let cornerRadius = { $0 / 4.0 }
        static let colorFont = EnvironmentColorAppearance.mainTextColor.color()
        static let errorText = "  Ошибка!"
    }
    
    var setting: EnvironmentSetting {
        SettingManager().getEnvironmentSetting()
    }
    
    var focusView: FocusView!
    
    /// Картеж для `Cтирание касанием`
    ///  1. Точка по x первого нажатия
    var isErase: (CGFloat, Bool) = (0, false)
    
    var dynamicNumberFormatter = DynamicNumberFormatter()
    
    
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
    
    func configure() {
        font = Appearance.font
        textColor = Appearance.colorFont
        minimumScaleFactor = Appearance.minimumScaleFactor
        adjustsFontSizeToFitWidth = Appearance.adjustsFontSizeToFitWidth
        layer.cornerRadius = Appearance.cornerRadius(bounds.height)
        focusView = FocusView(for: self)
    }
    
    func isCanAddDigit(new digit: String) -> Bool {
        isFitTextInto(text! + digit, scale: minimumScaleFactor)
    }
}


// MARK: - InputManager
extension DisplayLabel: InputManager {
    
    var number: Double? {
        dynamicNumberFormatter.perform(text: text!)
    }
    
    func input(_ digit: String) {
        guard isCanAddDigit(new: digit) else { return }
        switch digit {
        case NumberFormatter.getPoint():
            guard !dynamicNumberFormatter.isContainPoint(text!) else { return }
            text?.append(digit)
        default:
            text?.append(digit)
        }
        formattingInput()
    }
    
    func input(_ number: Double) {
        text = try! dynamicNumberFormatter.fitInBounds(number: number as NSNumber) { numberText in
            isFitTextInto(numberText, scale: minimumScaleFactor)
        }
        let setting = EnvironmentSetting(lastResult: number)
        SettingManager().setEnvironmentSetting(setting)
    }
    
    func inputMinus() {
        guard let _ = number else { return }
        if text!.contains(dynamicNumberFormatter.minusSign) {
            text!.removeFirst()
        } else {
            text?.insert(dynamicNumberFormatter.minusSign.first!, at: text!.startIndex)
        }
    }
    
    func removeLast() {
        guard !text!.contains(dynamicNumberFormatter.exponentSymbol) else { return }
        if text!.count > 2 || (!text!.contains(dynamicNumberFormatter.minusSign) && text!.count > 1) {
            text!.removeLast()
        } else {
            clear()
        }
        formattingInput(considerPoint: true)
    }
    
    func clear() {
        input(0)
    }
    
    func showError() {
        let labelText = Appearance.errorText
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: CGFloat(10.0), range: NSRange(location: labelText.count - 1, length: 1))
        attributedText = attributedString
        layer.errorAnimation()
    }
}


// MARK: - Formatting input
private extension DisplayLabel {
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
    func formattingInput(considerPoint: Bool = false)  {
        guard !dynamicNumberFormatter.isContainExponentSymbol(text!) else { return }
        guard !dynamicNumberFormatter.isContainPoint(text!) || considerPoint else { return }
        text = text!.replacingOccurrences(of: dynamicNumberFormatter.separator, with: "")
        if let number = number {
            text = dynamicNumberFormatter.performDec(number: number as NSNumber)
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
