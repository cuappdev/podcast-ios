//
//  UIView+.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/28/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation

extension UIView {

    func addCornerRadius(height: CGFloat) {
        clipsToBounds = true
        layer.cornerRadius = height * cornerRadiusPercentage
    }

    func addDropShadow(xOffset: CGFloat, yOffset: CGFloat, opacity: Float, radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: xOffset, height: xOffset)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }

}
