//
//  NumpadView.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 07.02.2024.
//

import UIKit

//@IBDesignable
final class NumpadView: UIView {

    weak var delegate: NumpadDelegate?

    var currentButton: UIButton!
    
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet var serviceButtons: [UIButton]!
    @IBOutlet var operationButtons: [UIButton]!
    @IBOutlet var numberButtons: [UIButton]!
    
    @IBOutlet var numpadButtons: [UIButton]!
    @IBOutlet var padView: UIView!
    
    private var currentOperationButton: UIButton? = UIButton() {
        didSet {
            guard let button = oldValue else { return }
            guard button != currentOperationButton else { return }
            button.backgroundColor = NumpadAppearance.OperatingButton.BGColor.normal.color()
            button.isSelected = false
        }
        willSet {
            guard let button = newValue else { return }
            guard button != currentOperationButton else { return }
            button.backgroundColor = NumpadAppearance.OperatingButton.BGColor.selected.color()
            button.isSelected = true
        }
    }
    
    
    init() {
        let size = CGSize(width: 315, height: 390)
        super.init(frame: CGRect(origin: .zero, size: size))
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        guard let view = loadViewFromXib() else { return }
        
        backgroundColor = .clear
        
        numpadButtons.forEach {
            $0.layer.cornerRadius = 30
            $0.tintColor = .clear
        }
        
        signButton.tintColor = NumpadAppearance.ServiceButton.titleColor.color()
        serviceButtons.forEach {
            $0.backgroundColor = NumpadAppearance.ServiceButton.normalColor.color()
            $0.setTitleColor(NumpadAppearance.ServiceButton.titleColor.color(), for: .normal)
            $0.titleLabel?.font = NumpadFontAppearance.numberFont
        }
        operationButtons.forEach {
            $0.backgroundColor = NumpadAppearance.OperatingButton.BGColor.normal.color()
            $0.setTitleColor(NumpadAppearance.OperatingButton.TitleColor.normal.color(), for: .normal)
            $0.setTitleColor(NumpadAppearance.OperatingButton.TitleColor.selected.color(), for: .selected)
            $0.titleLabel?.font = NumpadFontAppearance.numberFont
        }
        numberButtons.forEach {
            $0.backgroundColor = NumpadAppearance.NumberButton.normalColor.color()
            $0.setTitleColor(NumpadAppearance.NumberButton.titleColor.color(), for: .normal)
            $0.titleLabel?.font = NumpadFontAppearance.numberFont
        }
        
        view.layer.cornerRadius = 45
        view.backgroundColor = NumpadAppearance.numpadColor.color()
        addSubview(view)
    }
        
    private func loadViewFromXib() -> UIView? {
        Bundle.main.loadNibNamed("NumpadView", owner: self, options: nil)?.first as? UIView
    }
    
    @IBAction func numberTap(_ sender: UIButton) {
        currentOperationButton = nil
        delegate?.number!(sender)
    }
    
    @IBAction func minusTap(_ sender: UIButton) {
        delegate?.minusNum!(sender)
    }
    
    @IBAction func operatingTap(_ sender: UIButton) {
        currentOperationButton = sender
        delegate?.operating(sender)
    }
    
    @IBAction func equalTap(_ sender: UIButton) {
        currentOperationButton = nil
        delegate?.equal!(sender)
    }
    
    @IBAction func resetTap(_ sender: UIButton) {
        currentOperationButton = nil
        delegate?.reset!(sender)
    }
}
