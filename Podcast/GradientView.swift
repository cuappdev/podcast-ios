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
        layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradientLayer.frame = frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

