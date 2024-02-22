//
//  HistoryTable.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 30.01.2024.
//

import UIKit


final class HistoryTableView: UIView {
    
    let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .clear
        table.tintColor = .clear
//        table.allowsSelection = false
        return table
    }()
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.updateTableContentInset()
        tableView.separatorStyle = .none
    }
    
    private func configure() {
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseId)
        backgroundColor = .clear
        
        topBlur.isUserInteractionEnabled = false
        bottomBlur.isUserInteractionEnabled = false
        
        addSubview(tableView)
        setupTableConstraints()
        addSubview(topBlur)
        addSubview(bottomBlur)
        setupBlurConstraints()
    }
    
    
    
}


// MARK:  Constraints

extension HistoryTableView {

    func setupTableConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = UIApplication.shared.getStatusBarFrame().height
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: height * 0.5),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
        ])
    }
    
    func setupBlurConstraints() {
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

