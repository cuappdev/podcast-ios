//
//  MiniPlayerView.swift
//  Podcast
//
//  Created by Mark Bryan on 2/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class MiniPlayerView: UIView {
    
    let MiniPlayerHeight: CGFloat = 58
    let MarginSpacing: CGFloat = 24
    let ButtonDimension: CGFloat = 24
    let ArrowYValue: CGFloat = 25
    let ArrowWidth: CGFloat = 16
    let ArrowHeight: CGFloat = 8
    let LabelYVal: CGFloat = 12
    let LabelHeight: CGFloat = 34
    
    var arrowButton: UIButton!
    var playPauseButton: UIButton!
    var episodeTitleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = MiniPlayerHeight
        backgroundColor = UIColor.colorFromCode(0xf0f1f4)
        
        arrowButton = UIButton(frame: CGRect(x: MarginSpacing, y: ArrowYValue, width: ArrowWidth, height: ArrowHeight))
        arrowButton.addTarget(self, action: #selector(arrowButtonTapped), for: .touchUpInside)
        arrowButton.setBackgroundImage(#imageLiteral(resourceName: "down_arrow"), for: .normal)
        addSubview(arrowButton)
        
        playPauseButton = UIButton(frame: CGRect(x: frame.size.width - MarginSpacing - ButtonDimension, y: 17, width: ButtonDimension, height: ButtonDimension))
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        addSubview(playPauseButton)
        
        episodeTitleLabel = UILabel(frame: CGRect(x: arrowButton.frame.maxX + MarginSpacing, y: LabelYVal, width: playPauseButton.frame.minX - 2 * MarginSpacing - arrowButton.frame.maxX, height: 34))
        episodeTitleLabel.numberOfLines = 2
        episodeTitleLabel.textAlignment = .left
        episodeTitleLabel.lineBreakMode = .byWordWrapping
        addSubview(episodeTitleLabel)
    }
    
    func updateUI() {
        // TODO: animate arrow button up or down
        
        // TODO: update play/pause button based on Player state
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "mini_play_icon"), for: .normal)
        
        // TODO: update label based on Player state
        episodeTitleLabel.text = "E194: Election Freakout Purchases and other Prepper Questions"
    }
    
    func arrowButtonTapped() {
        // TODO: present large player view here...
    }
    
    func playPauseButtonTapped() {
        Player.sharedInstance.togglePlaying()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
