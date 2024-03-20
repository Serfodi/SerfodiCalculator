//
//  NavigationController.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 11.03.2024.
//

import UIKit

protocol NavigationDone {
    func closeHistory()
}

class NavigationController: UINavigationController {

    public var navigationDone: NavigationDone?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(doneTapped))
        
        let appearance = UINavigationBarAppearance()
        
        
        self.navigationBar.standardAppearance = appearance
        
        
        
        
    }

    @objc private func doneTapped() {
        navigationDone?.closeHistory()
    }
    
}
