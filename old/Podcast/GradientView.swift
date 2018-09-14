//
//  GradientView.swift
//  Podcast
//
//  Created by Mindy Lou on 10/21/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class GradientView: UIView {

    let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        gradientLayer.frame = frame
        gradientLayer.colors = [UIColor.gradientWhite.withAlphaComponent(0.85).cgColor, UIColor.gradientWhite.cgColor]
        gradientLayer.locations = [0.0, 0.5]
        layer.addSublayer(gradientLayer)
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        gradientLayer.frame = bounds
        CATransaction.commit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

