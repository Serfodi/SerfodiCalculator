//
//  TableViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.02.2024.
//

import UIKit

class HistoryTableViewController: UITableViewController {

//    static let 
    
    
    public var dataProvider: DataProvider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    private func configure() {
        tableView.register(HistoryCell.self, forCellReuseIdentifier: HistoryCell.reuseId)
        tableView.dataSource = dataProvider
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
