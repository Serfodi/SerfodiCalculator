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
        
        let image = UIImage(systemName: "gearshape.fill")
        let button = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(openSetting))
        button.tintColor = UIColor.exampleColorSign()
        
        
        navigationItem.leftBarButtonItem = button
        
        self.tableView.contentInsetAdjustmentBehavior = .never
        
        tableView = HistoryTableView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.alpha = 0
        navigationController?.isNavigationBarHidden = true
        
    }
    
    @objc private func openSetting() {
        
        print("Настарйоки открыты")
        
    }
    
    
}

