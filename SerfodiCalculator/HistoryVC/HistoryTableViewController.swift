//
//  HistoryTableViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 10.03.2024.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    public var topBar: UINavigationBar {
        get {
            navigationController!.navigationBar
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "История"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.tableView.contentInsetAdjustmentBehavior = .never
        
        tableView = HistoryTableView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.alpha = 0
        navigationController?.isNavigationBarHidden = true
        
    }
    
}
