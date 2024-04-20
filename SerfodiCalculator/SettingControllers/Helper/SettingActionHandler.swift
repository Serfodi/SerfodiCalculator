//
//  SettingActionHandler.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 18.04.2024.
//

import UIKit

@objc protocol SettingActionHandler {
    func eraseData(_ sender: AnyObject, forEvent event: UIEvent)
}

extension Selector {
    static var eraseDataTap = #selector(SettingActionHandler.eraseData(_:forEvent:))
}
