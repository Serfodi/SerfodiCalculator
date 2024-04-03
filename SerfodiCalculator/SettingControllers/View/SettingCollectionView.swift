//
//  SettingCollectionView.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.03.2024.
//

import UIKit

class SettingCollectionView: UICollectionView {

    init(frame: CGRect, header: Bool = false) {
        // layout
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        if header {
            layoutConfig.headerMode = .supplementary
        }
        layoutConfig.backgroundColor = .clear
        let layout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        // config
        super.init(frame: frame, collectionViewLayout: layout)
        allowsSelection = false
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
