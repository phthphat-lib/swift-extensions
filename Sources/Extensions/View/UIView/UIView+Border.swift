//
//  File.swift
//  
//
//  Created by Lucas Pham on 12/24/19.
//

import Foundation
import UIKit

// MARK: Border
@available(iOS 11.0, *)
public extension UIView {
    // TODOs: with Supper view
    
    
    enum UIBorderSide {
        case Top, Bottom, Left, Right
    }
    
    func addLineBorder(side: UIBorderSide, color: UIColor, width: CGFloat, xBottom: CGFloat = 0) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width + 100, height: width)
        case .Bottom:
            border.frame = CGRect(x: xBottom, y: self.frame.size.height - width, width: self.frame.size.width + 100, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
    
    func addLineBorderWith(inset: CGFloat, side: UIBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Top:
            if inset > 0 {
                border.frame = CGRect(x: inset, y: 0, width: frame.size.width + 300, height: width)
            } else {
                border.frame = CGRect(x: 0, y: 0, width: frame.size.width - inset, height: width)
            }
        case .Bottom:
            if inset > 0 {
                border.frame = CGRect(x: inset, y: self.frame.size.height - width, width: self.frame.size.width + 300, height: width)
            } else {
                border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: frame.size.width - inset, height: width)
            }
        case .Left:
            if inset > 0 {
                border.frame = CGRect(x: 0, y: inset, width: width, height: self.frame.size.height - inset)
            } else {
                border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height - inset)
            }
        case .Right:
            if inset > 0 {
                border.frame = CGRect(x: self.frame.size.width - width, y: inset, width: width, height: self.frame.size.height - inset)
            } else {
                border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height - inset)
            }
        }
        
        layer.addSublayer(border)
        layer.masksToBounds = true
    }
    
    //MARK: Declarative programing
    @discardableResult
    func withBorder(borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.clear, cornerRadius: CGFloat) -> UIView {
        self.layer.masksToBounds        = true
        self.layer.borderWidth          = borderWidth
        self.layer.borderColor          = borderColor.cgColor
        self.layer.cornerRadius         = cornerRadius
        return self
    }
}

