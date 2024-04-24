//
//  TableViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.02.2024.
//

import UIKit


class HistoryViewController: UIViewController {
    
    private var tableViewController: HistoryTableViewController!
    
    private let topBlur = BlurView(styleGradient: .linear(.up(0.45)))
    private let bottomBlur = BlurView(styleGradient: .doubleLine(0.4, 0.5))
    private let leftBlur = BlurView(styleGradient: .linear(.left(0.3)))
    private let rightBlur = BlurView(styleGradient: .linear(.right(0.3)))
    
    private var historyBottomConstraint: NSLayoutConstraint!
    private var isOpen: Bool = false
    
    public var table: HistoryTableView {
        self.tableViewController.tableView as! HistoryTableView
    }
    
    public var stateVC: Bool { isOpen }
    
    //    MARK: - Live circle
    
    override func loadView() {
        super.loadView()
        tableViewController = HistoryTableViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
    }
    
    public func pinedVC(parentView: UIView, buttonView: UIView) {
        self.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: parentView.topAnchor),
            self.view.leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
            self.view.trailingAnchor.constraint(equalTo: parentView.trailingAnchor)
        ])
        historyBottomConstraint = self.view.bottomAnchor.constraint(equalTo: buttonView.topAnchor, constant: 20)
        historyBottomConstraint.isActive = true
    }
}

// MARK: - Configuration
private extension HistoryViewController {
    
    func configuration() {
        view.backgroundColor = .clear
        configurationNavigationController()
        configurationBlur()
    }
    
    func configurationNavigationController() {
        let navigationController = WhiteNavigationController(rootViewController: tableViewController)
        addChildVC(navigationController)
    }
    
    func addChildVC(_ navigationController: WhiteNavigationController) {
        addChild(navigationController)
        self.view.addSubview(navigationController.view)
        setupTableConstraints(navigationController.view)
        didMove(toParent: self)
    }
    
    func configurationBlur() {
        view.addSubview(leftBlur)
        view.addSubview(rightBlur)
        view.addSubview(topBlur)
        view.addSubview(bottomBlur)
        setupBlurConstraints()
    }
}

// MARK: - Constraints configuration
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
        leftBlur.translatesAutoresizingMaskIntoConstraints = false
        rightBlur.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint.activate([
            leftBlur.widthAnchor.constraint(equalToConstant: 20),
            leftBlur.topAnchor.constraint(equalTo: view.topAnchor),
            leftBlur.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            leftBlur.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            rightBlur.widthAnchor.constraint(equalToConstant: 20),
            rightBlur.topAnchor.constraint(equalTo: view.topAnchor),
            rightBlur.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            rightBlur.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - Animation
extension HistoryViewController {
    
    func animationOpen(updateConstraint: @escaping ()->(), completion: @escaping (Bool)->()) {
        
//        let beforeCells = table.visibleCells
//        var afterCells = beforeCells
        
        historyBottomConstraint.constant = UIApplication.shared.getWindow().frame.height - view.bounds.height + 40
        
        UIView.animate(withDuration: 0.45, delay: 0, options: [.curveEaseInOut, .layoutSubviews]) {
            updateConstraint()
            self.table.reversInset()
            self.topBlur.alpha = 0
            self.tableViewController.topBar.alpha = 1
            self.tableViewController.navigationController?.setNavigationBarHidden(false, animated: true)
            self.table.scrollToNearestSelectedRow(at: .top, animated: true)
            
//            afterCells = self.table.visibleCells
            
        } completion: { finish in
            self.isOpen = finish
            completion(finish)
        }
        
//        tableViewController.animationCells(beforeCells, afterCells)
    }
    
    func animationClose(_ indexPath: IndexPath?, updateConstraint: @escaping ()->(), completion: @escaping (Bool)->()) {
        historyBottomConstraint.constant = 20
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .layoutSubviews]) {
            updateConstraint()
            self.table.updateTableContentInset()
            self.topBlur.alpha = 1
            self.tableViewController.topBar.alpha = 0
            self.tableViewController.navigationController?.setNavigationBarHidden(true, animated: true)
            if let indexPath = indexPath {
                self.table.scrollToRow(at: indexPath, at: .bottom, animated: true)
            } else {
                self.table.scrollToBottom(animated: true)
            }
        } completion: { finish in
            self.isOpen = !finish
            completion(finish)
        }
    }
}
