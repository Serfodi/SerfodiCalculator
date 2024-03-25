//
//  HistoryTableViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 10.03.2024.
//

import UIKit

protocol NavigationDoneDelegate {
    func done(to viewController: UIViewController)
}

class HistoryTableViewController: UITableViewController {

    public var delegate: NavigationDoneDelegate?
    
    public var topBar: UINavigationBar {
        get {
            navigationController!.navigationBar
        }
    }
    
    init(table: UITableView) {
        super.init(nibName: nil, bundle: nil)
        self.tableView = table
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        setupTable()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc private func openSetting() {
        let settingVC = SettingTableViewController()
        settingVC.delegate = delegate
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc private func done() {
        delegate?.done(to: self)
    }
    
    private func setupTable() {
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.topItem?.title = "История"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.alpha = 0
        navigationController?.isNavigationBarHidden = true
        
        navigationItem.makeDone(target: self, action: #selector(done))
        
        let image = UIImage(systemName: "gearshape.fill")
        let leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(openSetting))
        leftBarButtonItem.tintColor = .exampleColorSign()
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}

// MARK: Animation

extension HistoryTableViewController {
    
    public func animationCells(_ beforeCells: [UITableViewCell], _ afterCells: [UITableViewCell]) {
        let cells = afterCells.filter{ !beforeCells.contains($0) }
        let upsetCells = cells.filter {
            $0.frame.minY > beforeCells.first!.frame.maxY
        }
        let downCells = cells.filter {
            $0.frame.maxY < beforeCells.last!.frame.maxY
        }
        showCellAnimation(upsetCells)
        showCellAnimation(downCells.reversed())
    }
    
    private func showCellAnimation(_ cells: [UITableViewCell]) {
        var delay = 0.1
        for cell in cells {
            cell.alpha = 0
            UIView.animate(withDuration: 0.4, delay: delay * 0.05, options: .curveEaseOut) {
                cell.alpha = 1
            }
            delay += 1
        }
    }
}
