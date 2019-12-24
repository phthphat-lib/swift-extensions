//
//  UIViewController+Extensions.swift
//  Superstar Mentor
//
//  Created by Kent on 9/27/18.
//  Copyright © 2018 Vinova. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    @objc func backWithAnimation(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func backWithoutAnimation(sender: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: false)
    }
    
    static func initFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>(_ : T.Type) -> T {
            return T(nibName: String(describing: T.self), bundle: nil)
        }
        return instantiateFromNib(self)
    }
}
