//
//  MainView.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 02.04.2024.
//

import UIKit

class MainView: UIView {

    let blurBG = BlurView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = EnvironmentColorAppearance.mainBackgroundColor.color()
        configurationBG()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = EnvironmentColorAppearance.mainBackgroundColor.color()
        configurationBG()
    }
    
    func configurationBG() {
        addSubview(blurBG)
        pinToBounds(blurBG)
        blurBG.isHidden = true
        blurBG.alpha = 0
    }
}
