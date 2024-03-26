//
//  DesignViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 26.03.2024.
//

import UIKit

class DesignViewController: UIViewController {

    struct Section: Hashable {
        var name: String?
        var items: [SwitchItem]
    }
    
    struct SwitchItem: Hashable {
        var title: String
        var state: Bool
    }
    
    var delegate: NavigationDoneDelegate?
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, SwitchItem>!
    
    private static var designSetting: DesignSetting = SettingManager().getDesignSetting()
    
    let menu = [
        Section(items: [
            SwitchItem(title: "Ночная тема", state: designSetting.isDarkStyle)
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView = SettingCollectionView(frame: view.bounds)
        view.addSubview(collectionView)
        navigationItem.title = "Дизайн"
        navigationItem.makeDone(target: self, action:  #selector(done))
        createDataSource()
        reloadData()
        
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        DesignViewController.designSetting.isDarkStyle = sender.isOn
        SettingManager().setDesignSetting(DesignViewController.designSetting)
    }

    @objc func done() {
        delegate?.done(to: self)
    }
    
}

// MARK: - Data source

private extension DesignViewController {
    
    func createDataSource() {
        let switchCell = UICollectionView.CellRegistration<SwitchCellListCell, SwitchItem> { (cell, index, item) in
            cell.text = item.title
            cell.aSwitch.tag = index.row
            cell.config(isOn: item.state, target: self, action: #selector(self.switchChanged(_:)))
        }
        // dataSource
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, index, item in
            collectionView.dequeueConfiguredReusableCell(using: switchCell, for: index, item: item)
        }
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SwitchItem>()
        snapshot.appendSections(menu)
        for item in menu {
            snapshot.appendItems(item.items, toSection: item)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
