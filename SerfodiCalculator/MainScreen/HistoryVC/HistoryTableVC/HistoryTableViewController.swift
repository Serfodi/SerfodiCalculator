//
//  HistoryTableViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 10.03.2024.
//

import UIKit


class HistoryTableViewController: UITableViewController {
    
    public var topBar: UINavigationBar {
        navigationController!.navigationBar
    }
    
    // MARK: - Live circle
    
    override func loadView() {
        super.loadView()
        tableView = HistoryTableView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.updateTableContentInset()
    }
    
// MARK: Action
    
    @objc private func openSetting() {
        let settingVC = SettingTableViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
}

// MARK: - ResponderChainActionSenderType
extension HistoryTableViewController: ResponderChainActionSenderType {
    @objc func doneTap(_ sender: AnyObject) {
        let event = DoneEvent(controller: self)
        let _ = sendNilTargetedAction(selector: .doneTap, sender: self, forEvent: event)
    }
}

// MARK: - Configuration navigationController
private extension HistoryTableViewController {
    func setupNavBar() {
        navigationController?.navigationBar.topItem?.title = "История"
        navigationController?.navigationBar.alpha = 0
        navigationController?.isNavigationBarHidden = true
        
        navigationItem.makeDone(target: self, selector: #selector(doneTap(_:)))
        
        let image = UIImage(systemName: "gearshape.fill")
        let leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(openSetting))
        leftBarButtonItem.tintColor = NavigationAppearance.leftBarButtonColor.color()
        navigationItem.leftBarButtonItem = leftBarButtonItem
    }
}

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
        var delay = 0.5
        for cell in cells {
            cell.alpha = 0
            UIView.animate(withDuration: 0.4, delay: delay * 0.1, options: .curveEaseOut) {
                cell.alpha = 1
            }
            delay += 1
        }
    }
}
