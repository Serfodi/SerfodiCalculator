//
//  TableViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.02.2024.
//

import UIKit

final class HistoryViewController: UIViewController {
    
    public var isOpen: Bool = false
    
    public var table: UITableView {
        get {
            self.tableViewController.tableView
        }
    }
    
    public var castomNavigationController: NavigationController!
    
    public let tableViewController = HistoryTableViewController()
    
    
    public let topBlur = BlurView(styleGradient: .linear(.up(0.45)))
    public let bottomBlur = BlurView(styleGradient: .doubleLine(0.4, 0.5))
    
    
    // MARK: init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navigationController = UINavigationController(rootViewController: tableViewController)
        
//        castomNavigationController = NavigationController(rootViewController: tableViewController)
        
        addChild(navigationController)
        self.view.addSubview(navigationController.view)
        setupTableConstraints(navigationController.view)
        didMove(toParent: self)
        
        configure()
    }
    
    
    private func configure() {
        view.backgroundColor = .clear
        
        topBlur.isUserInteractionEnabled = false
        bottomBlur.isUserInteractionEnabled = false
        view.addSubview(topBlur)
        view.addSubview(bottomBlur)
        setupBlurConstraints()
    }
    
}

// MARK:  Constraints

extension HistoryViewController {
    
    private func setupTableConstraints(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        ])
    }
    
    
    private func setupBlurConstraints() {
        topBlur.translatesAutoresizingMaskIntoConstraints = false
        bottomBlur.translatesAutoresizingMaskIntoConstraints = false

        let statusHeight = UIApplication.shared.getStatusBarFrame().height
        
        NSLayoutConstraint.activate([
            topBlur.heightAnchor.constraint(equalToConstant: statusHeight + 20),
            topBlur.topAnchor.constraint(equalTo: view.topAnchor),
            topBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomBlur.heightAnchor.constraint(equalToConstant: 40),
            bottomBlur.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
}
