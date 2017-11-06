//
//  FeedControlButton.swift
//  Podcast
//
//  Created by Mark Bryan on 4/27/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class FeedControlButton: UIButton {
    let buttonHitAreaIncrease: CGFloat = 15
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(#imageLiteral(resourceName: "feed_control_icon"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let area = self.bounds.insetBy(dx: -buttonHitAreaIncrease, dy: -buttonHitAreaIncrease)
        return area.contains(point)
    }

}
