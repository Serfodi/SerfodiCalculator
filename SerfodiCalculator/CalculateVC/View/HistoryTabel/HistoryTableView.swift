//
//  HistoryTable.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 30.01.2024.
//

import UIKit


final class HistoryTableView: UIView {
    
    var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.showsHorizontalScrollIndicator = false
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .clear
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
//        tableView.register(nil, forCellWithReuseIdentifier: HistoryCell.reuseId)b
        backgroundColor = .clear
        addSubview(tableView)
        setupTableConstraints()
    }
    
    
    func setupTableConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
    
}


// MARK:  BlurView

//extension HistoryTableView {
//
//    func addBlurView() {
//        let topBlur = BlurGradientView(location: [0.45, 1])
//        let bottomBlur = BlurGradientView(location: [0, 0.4, 0.55, 1], colors: [
//            CGColor(gray: 0, alpha: 0),
//            CGColor(gray: 0, alpha: 1),
//            CGColor(gray: 0, alpha: 1),
//            CGColor(gray: 0, alpha: 0)
//        ])
//
//        view.insertSubview(topBlur, belowSubview: inputLabel)
//        view.insertSubview(bottomBlur, belowSubview: inputLabel)
//
//        topBlur.translatesAutoresizingMaskIntoConstraints = false
//        bottomBlur.translatesAutoresizingMaskIntoConstraints = false
//
//        let height = UIApplication.shared.getStatusBarFrame().height
//        NSLayoutConstraint.activate([
//            topBlur.heightAnchor.constraint(equalToConstant: height + 20),
//            topBlur.topAnchor.constraint(equalTo: view.topAnchor),
//            topBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            topBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor)
//        ])
//        NSLayoutConstraint.activate([
//            bottomBlur.heightAnchor.constraint(equalToConstant: 40),
//            bottomBlur.bottomAnchor.constraint(equalTo: historyTableView.bottomAnchor, constant: 20),
//            bottomBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            bottomBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor)
//        ])
//    }
//
//}
