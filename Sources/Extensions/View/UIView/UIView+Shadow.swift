//
//  File.swift
//  
//
//  Created by Lucas Pham on 12/24/19.
//

import Foundation
import UIKit

// MARK: Shadow
public extension UIView {
    func endOfView() -> CGFloat {
        return (self.frame.origin.y+self.frame.size.height)
    }
    
    func addShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur
        layer.masksToBounds = false
    }
}
