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
    
    let MoreButtonSize: CGFloat = 24
    let ForwardsBackwardsButtonSize: CGFloat = 44
    let PlayPauseButtonSize: CGFloat = 40
    let SliderHeight: CGFloat = 6
    
    let SliderInset: CGFloat = 48
    let SliderCenterY: CGFloat = 78
    let MoreButtonYValue: CGFloat = 29
    let MoreButtonHorizontalInset: CGFloat = 17
    let EpisodeNameLabelYValue: CGFloat = 21
    let SeriesNameLabelYValue: CGFloat = 40
    let TimeLabelHorizontalInset: CGFloat = 14
    let ControlButtonsCenterY: CGFloat = 120
    let ControlButtonsCenterHorizontalOffset: CGFloat = 55
    
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
        backgroundColor = .whiteColor()
        self.frame.size.height = PlayerControlsViewHeight
        
        episodeNameLabel = UILabel(frame: .zero)
        episodeNameLabel.textAlignment = .Center
        episodeNameLabel.font = .boldSystemFontOfSize(15)
        episodeNameLabel.text = "Stephen Curry - EP10"
        addSubview(episodeNameLabel)
        
        seriesNameLabel = UILabel(frame: .zero)
        seriesNameLabel.textAlignment = .Center
        seriesNameLabel.font = .systemFontOfSize(13)
        seriesNameLabel.text = "Warriors Plus/Minus"
        addSubview(seriesNameLabel)
        
        moreButton = UIButton(frame: .zero)
        moreButton.setImage(UIImage(named: "MoreButton"), forState: .Normal)
        addSubview(moreButton)
        
        slider = UISlider(frame: .zero)
        slider.thumbTintColor = .podcastGreenBlue
        slider.minimumTrackTintColor = .podcastBlueLight
        slider.maximumTrackTintColor = .podcastBlueLight
        addSubview(slider)
        
        leftTimeLabel = UILabel(frame: .zero)
        leftTimeLabel.font = .systemFontOfSize(12)
        leftTimeLabel.textAlignment = .Center
        leftTimeLabel.text = "4:31"
        addSubview(leftTimeLabel)
        
        rightTimeLabel = UILabel(frame: .zero)
        rightTimeLabel.font = .systemFontOfSize(12)
        rightTimeLabel.textAlignment = .Center
        rightTimeLabel.text = "6:24"
        addSubview(rightTimeLabel)
        
        playPauseButton = UIButton(frame: .zero)
        playPauseButton.setBackgroundImage(UIImage(named: "Play"), forState: .Normal)
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPress), forControlEvents: .TouchUpInside)
        addSubview(playPauseButton)
        
        forwardsButton = UIButton(frame: .zero)
        forwardsButton.setBackgroundImage(UIImage(named: "Forwards"), forState: .Normal)
        forwardsButton.adjustsImageWhenHighlighted = false
        forwardsButton.addTarget(self, action: #selector(forwardButtonPress), forControlEvents: .TouchUpInside)
        addSubview(forwardsButton)
        
        forwardsLabel = UILabel(frame: .zero)
        forwardsLabel.text = "30"
        addSubview(forwardsLabel)
        
        backwardsButton = UIButton(frame: .zero)
        backwardsButton.setBackgroundImage(UIImage(named: "Backwards"), forState: .Normal)
        backwardsButton.adjustsImageWhenHighlighted = false
        backwardsButton.addTarget(self, action: #selector(backwardButtonPress), forControlEvents: .TouchUpInside)
        addSubview(backwardsButton)
        
        backwardsLabel = UILabel(frame: .zero)
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
        episodeNameLabel.center = CGPointMake(frame.width/2, EpisodeNameLabelYValue)
        
        seriesNameLabel.sizeToFit()
        seriesNameLabel.center = CGPointMake(frame.width/2, SeriesNameLabelYValue)
        
        moreButton.frame = CGRect(x: frame.width - (MoreButtonSize + MoreButtonHorizontalInset), y: MoreButtonYValue, width: MoreButtonSize, height: MoreButtonSize)
        
        slider.frame = CGRect(x: 0, y: 0, width: frame.width - (2 * SliderInset), height: SliderHeight)
        slider.center = CGPointMake(frame.width/2, SliderCenterY)
        
        leftTimeLabel.sizeToFit()
        leftTimeLabel.center = CGPointMake(TimeLabelHorizontalInset + leftTimeLabel.frame.width/2, SliderCenterY)
        
        rightTimeLabel.sizeToFit()
        rightTimeLabel.center = CGPointMake(self.frame.width - rightTimeLabel.frame.width/2 - TimeLabelHorizontalInset, SliderCenterY)
        
        playPauseButton.frame = CGRect(x: 0, y: 0, width: PlayPauseButtonSize, height: PlayPauseButtonSize)
        playPauseButton.center = CGPointMake(frame.width/2, ControlButtonsCenterY)
        
        forwardsButton.frame = CGRect(x: 0, y: 0, width: ForwardsBackwardsButtonSize, height: ForwardsBackwardsButtonSize)
        forwardsButton.center = CGPointMake(playPauseButton.frame.maxX + ControlButtonsCenterHorizontalOffset, ControlButtonsCenterY)
        
        forwardsLabel.sizeToFit()
        forwardsLabel.center = forwardsButton.center
        
        backwardsButton.frame = CGRect(x: 0, y: 0, width: ForwardsBackwardsButtonSize, height: ForwardsBackwardsButtonSize)
        backwardsButton.center = CGPointMake(playPauseButton.frame.minX - ControlButtonsCenterHorizontalOffset, ControlButtonsCenterY)
        
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
