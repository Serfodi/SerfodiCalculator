//
//  ButtonCellListCell.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 14.03.2024.
//

import Foundation
import UIKit

class ButtonCellListCell: UICollectionViewListCell {
    
    var text: String?
    var action: UIAction?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        let newBgConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration = newBgConfiguration
        
        var newConfiguration = ButtonCellContentConfiguration().updated(for: state)
        newConfiguration.action = action
        newConfiguration.buttonText = text
        
        contentConfiguration = newConfiguration
    }
    
}
