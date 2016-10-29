//
//  PlayerControlsView.swift
//  Podcast
//
//  Created by Mark Bryan on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class PlayerControlsView: UIView, PlayerDelegate {
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        self.frame.size.height = PlayerControlsViewHeight
        
        episodeNameLabel = UILabel(frame: .zero)
        episodeNameLabel.textAlignment = .center
        episodeNameLabel.font = .boldSystemFont(ofSize: 15)
        episodeNameLabel.text = "Stephen Curry - EP10"
        addSubview(episodeNameLabel)
        
        seriesNameLabel = UILabel(frame: .zero)
        seriesNameLabel.textAlignment = .center
        seriesNameLabel.font = .systemFont(ofSize: 13)
        seriesNameLabel.text = "Warriors Plus/Minus"
        addSubview(seriesNameLabel)
        
        moreButton = UIButton(frame: .zero)
        moreButton.setImage(UIImage(named: "MoreButton"), for: .normal)
        addSubview(moreButton)
        
        slider = UISlider(frame: .zero)
        slider.thumbTintColor = .podcastGreenBlue
        slider.minimumTrackTintColor = .podcastBlueLight
        slider.maximumTrackTintColor = .podcastBlueLight
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        addSubview(slider)
        
        leftTimeLabel = UILabel(frame: .zero)
        leftTimeLabel.font = .systemFont(ofSize: 12)
        leftTimeLabel.textAlignment = .center
        leftTimeLabel.text = "-:--"
        addSubview(leftTimeLabel)
        
        rightTimeLabel = UILabel(frame: .zero)
        rightTimeLabel.font = .systemFont(ofSize: 12)
        rightTimeLabel.textAlignment = .center
        rightTimeLabel.text = "-:--"
        addSubview(rightTimeLabel)
        
        playPauseButton = UIButton(frame: .zero)
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "Play"), for: .normal)
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPress), for: .touchUpInside)
        addSubview(playPauseButton)
        
        forwardsButton = UIButton(frame: .zero)
        forwardsButton.setBackgroundImage(#imageLiteral(resourceName: "Forwards"), for: .normal)
        forwardsButton.adjustsImageWhenHighlighted = false
        forwardsButton.addTarget(self, action: #selector(forwardButtonPress), for: .touchUpInside)
        addSubview(forwardsButton)
        
        forwardsLabel = UILabel(frame: .zero)
        forwardsLabel.text = "30"
        addSubview(forwardsLabel)
        
        backwardsButton = UIButton(frame: .zero)
        backwardsButton.setBackgroundImage(#imageLiteral(resourceName: "Backwards"), for: .normal)
        backwardsButton.adjustsImageWhenHighlighted = false
        backwardsButton.addTarget(self, action: #selector(backwardButtonPress), for: .touchUpInside)
        addSubview(backwardsButton)
        
        backwardsLabel = UILabel(frame: .zero)
        backwardsLabel.text = "15"
        addSubview(backwardsLabel)
        
        Player.sharedInstance.delegate = self
        Player.sharedInstance.prepareToPlay(url: URL(string: "http://play.podtrac.com/npr-344098539/npr.mc.tritondigital.com/WAITWAIT_PODCAST/media/anon.npr-podcasts/podcast/344098539/495356606/npr_495356606.mp3?orgId=1&d=2995&p=344098539&story=495356606&t=podcast&e=495356606&ft=pod&f=344098539")!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        episodeNameLabel.sizeToFit()
        episodeNameLabel.center = CGPoint(x: frame.width/2, y: EpisodeNameLabelYValue)
        
        seriesNameLabel.sizeToFit()
        seriesNameLabel.center = CGPoint(x: frame.width/2, y: SeriesNameLabelYValue)
        
        moreButton.frame = CGRect(x: frame.width - (MoreButtonSize + MoreButtonHorizontalInset), y: MoreButtonYValue, width: MoreButtonSize, height: MoreButtonSize)
        
        slider.frame = CGRect(x: 0, y: 0, width: frame.width - (2 * SliderInset), height: SliderHeight)
        slider.center = CGPoint(x: frame.width/2, y: SliderCenterY)
        
        leftTimeLabel.sizeToFit()
        leftTimeLabel.center = CGPoint(x: TimeLabelHorizontalInset + leftTimeLabel.frame.width/2, y: SliderCenterY)
        
        rightTimeLabel.sizeToFit()
        rightTimeLabel.center = CGPoint(x: frame.width - rightTimeLabel.frame.width/2 - TimeLabelHorizontalInset, y: SliderCenterY)
        
        playPauseButton.frame = CGRect(x: 0, y: 0, width: PlayPauseButtonSize, height: PlayPauseButtonSize)
        playPauseButton.center = CGPoint(x: frame.width/2, y: ControlButtonsCenterY)
        
        forwardsButton.frame = CGRect(x: 0, y: 0, width: ForwardsBackwardsButtonSize, height: ForwardsBackwardsButtonSize)
        forwardsButton.center = CGPoint(x: playPauseButton.frame.maxX + ControlButtonsCenterHorizontalOffset, y: ControlButtonsCenterY)
        
        forwardsLabel.sizeToFit()
        forwardsLabel.center = forwardsButton.center
        
        backwardsButton.frame = CGRect(x: 0, y: 0, width: ForwardsBackwardsButtonSize, height: ForwardsBackwardsButtonSize)
        backwardsButton.center = CGPoint(x: playPauseButton.frame.minX - ControlButtonsCenterHorizontalOffset, y: ControlButtonsCenterY)
        
        backwardsLabel.sizeToFit()
        backwardsLabel.center = backwardsButton.center
    }
    
    func sliderValueChanged() {
        Player.sharedInstance.setProgress(progress: slider.value)
    }
    
    func playPauseButtonPress() {
        Player.sharedInstance.togglePlaying()
    }
    
    func forwardButtonPress() {
        Player.sharedInstance.skipForward(seconds: 30.0)
    }
    
    func backwardButtonPress() {
        Player.sharedInstance.skipBackward(seconds: 15.0)
    }
    
    // Mark: PlayerDelegate
    
    func playerDidUpdateTime() {
        slider.value = Player.sharedInstance.getProgress()
    }
    
    func playerDidChangeState() {
        if Player.sharedInstance.playerStatus == .paused {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "Pause"), for: .normal)
        } else {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "Play"), for: .normal)
        }
    }
    
}
