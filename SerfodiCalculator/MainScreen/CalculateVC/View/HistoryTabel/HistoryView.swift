//
//  HistoryTable.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 30.01.2024.
//

import UIKit


final class HistoryView: UIView {
    
    let table = HistoryTableView()
    
    private let topBlur = BlurGradientView(location: [0.45, 1])
    private let bottomBlur = BlurGradientView(location: [0, 0.4, 0.5, 1], colors: [
        CGColor(gray: 0, alpha: 0),
        CGColor(gray: 0, alpha: 1),
        CGColor(gray: 0, alpha: 1),
        CGColor(gray: 0, alpha: 0)
    ])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    
    private func configure() {
        backgroundColor = .clear
        
        addSubview(table)
        setupTableConstraints()
        
        topBlur.isUserInteractionEnabled = false
        bottomBlur.isUserInteractionEnabled = false
        
        addSubview(topBlur)
        addSubview(bottomBlur)
        setupBlurConstraints()
    }
    
    
    
}


// MARK:  Constraints

extension HistoryView {

    
    private func setupTableConstraints() {
        table.translatesAutoresizingMaskIntoConstraints = false
        
        let height = UIApplication.shared.getStatusBarFrame().height
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: topAnchor, constant: height * 0.5),
            table.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            table.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            table.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16)
        ])
    }
    
    private func setupBlurConstraints() {
        topBlur.translatesAutoresizingMaskIntoConstraints = false
        bottomBlur.translatesAutoresizingMaskIntoConstraints = false

        let height = UIApplication.shared.getStatusBarFrame().height
        
        NSLayoutConstraint.activate([
            topBlur.heightAnchor.constraint(equalToConstant: height + 20),
            topBlur.topAnchor.constraint(equalTo: topAnchor),
            topBlur.trailingAnchor.constraint(equalTo: trailingAnchor),
            topBlur.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            bottomBlur.heightAnchor.constraint(equalToConstant: 40),
            bottomBlur.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBlur.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomBlur.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }

}

