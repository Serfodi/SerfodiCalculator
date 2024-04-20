//
//  SettingViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 11.03.2024.
//

import UIKit

struct MenuItem: Hashable {
    let title: String
    let image: UIImage
    let font: UIFont = MainFontAppearance.firstFont
    
    init(title: String) {
        self.title = title
        self.image = UIImage(named: (title) + ":icons" )!
    }
}

enum Section: Int {
    case general
}


// MARK: SettingTableViewController

class SettingTableViewController: UIViewController {
    
    let modelObjects = [
        [MenuItem(title: "Общие"), MenuItem(title: "История")]
    ]
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MenuItem>!
    
    // MARK:  life circle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = EnvironmentColorAppearance.mainBackgroundColor.color()
        
        configNavigationBar()
        setupCollectionView()
        createDataSource()
        reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        (navigationController as! WhiteNavigationController).isPopEnabled = false
    }
}

// MARK: ResponderChainActionSenderType
extension SettingTableViewController: ResponderChainActionSenderType {
    @objc func done() {
        let event = DoneEvent(controller: self)
        let _ = sendNilTargetedAction(selector: .doneTap, sender: self, forEvent: event)
    }
}

// MARK: Navigation

extension SettingTableViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }
        (navigationController as! WhiteNavigationController).isPopEnabled = true
        switch selectedItem.title {
        case modelObjects[0][0].title:
            let vc = GeneralSettingViewController()
            navigationController?.pushViewController(vc, animated: true)
        case modelObjects[0][1].title:
            let vc = HistoryDataController()
            navigationController?.pushViewController(vc, animated: true)
        default:
            print(selectedItem.title)
        }
    }
}
 

// MARK:  Data source

extension SettingTableViewController {
    
    private func createDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, MenuItem> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.image = item.image
            content.text = item.title
            
            let first = UIView()
            let viewSecond = UIView(frame: CGRect(x: 10, y: 5,
                                                  width: self.collectionView.bounds.width - 20,
                                                  height: 56))
            viewSecond.layer.cornerRadius = 12
            viewSecond.backgroundColor = DisplayLabelAppearance.focusColor.color()
            first.addSubview(viewSecond)
            cell.selectedBackgroundView = first
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: itemIdentifier)
        }
    }
    
    private func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MenuItem>()
        snapshot.appendSections([.general])
        snapshot.appendItems(modelObjects[Section.general.rawValue], toSection: .general)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}


// MARK: Configuration

extension SettingTableViewController {
        
    private func configNavigationBar() {
        navigationItem.title = "Настройки"
        navigationItem.makeDone(target: self, selector: #selector(done))
        navigationItem.hidesBackButton = true
    }
        
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        layoutConfig.showsSeparators = false
        layoutConfig.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: layoutConfig)
    }
}


