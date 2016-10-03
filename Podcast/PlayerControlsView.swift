//
//  PlayerControlsView.swift
//  Podcast
//
//  Created by Mark Bryan on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class PlayerControlsView: UIView {
    
    // Mark: Constants
    
    let PlayerControlsViewHeight: CGFloat = 182
    let SmallButtonSize: CGFloat = 24
    let PlayerControlButtonPadding: CGFloat = 44
    let SliderInset: CGFloat = 48
    let ControlButtonY: CGFloat = 120
    
    // Mark: Properties
     
    var episodeNameLabel: UILabel!
    var seriesNameLabel: UILabel!
    var slider: UISlider!
    var moreButton: UIButton!
    var playPauseButton: UIButton!
    var forwardsButton: UIButton!
    var forwardsLabel: UILabel!
    var backwardsButton: UIButton!
    var backwardsLabel: UILabel!
    var rightTimeLabel: UILabel!
    var leftTimeLabel: UILabel!
    
    var player: Player?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        self.frame.size.height = PlayerControlsViewHeight
        
        episodeNameLabel = UILabel(frame: CGRect.zero)
        episodeNameLabel.textAlignment = .Center
        episodeNameLabel.font = UIFont.boldSystemFontOfSize(15)
        episodeNameLabel.text = "Stephen Curry - EP10"
        addSubview(episodeNameLabel)
        
        seriesNameLabel = UILabel(frame: CGRect.zero)
        seriesNameLabel.textAlignment = .Center
        seriesNameLabel.font = UIFont.systemFontOfSize(13)
        seriesNameLabel.text = "Warriors Plus/Minus"
        addSubview(seriesNameLabel)
        
        moreButton = UIButton(frame: CGRect.zero)
        moreButton.setImage(UIImage(named: "MoreButton"), forState: .Normal)
        addSubview(moreButton)
        
        slider = UISlider(frame: CGRect.zero)
        slider.thumbTintColor = UIColor.podcastGreenBlue
        slider.minimumTrackTintColor = UIColor.podcastBlueLight
        slider.maximumTrackTintColor = UIColor.podcastBlueLight
        addSubview(slider)
        
        leftTimeLabel = UILabel(frame: CGRect.zero)
        leftTimeLabel.font = UIFont.systemFontOfSize(12)
        leftTimeLabel.textAlignment = .Center
        leftTimeLabel.text = "4:31"
        addSubview(leftTimeLabel)
        
        rightTimeLabel = UILabel(frame: CGRect.zero)
        rightTimeLabel.font = UIFont.systemFontOfSize(12)
        rightTimeLabel.textAlignment = .Center
        rightTimeLabel.text = "6:24"
        addSubview(rightTimeLabel)
        
        playPauseButton = UIButton(frame: CGRect.zero)
        playPauseButton.setBackgroundImage(UIImage(named: "Play"), forState: .Normal)
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPress), forControlEvents: .TouchUpInside)
        addSubview(playPauseButton)
        
        forwardsButton = UIButton(frame: CGRect.zero)
        forwardsButton.setBackgroundImage(UIImage(named: "Forwards"), forState: .Normal)
        forwardsButton.adjustsImageWhenHighlighted = false
        forwardsButton.addTarget(self, action: #selector(forwardButtonPress), forControlEvents: .TouchUpInside)
        addSubview(forwardsButton)
        
        forwardsLabel = UILabel(frame: CGRect.zero)
        forwardsLabel.text = "30"
        addSubview(forwardsLabel)
        
        backwardsButton = UIButton(frame: CGRect.zero)
        backwardsButton.setBackgroundImage(UIImage(named: "Backwards"), forState: .Normal)
        backwardsButton.adjustsImageWhenHighlighted = false
        backwardsButton.addTarget(self, action: #selector(backwardButtonPress), forControlEvents: .TouchUpInside)
        addSubview(backwardsButton)
        
        backwardsLabel = UILabel(frame: CGRect.zero)
        backwardsLabel.text = "15"
        addSubview(backwardsLabel)
        
        preparePlayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        episodeNameLabel.sizeToFit()
        episodeNameLabel.center = CGPointMake(self.frame.width/2, 21)
        
        seriesNameLabel.sizeToFit()
        seriesNameLabel.center = CGPointMake(self.frame.width/2, 40)
        
        moreButton.frame = CGRect(x: self.frame.width - (SmallButtonSize + 17), y: 29, width: SmallButtonSize, height: SmallButtonSize)
        
        slider.frame = CGRect(x: SliderInset, y: 75, width: self.frame.width - (2 * SliderInset), height: 6)
        
        leftTimeLabel.sizeToFit()
        leftTimeLabel.center = CGPointMake(14 + leftTimeLabel.frame.width/2, slider.center.y)
        
        rightTimeLabel.sizeToFit()
        rightTimeLabel.center = CGPointMake(self.frame.width - rightTimeLabel.frame.width/2 - 14, slider.center.y)
        
        playPauseButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        playPauseButton.center = CGPointMake(self.frame.width/2, ControlButtonY)
        
        forwardsButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        forwardsButton.center = CGPointMake(playPauseButton.frame.maxX + 55, ControlButtonY)
        
        forwardsLabel.sizeToFit()
        forwardsLabel.center = forwardsButton.center
        
        backwardsButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backwardsButton.center = CGPointMake(playPauseButton.frame.minX - 55, ControlButtonY)
        
        backwardsLabel.sizeToFit()
        backwardsLabel.center = backwardsButton.center
        
    }
    
    func preparePlayer() {
        player = Player(fileURL: NSURL(string: "http://play.podtrac.com/npr-344098539/npr.mc.tritondigital.com/WAITWAIT_PODCAST/media/anon.npr-podcasts/podcast/344098539/495356606/npr_495356606.mp3?orgId=1&d=2995&p=344098539&story=495356606&t=podcast&e=495356606&ft=pod&f=344098539")!)
    }
    
    func playPauseButtonPress() {
        player?.togglePlaying()
    }
    
    func forwardButtonPress() {
        
    }
    
    func backwardButtonPress() {
        
    }
    

}
