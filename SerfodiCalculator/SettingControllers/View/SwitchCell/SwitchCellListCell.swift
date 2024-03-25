//
//  SwitchCellListCell.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.03.2024.
//

import UIKit


class SwitchCellListCell: UICollectionViewListCell {
    
    var text: String?
    let aSwitch = UISwitch()
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        let newBgConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration = newBgConfiguration
        
        var newConfiguration = self.defaultContentConfiguration()
        
        newConfiguration.text = text
        
        self.accessories = [.customView(configuration: UICellAccessory.CustomViewConfiguration(customView: aSwitch, placement: .trailing()))]
        
        contentConfiguration = newConfiguration
    }
    
}
