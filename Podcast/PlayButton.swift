//
//  PlayButton.swift
//  Podcast
//
//  Created by Kevin Greer on 3/11/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class PlayButton: UIButton {
    let buttonTitlePadding: CGFloat = 7
    let buttonHitAreaIncrease: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(#imageLiteral(resourceName: "play_feed_icon"), for: .normal)
        setImage(#imageLiteral(resourceName: "play_feed_icon_selected"), for: .selected)
        setTitle("Play", for: .normal)
        setTitle("Playing", for: .selected)
        titleLabel?.font = ._12RegularFont()
        contentHorizontalAlignment = .left
        setTitleColor(.offBlack, for: .normal)
        setTitleColor(.sea, for: .selected)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonTitlePadding, bottom: 0, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let area = self.bounds.insetBy(dx: -buttonHitAreaIncrease, dy: -buttonHitAreaIncrease)
        return area.contains(point)
    }
}
