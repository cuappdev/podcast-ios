//
//  UIStackView+.swift
//  Podcast
//
//  Created by Mindy Lou on 2/4/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

extension UIStackView {

    convenience init(axis: UILayoutConstraintAxis, spacing: CGFloat) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    func anchorStackView(to view: UIView, anchorX: NSLayoutXAxisAnchor, equalAnchorX: NSLayoutXAxisAnchor, anchorY: NSLayoutYAxisAnchor, equalAnchorY: NSLayoutYAxisAnchor) {
        view.addSubview(self)
        anchorX.constraint(equalTo: equalAnchorX).isActive = true
        anchorY.constraint(equalTo: equalAnchorY).isActive = true
    }
}
