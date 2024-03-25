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
    let font: UIFont = UIFont.SFProSemibold(size: 17)
    
    init(title: String) {
        self.title = title
        self.image = UIImage(named: (title) + ":icons" )!
    }
}

enum Section: Int {
    case general
    case data
}


// MARK: SettingTableViewController

class SettingTableViewController: UIViewController {
    
    let modelObjects = [
        [MenuItem(title: "Общие"),
         MenuItem(title: "Дизайн")],
        [MenuItem(title: "История")]
    ]
    
    var delegate: NavigationDoneDelegate?
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MenuItem>!
    
    // MARK:  life circle
    
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
    
    @objc private func done() {
        delegate?.done(to: self)
    }
    
}


// MARK: Navigation

extension SettingTableViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let selectedItem = dataSource.itemIdentifier(for: indexPath) else { return }
        
        switch selectedItem.title {
        case modelObjects[1][0].title:
            
            let vc = HistoryDataController()
            vc.delegate = delegate
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
            viewSecond.backgroundColor = UIColor.focusColor()
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
        snapshot.appendSections([.general, .data])
        snapshot.appendItems(modelObjects[Section.general.rawValue], toSection: .general)
        snapshot.appendItems(modelObjects[Section.data.rawValue], toSection: .data)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
}


// MARK: Configuration

extension SettingTableViewController {
        
    private func configNavigationBar() {
        navigationItem.title = "Настройки"
        navigationItem.makeDone(target: self, action: #selector(done))
    }
        
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .operatingSelectedButtonColor()
        view.addSubview(collectionView)
        collectionView.delegate = self
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .grouped)
        layoutConfig.showsSeparators = false
        layoutConfig.backgroundColor = UIColor.operatingSelectedButtonColor()
        return UICollectionViewCompositionalLayout.list(using: layoutConfig)
    }
    
}
