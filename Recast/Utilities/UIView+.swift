//
//  UIView+.swift
//  Recast
//
//  Created by Jaewon Sim on 9/25/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    /// Classification of the size of the UIView, used for determining the corner radius using `setCornerRadius`.
    enum ViewSize {
        case small
        case large
    }

    /// Sets the corner radius of the UIView's layer to the Recase default values, depending on the size of the view.
    func setCornerRadius(forView size: ViewSize) {
        switch size {
        case .small:
            layer.cornerRadius = 4
        case .large:
            layer.cornerRadius = 8
        }

    }
}
