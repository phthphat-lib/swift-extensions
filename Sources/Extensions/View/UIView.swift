//
//  UIView+Extensions.swift
//  GoFixCustomer
//
//  Created by Edward Nguyen on 6/11/18.
//  Copyright © 2018 gofix.vinova.sg. All rights reserved.
//

import UIKit

public struct AnchoredConstraints {
    public var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
}

@available(iOS 11.0, *)
public enum Anchor {
    case top(_ top: NSLayoutYAxisAnchor, constant: CGFloat = 0)
    case leading(_ leading: NSLayoutXAxisAnchor, constant: CGFloat = 0)
    case bottom(_ bottom: NSLayoutYAxisAnchor, constant: CGFloat = 0)
    case trailing(_ trailing: NSLayoutXAxisAnchor, constant: CGFloat = 0)
    case height(_ constant: CGFloat)
    case width(_ constant: CGFloat)
}

// Reference Video: https://youtu.be/iqpAP7s3b-8
// Thanks to Brian Voong
@available(iOS 11.0, *)
extension UIView {
    
    @discardableResult
    open func anchor(_ anchors: Anchor...) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        anchors.forEach { anchor in
            switch anchor {
            case .top(let anchor, let constant):
                anchoredConstraints.top = topAnchor.constraint(equalTo: anchor, constant: constant)
            case .leading(let anchor, let constant):
                anchoredConstraints.leading = leadingAnchor.constraint(equalTo: anchor, constant: constant)
            case .bottom(let anchor, let constant):
                anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: anchor, constant: -constant)
            case .trailing(let anchor, let constant):
                anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: anchor, constant: -constant)
            case .height(let constant):
                if constant > 0 {
                    anchoredConstraints.height = heightAnchor.constraint(equalToConstant: constant)
                }
            case .width(let constant):
                if constant > 0 {
                    anchoredConstraints.width = widthAnchor.constraint(equalToConstant: constant)
                }
            }
        }
        [anchoredConstraints.top,
         anchoredConstraints.leading,
         anchoredConstraints.bottom,
         anchoredConstraints.trailing,
         anchoredConstraints.width,
         anchoredConstraints.height].forEach {
            $0?.isActive = true
        }
        return anchoredConstraints
    }
    
    @discardableResult
    open func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    @discardableResult
    open func fillSuperview(padding: UIEdgeInsets = .zero) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        let anchoredConstraints = AnchoredConstraints()
        guard let superviewTopAnchor = superview?.topAnchor,
            let superviewBottomAnchor = superview?.bottomAnchor,
            let superviewLeadingAnchor = superview?.leadingAnchor,
            let superviewTrailingAnchor = superview?.trailingAnchor else {
                return anchoredConstraints
        }
        
        return anchor(top: superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, padding: padding)
    }
    
    @discardableResult
    open func fillSuperviewSafeAreaLayoutGuide(padding: UIEdgeInsets = .zero) -> AnchoredConstraints {
        let anchoredConstraints = AnchoredConstraints()
        guard let superviewTopAnchor = superview?.safeAreaLayoutGuide.topAnchor,
            let superviewBottomAnchor = superview?.safeAreaLayoutGuide.bottomAnchor,
            let superviewLeadingAnchor = superview?.safeAreaLayoutGuide.leadingAnchor,
            let superviewTrailingAnchor = superview?.safeAreaLayoutGuide.trailingAnchor else {
                return anchoredConstraints
        }
        return anchor(top: superviewTopAnchor, leading: superviewLeadingAnchor, bottom: superviewBottomAnchor, trailing: superviewTrailingAnchor, padding: padding)
    }
    
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
    
    @discardableResult
    open func constrainHeight(_ constant: CGFloat) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        anchoredConstraints.height = heightAnchor.constraint(equalToConstant: constant)
        anchoredConstraints.height?.isActive = true
        return anchoredConstraints
    }
    
    @discardableResult
    open func constrainWidth(_ constant: CGFloat) -> AnchoredConstraints {
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        anchoredConstraints.width = widthAnchor.constraint(equalToConstant: constant)
        anchoredConstraints.width?.isActive = true
        return anchoredConstraints
    }
    
    open func setupShadow(opacity: Float = 0, radius: CGFloat = 0, offset: CGSize = .zero, color: UIColor = .black) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
    }
    
    convenience public init(backgroundColor: UIColor = .clear) {
        self.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }
    
}





public extension UIView {
    func endOfView() -> CGFloat {
        return (self.frame.origin.y+self.frame.size.height)
    }
    
