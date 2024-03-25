//
//  UINavigationItem + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.03.2024.
//

import UIKit


extension UINavigationItem {
    
    func makeDone(target: AnyObject, action: Selector) {
        rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: target, action: action)
    }
    
//    @objc func done() {
//        ()
//    }
    
}

//extension UIViewController {
//
//    @objc func done(to viewController: UIViewController) {
//        viewController.navigationController?.popToRootViewController(animated: true)
//    }
//
//    func makeDone() {
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(done))
//    }
//
////    @objc func done() {
////        ()
////    }
//
//}
