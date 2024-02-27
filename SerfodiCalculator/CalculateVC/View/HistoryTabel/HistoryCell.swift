//
//  HistoryCell.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.01.2024.
//

import UIKit


final class HistoryCell: UITableViewCell {
    
    static let reuseId = "historyCell"
    
    private let numberLabel = ExpressionLabel()
    
    private var calculation: Calculation!
    
    
    // MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        let bgColorView = UIView()
        bgColorView.backgroundColor = .focusColor()
        bgColorView.layer.cornerRadius = 4
        selectedBackgroundView = bgColorView
        
        setupNumberLabel()
        numberLabel.frame = self.frame
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNumberLabel()
    }
    
    override func prepareForReuse() {
        numberLabel.text = ""
        calculation = nil
    }
    
    /// Функция настройки из контролера
    public func config(calculation: Calculation) {
        self.calculation = calculation
        numberLabel.expression(calculation)
    }
    
}

// MARK: - Constraint

extension HistoryCell {
    
    private func setupNumberLabel() {
        addSubview(numberLabel)
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            numberLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            numberLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 0)
        ])
    }
    
}
