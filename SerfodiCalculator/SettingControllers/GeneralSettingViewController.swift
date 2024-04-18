//
//  GeneralSettingViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.03.2024.
//

import UIKit

class GeneralSettingViewController: UIViewController {

    struct Section: Hashable {
        var name: String?
        var items: [SwitchItem]
    }
    
    struct SwitchItem: Hashable {
        var title: String
        var state: Bool
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, SwitchItem>!
    
    private static var generalSetting: GeneralSetting = SettingManager().getGeneralSetting()
    
    let menu = [
        Section(name: "Нажатия", items: [
            .init(title: "Звук", state: generalSetting.isSound),
            .init(title: "Вибрация", state: generalSetting.isVibration)
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        collectionView = SettingCollectionView(frame: view.bounds, header: true)
        view.addSubview(collectionView)
        navigationItem.title = "Общие"
        navigationItem.makeDone(target: self, selector: #selector(done))
        createDataSource()
        reloadData()
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        var newSetting = GeneralSettingViewController.generalSetting
        switch sender.tag {
        case 0:
            newSetting.isSound = sender.isOn
        case 1:
            newSetting.isVibration = sender.isOn
        default:
            fatalError("Not switch menu.")
        }
        GeneralSettingViewController.generalSetting = newSetting
        SettingManager().setGeneralSetting(GeneralSettingViewController.generalSetting)
    }
}

extension GeneralSettingViewController: ResponderChainActionSenderType {
    @objc func done() {
        let event = DoneEvent(controller: self)
        let _ = sendNilTargetedAction(selector: .doneTap, sender: self, forEvent: event)
    }
}


// MARK: - Data source

private extension GeneralSettingViewController {
    
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
        
        // Supplementary view registration
        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader)
        { [unowned self] (headerView, elementKind, indexPath) in
            let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = headerItem.name
            headerView.contentConfiguration = configuration
        }
        
        dataSource.supplementaryViewProvider = { [unowned self] (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
            self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
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
