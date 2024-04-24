//
//  LabelCellListCell.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.03.2024.
//

import UIKit

class LabelCellListCell: UICollectionViewListCell {
    
    var text: String?
    var secondText: String?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        let bgConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration = bgConfiguration
        
        var content = self.defaultContentConfiguration()
        content.text = text
        content.prefersSideBySideTextAndSecondaryText = true
        content.secondaryText = secondText
        
        contentConfiguration = content
    }
}
