//
//  UIViewExt.swift
//  CustomizedActionSheet
//
//  Created by Sky on 16/09/2021.
//

import UIKit

extension UIView {
    func setBorder(color: UIColor?, width: CGFloat, radius: CGFloat) {
        layer.borderColor = color?.cgColor
        layer.borderWidth = width
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
