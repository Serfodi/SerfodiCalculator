//
//  HistoryTableViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 10.03.2024.
//

import UIKit

protocol CloseHistory {
    func closeHistory()
}

class HistoryTableViewController: UITableViewController {

    public var delegate: CloseHistory?
    
    public var topBar: UINavigationBar {
        get {
            navigationController!.navigationBar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "История"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = .white
        
        let image = UIImage(systemName: "gearshape.fill")
        let leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(openSetting))
        leftBarButtonItem.tintColor = .exampleColorSign()
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneTapped))
        
        self.tableView.contentInsetAdjustmentBehavior = .never
        
        tableView = HistoryTableView()
        
        navigationController?.navigationBar.alpha = 0
        navigationController?.isNavigationBarHidden = true
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
    
    @objc private func doneTapped() {
        delegate?.closeHistory()
    }
    
    
    func showCellAnimation(_ cells: [UITableViewCell]) {
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

