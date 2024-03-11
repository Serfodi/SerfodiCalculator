//
//  HistoryCell.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.01.2024.
//

import UIKit

/**
 
 Использовать форму E только если число занимат больше половыны всего лейбла.
 
 Нельзя разделять числа на два строки.
 
 Если пример не влазиет в две строки то, ответ будет выводится справа на отдельном view. Для просмотра больше нужно нажать на него.
 
 Размеры могут менятся динамически. Кол-во разрешеных строк на вывод примера тоже. Кол-во строк
 
 1. Запретить раздиление чисел на два обзаца
 
 
 */
final class HistoryCell: UITableViewCell {
    
    static let reuseId = "historyCell"
    
    private let numberLabel = ExpressionLabel()
    
    // MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        addSubview(numberLabel)
        
        numberLabel.frame = self.bounds
        
        setupNumberLabel()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNumberLabel()
    }
    
    /// Функция настройки из контролера
    public func config(calculation: Calculation) {
        numberLabel.setExpression(calculation: calculation)
    }
    
    override func prepareForReuse() {
        numberLabel.text = ""
    }
    
}


// MARK: - Constraint

extension HistoryCell {
    
    private func setupNumberLabel() {
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            numberLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            numberLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            numberLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }
    
//    private func setupBgView() {
//        bgView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            bgView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
//            bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
//            bgView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
//            bgView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
//        ])
//    }
    
}

