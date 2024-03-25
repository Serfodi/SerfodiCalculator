//
//  HistoryDataController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 12.03.2024.
//

import UIKit

class HistoryDataController: UIViewController {
    
    struct Section: Hashable {
        var name: String?
        var items: [Item]
    }
    
    enum Item: Hashable {
        case dataTitle (Int)
        case clearButton (Int)
        case isSaveSwitch (Bool)
    }
    
    var delegate: NavigationDoneDelegate?
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    let menu = [
        Section(name: "Память", items: [
            Item.dataTitle(HistoryManager().storage.getSizeOfUserDefaults() ?? 0),
            Item.clearButton(HistoryManager().storage.getSizeOfUserDefaults() ?? 0)
        ]),
        Section(items: [
            Item.isSaveSwitch(SettingManager().getIsSaveHistoryData())
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigationBar()
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    // MARK: Action
    
    @objc func done() {
        delegate?.done(to: self)
    }
    
    func buttonTap() {
        HistoryManager().removeAllDataHistory()
        self.reloadData()
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        SettingManager().isSaveHistoryData(sender.isOn)
    }
}

// MARK: - Data source

private extension HistoryDataController {
    
    func createDataSource() {
        let labelCell = UICollectionView.CellRegistration<LabelCellListCell, Item> { (cell, _, item) in
            guard case .dataTitle(let data) = item else { fatalError() }
            cell.text = "Использование памяти"
            cell.secondText = "\(data) Мб"
        }
        let buttonCell = UICollectionView.CellRegistration<ButtonCellListCell, Item> { (cell, _, _) in
            cell.text = "Очистить"
            cell.action = UIAction { _ in
                self.buttonTap()
            }
        }
        let switchCell = UICollectionView.CellRegistration<SwitchCellListCell, Item> { (cell, _, item) in
            guard case .isSaveSwitch(let isState) = item else { fatalError() }
            cell.text = "Сохронять историю"
            cell.aSwitch.setOn(isState, animated: false)
            cell.aSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        }
        // dataSource
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, index, item in
            switch item {
            case .dataTitle:
                return collectionView.dequeueConfiguredReusableCell(using: labelCell, for: index, item: item)
            case .clearButton:
                return collectionView.dequeueConfiguredReusableCell(using: buttonCell, for: index, item: item)
            case .isSaveSwitch:
                return collectionView.dequeueConfiguredReusableCell(using: switchCell, for: index, item: item)
            }
        }
    }
    
    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(menu)
        for item in menu {
            snapshot.appendItems(item.items, toSection: item)
        }
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}



// MARK: Configuration

private extension HistoryDataController {
    
    func configNavigationBar() {
        navigationItem.title = "История"
        navigationItem.makeDone(target: self, action: #selector(done))
    }
    
    func setupCollectionView() {
        collectionView = SettingCollectionView(frame: view.bounds)
        view.addSubview(collectionView)
    }
    
}
