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
        
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        navigationController?.view.layer.add(transition, forKey: nil)
        
        
        navigationController?.pushViewController(settingVC, animated: false)
    }
    
    @objc private func done() {
        delegate?.done(to: self)
    }
    
    private func setupTable() {
        tableView = HistoryTableView()
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.topItem?.title = "История"
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
