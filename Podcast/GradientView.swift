//
//  GradientView.swift
//  Podcast
//
//  Created by Mindy Lou on 10/21/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.frame
        gradientLayer.colors = [UIColor.gradientWhite.withAlphaComponent(0.9).cgColor, UIColor.gradientWhite.cgColor]
        self.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

