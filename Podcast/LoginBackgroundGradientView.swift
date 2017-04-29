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
        
        backgroundColor = .podcastTeal
        gradient = CAGradientLayer()
        let charcolGray = UIColor.charcolGray.withAlphaComponent(0.60).cgColor
        let white = UIColor.podcastWhite.withAlphaComponent(0.40).cgColor
        gradient.colors = [white,UIColor.podcastTeal.cgColor,charcolGray]
        gradient.startPoint = CGPoint(x: 0.60,y: 0)
        gradient.endPoint = CGPoint(x: 0.40,y: 1)
        gradient.frame = frame
        layer.insertSublayer(gradient, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
