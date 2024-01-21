//
//  ViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet var operationButton: [UIButton]!
    @IBOutlet var numberButton: [UIButton]!
    @IBOutlet weak var numpadView: UIView!
    @IBOutlet weak var pointButton: UIButton!
    
    
    var newInput = false
    var operation = ""
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    // MARK: - func button
    
    /// Кнопки от 0 до 9 и point
    @IBAction func numberButtonTap(_ sender: UIButton) {
        if newInput {
            inputLabel.text = ""
            newInput = false
        }
        inputLabel.text! += sender.currentTitle!
    }
    
    @IBAction func pointButtonTap(_ sender: UIButton) {
        inputLabel.text! += sender.currentTitle!
    }
    
    /// Кнопки опираций: / x - +
    @IBAction func operatingButtonTap(_ sender: UIButton) {
        operation = sender.currentTitle!
        print(operation)
        newInput = true
    }
    
    /// Кнопка =
    @IBAction func equallyButtonTap(_ sender: UIButton) {
        print("Нажални на кнопку равно")
    }
    
    /// Кнопка С
    @IBAction func clearButtonTap(_ sender: UIButton) {
        inputLabel.text! = ""
        newInput = false
    }
    
}


/*
extension ViewController {
    
    // MARK: - Create numpad
    
    private func createNumpad() {
        view.addSubview(numpadView)
        
        numpadView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            numpadView.heightAnchor.constraint(equalToConstant: CGFloat(sizeButton * row + padding * row + 1)),
            numpadView.widthAnchor.constraint(equalToConstant: CGFloat(sizeButton * column + padding * column + 1)),
            numpadView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -(CGFloat(padding))),
            numpadView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        
        let one = UIStackView(arrangedSubviews: [clearButton, operationButton[0]], axis: .horizontal, spacing: CGFloat(padding))
        one.heightAnchor.constraint(equalToConstant: CGFloat(sizeButton)).isActive = true
        
        let stackMainView = UIStackView(arrangedSubviews: [
            one
        ], axis: .vertical, spacing: CGFloat(padding))
        
        numpadView.addSubview(stackMainView)
        
        NSLayoutConstraint.activate([
            stackMainView.topAnchor.constraint(equalTo: numpadView.topAnchor, constant: CGFloat(padding)),
            stackMainView.bottomAnchor.constraint(equalTo: numpadView.bottomAnchor, constant: -CGFloat(padding)),
            stackMainView.trailingAnchor.constraint(equalTo: numpadView.trailingAnchor, constant: -CGFloat(padding)),
            stackMainView.leadingAnchor.constraint(equalTo: numpadView.leadingAnchor, constant: CGFloat(padding))
        ])
    }
    
}
 */
