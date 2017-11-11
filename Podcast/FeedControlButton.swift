//
//  FeedControlButton.swift
//  Podcast
//
//  Created by Mark Bryan on 4/27/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class FeedControlButton: Button {
    
    override init() {
        super.init()
        setImage(#imageLiteral(resourceName: "feed_control_icon"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
