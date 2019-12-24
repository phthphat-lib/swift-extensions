//
//  CALayer+Extension.swift
//  Superstar Mentor
//
//  Created by Kent on 7/23/19.
//  Copyright © 2019 Vinova. All rights reserved.
//

import UIKit

public extension CALayer {
    func addShadow(color: UIColor, alpha: Float, x: CGFloat, y: CGFloat, blur: CGFloat) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur
        masksToBounds = false
    }
    
    func addShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = opacity
        shadowOffset = offSet
        shadowRadius = radius
    }
}
