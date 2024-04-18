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
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    private var dataSetting: DataSetting = SettingManager().getDataSetting()
    
    private var dataMeneger: CoreDataManager!
    
    private var menu:[Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGroupedBackground
        dataMeneger = CoreDataManager()
        configMenu()
        configNavigationBar()
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    // MARK: Action
    
    func buttonTap() {
        dataMeneger.removeAllDataHistory { result in
            switch result {
            case .success():
                ()
            case .error(let error):
                print(error)
            }
        }
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        var newDataSetting = dataSetting
        newDataSetting.isSaveHistory = sender.isOn
        SettingManager().setDataSetting(newDataSetting)
    }
    
    fileprivate func configMenu() {
        let count = dataMeneger.dataСapacity()
        menu = [
            Section(name: "Память", items: [
                Item.dataTitle(count),
                Item.clearButton(count)
            ]),
            Section(items: [
                Item.isSaveSwitch(dataSetting.isSaveHistory)
            ])
        ]
    }
}

extension HistoryDataController: ResponderChainActionSenderType {
    @objc func done() {
        let event = DoneEvent(controller: self)
        let _ = sendNilTargetedAction(selector: .doneTap, sender: self, forEvent: event)
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
        navigationItem.makeDone(target: self, selector: #selector(done))
    }
    
    func setupCollectionView() {
        collectionView = SettingCollectionView(frame: view.bounds)
        view.addSubview(collectionView)
    }
    
}
