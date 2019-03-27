//
//  UIViewExtension.swift
//  ElectricalCalculator
//
//  Created by Duy Tran N. on 3/1/19.
//  Copyright © 2019 MBA0204. All rights reserved.
//

import UIKit

extension UIView {
    func shadow(color: UIColor = .black, opacity: Float = 0.5, offset: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        var scalingBounds = bounds
        scalingBounds.size.width = bounds.width.scaling
        layer.shadowPath = UIBezierPath(rect: scalingBounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
