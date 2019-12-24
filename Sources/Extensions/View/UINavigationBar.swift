//
//  UINavigationBar+Extensions.swift
//  GoFixCustomer
//
//  Created by vinova on 7/10/18.
//  Copyright © 2018 gofix.vinova.sg. All rights reserved.
//

import UIKit

extension UINavigationBar {
    func findLineUnderNavigationBar(under view: UIView) -> UIImageView? {
        if view is UIImageView && view.bounds.size.height <= 1 {
            return (view as! UIImageView)
        }
        
        for subview in view.subviews {
            if let imageView = findLineUnderNavigationBar(under: subview) {
                return imageView
            }
        }
        
        return nil
    }
    
    func setTitleColor(font: UIFont, color: UIColor){
        titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : color,
            NSAttributedString.Key.font: font
        ]
    }
}

extension UINavigationController:UINavigationControllerDelegate {

    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: self.interactivePopGestureRecognizer)) {
            if viewControllers.count > 1 {
                interactivePopGestureRecognizer?.isEnabled = true
            } else {
                interactivePopGestureRecognizer?.isEnabled = false
            }
        }
    }
}