    func setBorder(borderWidth: CGFloat = 0, borderColor: UIColor = UIColor.clear, cornerRadius: CGFloat) {
        self.layer.masksToBounds        = true
        self.layer.borderWidth          = borderWidth
        self.layer.borderColor          = borderColor.cgColor
        self.layer.cornerRadius         = cornerRadius
    }
    
    /// SwifterSwift: Add shadow to view.
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5).
    func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
}

// MARK: Auto Layout
@available(iOS 11.0, *)
public extension UIView {
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    // TODOs: with Supper view
    
    func fillHorizontalSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.leftAnchor, constant: constant).isActive = true
            rightAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.rightAnchor, constant: -constant).isActive = true
        }
    }
    
    func fillVerticalSuperview(constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            topAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
            bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
            
        }
    }
    
    func centerSuperview() {
        centerXToSuperview()
        centerYToSuperview()
    }
    
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
    
    func roundedTopLeft(){
        let maskPath1 = UIBezierPath(roundedRect: bounds,
                                     byRoundingCorners: [.topLeft],
                                     cornerRadii: CGSize(width: 15, height: 15))
        
        maskPath1.lineWidth = 1.0
        maskPath1.stroke(with: CGBlendMode.color, alpha: 1.0)
        
        let maskLayer1 = CAShapeLayer()
        maskLayer1.frame = CGRect(x: 0, y: 0, width: bounds.size.width, height: bounds.size.height+10)
        maskLayer1.path = maskPath1.cgPath
        
        layer.mask = maskLayer1
    }
    
    // TODOs: With other view
    func fillToView(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        
        leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 0).isActive = true
        rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: 0).isActive = true
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    
    }
    
    func centerXToView(view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: constant).isActive = true
    }
    
    func centerYToView(view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: constant).isActive = true
    }
    
    func centerToView(view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXToView(view: view)
        centerYToView(view: view)
    }
    
    func fillHorizontalToView(view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: constant).isActive = true
        rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -constant).isActive = true
        
    }
    
    func fillVerticalToView(view: UIView, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: constant).isActive = true
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -constant).isActive = true
        
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

//public extension UIView {
//    @IBInspectable var cornerRadius: CGFloat {
//        get {
//            return layer.cornerRadius
//        }
//        set {
//            layer.cornerRadius = newValue
//            layer.masksToBounds = newValue > 0
//        }
//    }
//
//    class var identifier: String {
//        return "\(self)"
//    }
//
//    // Warn: working only on Main Bundle
//    static func loadFromNib<T: UIView>(viewClass: T.Type) -> T {
//        let id = viewClass.identifier
//        return Bundle.main.loadNibNamed(id, owner: nil, options: nil)!.first as! T
//    }
//}

@available(iOS 11.0, *)
extension UIView {
    @discardableResult
    open func withBackgroundColor(_ color: UIColor) -> UIView {
        self.backgroundColor = color
        return self
    }
    @discardableResult
    open func withCornerRadius(_ radius: CGFloat) -> UIView {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
        return self
    }
}

public extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

@available(iOS 11.0, *)
public extension UIView {
    func roundCorners(rectCorner: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func setCornerBorderView(cornerMask: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], rectCorner: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight], cornerRadius: CGFloat = 5, borderColor: UIColor, borderWidth: CGFloat = 1) {
        
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
        self.layer.maskedCorners = cornerMask
    }
    
    func setBorderView(borderColor: UIColor, borderWidth: CGFloat = 1) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.masksToBounds = true
        self.layer.borderWidth = borderWidth
    }
    
    func setCornerView(cornerMask: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner], rectCorner: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight] , cornerRadius: CGFloat = 5) {
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.maskedCorners = cornerMask
    }
    func addBottomBorder(color: UIColor = UIColor.black, leftMargins: CGFloat = 0, rightMargins: CGFloat = 0, borderLineSize: CGFloat = 1) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .height,
                                                multiplier: 1, constant: borderLineSize))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1, constant: leftMargins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1, constant: rightMargins))
    }
    
    func addTopBorder(color: UIColor = UIColor.black, leftMargins: CGFloat = 0, rightMargins: CGFloat = 0, borderLineSize: CGFloat = 1) {
        let border = UIView()
        border.backgroundColor = color
        border.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(border)
        border.addConstraint(NSLayoutConstraint(item: border,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .height,
                                                multiplier: 1, constant: borderLineSize))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .top,
                                              multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .leading,
                                              multiplier: 1, constant: leftMargins))
        self.addConstraint(NSLayoutConstraint(item: border,
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .trailing,
                                              multiplier: 1, constant: rightMargins))
    }
}

