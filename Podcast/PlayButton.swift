//
//  PlayButton.swift
//  Podcast
//
//  Created by Kevin Greer on 3/11/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class PlayButton: Button {
    let buttonTitlePadding: CGFloat = 7
    
    override init() {
        super.init()
        setImage(#imageLiteral(resourceName: "play_feed_icon"), for: .normal)
        setImage(#imageLiteral(resourceName: "play_feed_icon_selected"), for: .selected)
        setImage(#imageLiteral(resourceName: "pdf"), for: .disabled)
        setTitle("Play", for: .normal)
        setTitle("Playing", for: .selected)
        setTitle("", for: .disabled)
        titleLabel?.font = ._12RegularFont()
        contentHorizontalAlignment = .left
        setTitleColor(.offBlack, for: .normal)
        setTitleColor(.sea, for: .selected)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonTitlePadding, bottom: 0, right: 0)
    }

    func configure(for episode: Episode) {
        if let _ = episode.audioURL {
            isEnabled = true
            isSelected = episode.isPlaying
            titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonTitlePadding, bottom: 0, right: 0)
        } else {
            titleEdgeInsets = .zero
            isEnabled = false
            isUserInteractionEnabled = false
            titleLabel?.numberOfLines = 2
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
