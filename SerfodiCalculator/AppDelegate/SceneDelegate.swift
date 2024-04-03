//
//  SceneDelegate.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 21.01.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
        let setting = SettingManager().getDesignSetting()
        
        if setting.isDarkStyle {
            window?.overrideUserInterfaceStyle = .dark
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

}

