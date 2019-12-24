//
//  File.swift
//  
//
//  Created by Lucas Pham on 12/18/19.
//

import Foundation
import UIKit

extension UIImageView {
    convenience public init(image: UIImage?, contentMode: UIView.ContentMode = .scaleAspectFill) {
        self.init(image: image)
        self.contentMode = contentMode
        self.clipsToBounds = true
    }
    
    func setRoundedWithBorder(borderColor : UIColor = UIColor.lightGray, borderWidth : CGFloat = 1) {
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = false
        self.layer.borderColor = borderColor.cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
}
