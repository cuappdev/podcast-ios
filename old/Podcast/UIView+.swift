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
}
