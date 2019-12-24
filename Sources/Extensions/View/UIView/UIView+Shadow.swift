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
    
    func setShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = CGSize(width: x, height: y)
        layer.shadowRadius = blur
        layer.masksToBounds = false
    }
}
