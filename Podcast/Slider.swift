//
//  Slider.swift
//  Podcast
//
//  Created by Mindy Lou on 11/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class Slider: UISlider {

    let tapWidth: CGFloat = 44
    let tapHeight: CGFloat = 44
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let area = bounds.insetBy(dx: bounds.width < tapWidth ? bounds.width - tapWidth : 0, dy: bounds.height < tapHeight ? bounds.height - tapHeight : 0)
        return area.contains(point)
    }

}
