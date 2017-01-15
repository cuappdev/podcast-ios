//
//  PlayerControlsView.swift
//  Podcast
//
//  Created by Mark Bryan on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import CoreMedia

class PlayerControlsView: UIView, PlayerDelegate {
    
    // Mark: Constants
    
    let PlayerControlsViewHeight: CGFloat = 182
    
    let ForwardsBackwardsButtonSize: CGFloat = 44
    let PlayPauseButtonSize: CGFloat = 40
    let SliderHeight: CGFloat = 6
    let SliderInset: CGFloat = 48
    let SliderCenterY: CGFloat = 78
    let EpisodeNameLabelYValue: CGFloat = 21
    let SeriesNameLabelYValue: CGFloat = 40
    let TimeLabelHorizontalInset: CGFloat = 14
    let ControlButtonsCenterY: CGFloat = 120
    let ControlButtonsCenterHorizontalOffset: CGFloat = 55
    
    // Mark: Properties
     
    var episodeNameLabel: UILabel!
    var seriesNameLabel: UILabel!
    var slider: UISlider!
    var playPauseButton: UIButton!
    var forwardsButton: UIButton!
    var forwardsLabel: UILabel!
    var backwardsButton: UIButton!
    var backwardsLabel: UILabel!
    var rightTimeLabel: UILabel!
    var leftTimeLabel: UILabel!
    var isScrubbing = false
    
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
        
        slider = UISlider(frame: .zero)
        slider.thumbTintColor = .podcastGreenBlue
        slider.minimumTrackTintColor = .podcastBlueLight
        slider.maximumTrackTintColor = .podcastBlueLight
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(endScrubbing), for: .touchUpInside)
        slider.addTarget(self, action: #selector(endScrubbing), for: .touchUpOutside)
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
    
    /// Ends scrubbing and updates the progress of the player to whatever slider value was scrubbed to
    func endScrubbing() {
        Player.sharedInstance.setProgress(progress: slider.value)
        isScrubbing = false
    }
    
    func sliderValueChanged() {
        isScrubbing = true
        
        // update time labels to be the slider value
        guard let duration = Player.sharedInstance.getDuration() else { return }
        
        let newSeconds = duration.seconds * Double(slider.value)
        let newTimePassed = CMTime(seconds: newSeconds, preferredTimescale: Int32(NSEC_PER_SEC))
        let newTimeLeft = CMTimeSubtract(duration, newTimePassed)
        
        leftTimeLabel.text = newTimePassed.durationText
        leftTimeLabel.sizeToFit()
        rightTimeLabel.text = newTimeLeft.durationText
        rightTimeLabel.sizeToFit()
    }
    
    func playPauseButtonPress() {
        Player.sharedInstance.togglePlaying()
    }
    
    func forwardButtonPress() {
        Player.sharedInstance.skip(seconds: 30.0)
    }
    
    func backwardButtonPress() {
        Player.sharedInstance.skip(seconds: -15.0)
    }
    
    // Mark: PlayerDelegate
    
    func playerDidUpdateTime() {
        // don't update slider value and time labels if currently scrubbing
        if isScrubbing { return }
        
        slider.value = Player.sharedInstance.getProgress()
        
        if let timePassed = Player.sharedInstance.getTimePassed() {
            leftTimeLabel.text = timePassed.durationText
        } else {
            leftTimeLabel.text = "-:--"
        }
        
        if let timeLeft = Player.sharedInstance.getTimeLeft() {
            rightTimeLabel.text = timeLeft.durationText
        } else {
            rightTimeLabel.text = "-:--"
        }
        
        leftTimeLabel.sizeToFit()
        rightTimeLabel.sizeToFit()
    }
    
    func playerDidChangeState() {
        if Player.sharedInstance.shouldDisplayPlayButton() {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "Play"), for: .normal)
        } else {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "Pause"), for: .normal)
        }
    }
    
}
