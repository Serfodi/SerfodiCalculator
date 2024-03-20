//
//  HistoryDataController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 12.03.2024.
//

import UIKit

enum HistorySection: String, Hashable {
    case data = "Память"
    case settingData = ""
//    case iCloud
}

enum HistorySectionItem: Hashable {
//    case header
    case dataTitle (Int)
    case clearButton
    case isSaveSwitch (Bool)
}


// MARK: HistoryDataController

class HistoryDataController: UIViewController {
    
    var delegate: CloseHistory?
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<HistorySection, HistorySectionItem>!
    
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
    
}


// MARK: - Data source

extension HistoryDataController {
    
    private func createDataSource() {
        
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HistorySectionItem> {
            (cell, indexPath, headerItem) in
            // Set headerItem's data to cell
//            var content = cell.defaultContentConfiguration()
//            content.text = headerItem.rawValue
//            cell.contentConfiguration = content
        }
        
        let dataTitleCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, HistorySectionItem> { (cell, indexPath, item) in
            guard case .dataTitle(let data) = item else { fatalError() }
            var content = cell.defaultContentConfiguration()
            content.text = "Использование памяти"
            content.secondaryAttributedText = NSAttributedString(string: "\(data) Мб", attributes: [NSAttributedString.Key.font : UIFont.numpad(size: 20)])
            content.prefersSideBySideTextAndSecondaryText = true
            cell.contentConfiguration = content
        }
        
        let cellRegistration = UICollectionView.CellRegistration<ButtonCellListCell, HistorySectionItem> { (cell, indexPath, item) in
            cell.text = "Очистить историю"
            cell.action = UIAction { action in
                self.buttonTap()
            }
        }
        
        let cellSwitch = UICollectionView.CellRegistration<UICollectionViewListCell, HistorySectionItem> { (cell, indexPath, item) in
            guard case .isSaveSwitch(let isState) = item else { fatalError() }
            
            var content = cell.defaultContentConfiguration()
            
            content.text = "Сохронять историю"
            
            let switchView = UISwitch()
            switchView.setOn(isState, animated: false)
            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            
            cell.accessories = [.customView(configuration: UICellAccessory.CustomViewConfiguration(customView: switchView, placement: .trailing()))]
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .dataTitle:
                return collectionView.dequeueConfiguredReusableCell(using: dataTitleCellRegistration, for: indexPath, item: itemIdentifier)
            case .clearButton:
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
                cell.isUserInteractionEnabled = true
                return cell
            case .isSaveSwitch:
                let cell = collectionView.dequeueConfiguredReusableCell(using: cellSwitch, for: indexPath, item: itemIdentifier)
                cell.isUserInteractionEnabled = true
                return cell
//            case .header:
//                return collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration, for: indexPath, item: itemIdentifier)
            }
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<HistorySection, HistorySectionItem>()
        snapshot.appendSections([.data, .settingData])
//        snapshot.appendItems([HistorySectionItem.dataTitle((self.dataProvider.historyManager?.storage.getSizeOfUserDefaults()!)!), HistorySectionItem.clearButton], toSection: .data)
        snapshot.appendItems([HistorySectionItem.isSaveSwitch(true)], toSection: .settingData)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


// MARK: Action

private extension HistoryDataController {
    
    func buttonTap() {
//        self.dataProvider.historyManager?.removeAllDataHistory()
        self.reloadData()
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
//        settingManager.setIsSaveHistoryData(isState: sender.isOn)
    }
    
}



// MARK: Configuration

extension HistoryDataController {
        
    private func configNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneTapped))
        navigationItem.title = "История"
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .operatingSelectedButtonColor()
        collectionView.allowsSelection = false
        view.addSubview(collectionView)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: layoutConfig)
    }
    
}

// MARK: Done Tapped

extension HistoryDataController {
    
    @objc private func doneTapped() {
//        settingManager.save()
        navigationController?.popToRootViewController(animated: true)
        delegate?.closeHistory()
    }
    
}
