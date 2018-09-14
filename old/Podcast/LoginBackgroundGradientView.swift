//
//  LoginBackgroundGradientView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 4/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class LoginBackgroundGradientView: UIView {
    
    var gradient: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .sea
        gradient = CAGradientLayer()
        gradient.colors = [UIColor.aquamarine.cgColor,UIColor.turquoiseBlue.cgColor,UIColor.tealBlue.cgColor,UIColor.bluish.cgColor,UIColor.duskyBlue.cgColor]
        gradient.locations = [0.25,0.45,0.65,0.85] // kinda arbitrary
        gradient.startPoint = CGPoint(x: 0.60,y: 0)
        gradient.endPoint = CGPoint(x: 0.40,y: 1)
        gradient.frame = frame
        layer.insertSublayer(gradient, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
