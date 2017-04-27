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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setImage(#imageLiteral(resourceName: "play_feed_icon"), for: .normal)
        setImage(#imageLiteral(resourceName: "play_feed_icon_selected"), for: .selected)
        setTitle("Play", for: .normal)
        setTitle("Playing", for: .selected)
        titleLabel?.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        contentHorizontalAlignment = .left
        setTitleColor(.podcastBlack, for: .normal)
        setTitleColor(.podcastGreenBlue, for: .selected)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonTitlePadding, bottom: 0, right: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
