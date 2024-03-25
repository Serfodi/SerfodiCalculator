//
//  GeneralSettingViewController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 22.03.2024.
//

import UIKit

class GeneralSettingViewController: UIViewController {

    enum Section: Hashable {
        case tapSetting
    }
    
    enum Items: Hashable {
        case switchItem (Bool)
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Items>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    

}
