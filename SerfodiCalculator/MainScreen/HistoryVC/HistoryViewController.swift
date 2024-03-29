//
//  TableViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.02.2024.
//

import UIKit

final class HistoryViewController: UIViewController {
    
    private var tableViewController: HistoryTableViewController!
    private let topBlur = BlurView(styleGradient: .linear(.up(0.45)))
    private let bottomBlur = BlurView(styleGradient: .doubleLine(0.4, 0.5))
    
    private var historyBottomConstraint: NSLayoutConstraint!
    private var isOpen: Bool = false
    
    public var delegate: NavigationDoneDelegate? {
        get {
            tableViewController.delegate
        }
        set {
            tableViewController.delegate = newValue
        }
    }
    
    public var table: UITableView {
        get {
            self.tableViewController.tableView
        }
    }
    
    public var stateVC: Bool {
        get {
            isOpen
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewController = HistoryTableViewController()
        
        let navigationController = WhiteNavigationController(rootViewController: tableViewController)
        
        addChild(navigationController)
        self.view.addSubview(navigationController.view)
        setupTableConstraints(navigationController.view)
        didMove(toParent: self)
        
        configure()
    }
    
    private func configure() {
        view.backgroundColor = .clear
        configurationBlur()
    }
 
    private func configurationBlur() {
        topBlur.isUserInteractionEnabled = false
        bottomBlur.isUserInteractionEnabled = false
        view.addSubview(topBlur)
        view.addSubview(bottomBlur)
        setupBlurConstraints()
    }
    
    /// Устанавливает ограничения. Устанавливает нижний динамический констрейнт
    public func pinedVC(parentView: UIView, buttonView: UIView) {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: parentView.topAnchor),
            self.view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])
        historyBottomConstraint = NSLayoutConstraint(item: self.view!,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: buttonView,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 20)
        historyBottomConstraint.isActive = true
    }
    
}

// MARK: Animation

extension HistoryViewController {
    
    func animationOpen(_ indexPath: IndexPath?, updateConstraint: @escaping ()->()) {
        let beforeCells = table.visibleCells
        var afterCells = beforeCells
        historyBottomConstraint.constant = UIApplication.shared.getWindow().frame.height - view.bounds.height + 40
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            updateConstraint()
            afterCells = self.table.visibleCells
            self.tableViewController.topBar.alpha = 1
            self.topBlur.alpha = 0
            self.bottomBlur.alpha = 0
            self.tableViewController.navigationController?.setNavigationBarHidden(false, animated: true)
            if let indexPath = indexPath {
                self.table.scrollToRow(at: indexPath, at: .top, animated: true)
            } else {
                self.table.showLastCell(animated: true)
            }
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.bottomBlur.alpha = 1
            }
        }
        tableViewController.animationCells(beforeCells, afterCells)
        isOpen = true
    }
    
    func animationClose(_ indexPath: IndexPath?, updateConstraint: @escaping ()->()) {
        UIView.animate(withDuration: 0.2) {
            self.bottomBlur.alpha = 0
        }
        historyBottomConstraint.constant = 20
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            updateConstraint()
            self.topBlur.alpha = 1
            self.bottomBlur.alpha = 1
            self.tableViewController.topBar.alpha = 0
            self.tableViewController.navigationController?.setNavigationBarHidden(true, animated: true)
            if let indexPath = indexPath {
                self.table.scrollToRow(at: indexPath, at: .bottom, animated: true)
            } else {
                self.table.showLastCell(animated: true)
            }
        }
        isOpen = false
    }
}


// MARK:  Constraints

private extension HistoryViewController {
    
    func setupTableConstraints(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20),
            view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        ])
    }
    
    func setupBlurConstraints() {
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
