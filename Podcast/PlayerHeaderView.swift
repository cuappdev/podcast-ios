//
//  PlayerHeaderView.swift
//  Podcast
//
//  Created by Mark Bryan on 2/21/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class PlayerHeaderView: UIView {
    
    var upNextLabel: UILabel!
    var nextEpisodeLabel: UILabel!
    var playingFromLabel: UILabel!
    
    let TopInset: CGFloat = 24
    let Spacing: CGFloat = 1.5
    let UpNextSpacing: CGFloat = 3

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.colorFromCode(0xf0f1f4)
        self.frame.size.height = 87
        
        upNextLabel = UILabel(frame: .zero)
        upNextLabel.font = UIFont.boldSystemFont(ofSize: 14)
        addSubview(upNextLabel)
        
        nextEpisodeLabel = UILabel(frame: .zero)
        nextEpisodeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        nextEpisodeLabel.textColor = UIColor.colorFromCode(0xa8a8b4)
        addSubview(nextEpisodeLabel)
        
        playingFromLabel = UILabel(frame: .zero)
        playingFromLabel.textAlignment = .center
        playingFromLabel.textColor = UIColor.colorFromCode(0xa8a8b4)
        playingFromLabel.font = UIFont.systemFont(ofSize: 12)
        addSubview(playingFromLabel)
        
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        upNextLabel.text = "Up Next"
        upNextLabel.sizeToFit()
        
        nextEpisodeLabel.text = "E191: Surviving Refugee"
        nextEpisodeLabel.sizeToFit()
        
        let totalWidth = upNextLabel.frame.size.width + UpNextSpacing + nextEpisodeLabel.frame.size.width
        upNextLabel.frame.origin = CGPoint(x: (frame.size.width - totalWidth) / 2, y: TopInset)
        nextEpisodeLabel.frame.origin = CGPoint(x: upNextLabel.frame.maxX + UpNextSpacing, y: TopInset)
        
        playingFromLabel.text = "Playing from Bookmarks"
        playingFromLabel.sizeToFit()
        playingFromLabel.center.x = frame.size.width / 2
        playingFromLabel.frame.origin.y = 44.5
    }

}
