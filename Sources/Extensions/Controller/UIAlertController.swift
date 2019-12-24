//
//  UIAlertController+Extensions.swift
//  GoFixCustomer
//
//  Created by Edward Nguyen on 6/25/18.
//  Copyright © 2018 gofix.vinova.sg. All rights reserved.
//

import UIKit

extension UIAlertController {
    static var alertController: UIAlertController?
    
    static func alertAcontroller(forError error: Error) -> UIAlertController {
        return showError(error.localizedDescription)
    }
    
    static func showError(_ message: String) -> UIAlertController {
        
        alertController = UIAlertController(
            title: "",
            message: message,
            preferredStyle: .alert
        )
        if let _alertController = alertController {
            _alertController.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .cancel,
                    handler: nil
                )
            )
        }
        return alertController ?? UIAlertController(nibName: "", bundle: nil)
    }
    
    static func hideErrorAlert() {
        if let _alertController = alertController {
            _alertController.dismiss(animated: true, completion: nil)
        }
    }
    
    // Show alert on window
    func showErrorOnWindow() {
        let window = UIApplication.shared.delegate?.window
        DispatchQueue.main.async {
            
            let alertController = self
            window??.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
