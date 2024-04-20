//
//  UINavigationItem + Extension.swift
//  SerfodiCalculator
//
//  Created by Сергей Насыбуллин on 23.03.2024.
//

import UIKit


class DoneEvent: UIEvent {
    let controller: UIViewController
    init(controller: UIViewController) {
        self.controller = controller
    }
}

@objc protocol NavigationDoneActionHandler {
    func done(_ sender: AnyObject, forEvent event: DoneEvent)
}

extension Selector {
    static var doneTap = #selector(NavigationDoneActionHandler.done(_:forEvent:))
}

extension UINavigationItem {
    
    func makeDone(target: AnyObject, selector: Selector) {
        rightBarButtonItem = UIBarButtonItem(title: "Готово", style: .done, target: target, action: selector)
    }
}
