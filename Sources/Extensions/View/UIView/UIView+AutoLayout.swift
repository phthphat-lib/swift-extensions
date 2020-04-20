//
//  UIView+Extensions.swift
//  GoFixCustomer
//
//  Created by Edward Nguyen on 6/11/18.
//  Copyright © 2018 gofix.vinova.sg. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
extension UIView {
    open func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    open func centerXTo(_ anchor: NSLayoutXAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    open func centerYTo(_ anchor: NSLayoutYAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: anchor).isActive = true
    }
    
    open func centerXToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
    }
    
    open func centerYToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
    }
    
    open func centerSuperview() {
        centerXToSuperview()
        centerYToSuperview()
    }
    
    open func fillHorizontalSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: constant).isActive = true
            rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor, constant: -constant).isActive = true
        }
    }
    
    open func fillVerticalSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
            
        }
    }
    
    convenience public init(backgroundColor: UIColor = .clear) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
}
