//
//  PlayerViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import CoreMedia

class PlayerViewController: UIViewController, PlayerDelegate {
    
    // Mark: Constants
    
    let PlayerControlPanelHeight: CGFloat = 182
    
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
    
    var controlsView: UIView!
    var artworkImageView: UIImageView!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .podcastGrayLight
        tabBarController?.title = "Now Playing"
        
        artworkImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - PlayerControlPanelHeight - tabBarController!.tabBar.frame.height))
        artworkImageView.contentMode = .scaleAspectFill
        artworkImageView.image = UIImage(named: "SampleSeriesArtwork")
        view.addSubview(artworkImageView)
        
        controlsView = UIView(frame: CGRect(x: 0, y: view.frame.height - PlayerControlPanelHeight - tabBarController!.tabBar.frame.height, width: view.frame.width, height: PlayerControlPanelHeight))
        controlsView.backgroundColor = .white
        view.addSubview(controlsView)
        
        episodeNameLabel = UILabel(frame: .zero)
        episodeNameLabel.textAlignment = .center
        episodeNameLabel.font = .boldSystemFont(ofSize: 15)
        episodeNameLabel.text = "Episode Name"
        episodeNameLabel.sizeToFit()
        episodeNameLabel.center = CGPoint(x: view.frame.width/2, y: EpisodeNameLabelYValue)
        controlsView.addSubview(episodeNameLabel)
        
        seriesNameLabel = UILabel(frame: .zero)
        seriesNameLabel.textAlignment = .center
        seriesNameLabel.font = .systemFont(ofSize: 13)
        seriesNameLabel.text = "Series Name"
        seriesNameLabel.sizeToFit()
        seriesNameLabel.center = CGPoint(x: view.frame.width/2, y: SeriesNameLabelYValue)
        controlsView.addSubview(seriesNameLabel)
        
        slider = UISlider(frame: .zero)
        slider.thumbTintColor = .podcastGreenBlue
        slider.minimumTrackTintColor = .podcastBlueLight
        slider.maximumTrackTintColor = .podcastBlueLight
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(endScrubbing), for: .touchUpInside)
        slider.addTarget(self, action: #selector(endScrubbing), for: .touchUpOutside)
        slider.frame = CGRect(x: 0, y: 0, width: view.frame.width - (2 * SliderInset), height: SliderHeight)
        slider.center = CGPoint(x: view.frame.width/2, y: SliderCenterY)
        controlsView.addSubview(slider)
        
        leftTimeLabel = UILabel(frame: .zero)
        leftTimeLabel.font = .systemFont(ofSize: 12)
        leftTimeLabel.textAlignment = .center
        leftTimeLabel.text = "-:--"
        leftTimeLabel.sizeToFit()
        leftTimeLabel.center = CGPoint(x: TimeLabelHorizontalInset + leftTimeLabel.frame.width/2, y: SliderCenterY)
        controlsView.addSubview(leftTimeLabel)
        
        rightTimeLabel = UILabel(frame: .zero)
        rightTimeLabel.font = .systemFont(ofSize: 12)
        rightTimeLabel.textAlignment = .center
        rightTimeLabel.text = "-:--"
        rightTimeLabel.sizeToFit()
        rightTimeLabel.center = CGPoint(x: view.frame.width - rightTimeLabel.frame.width/2 - TimeLabelHorizontalInset, y: SliderCenterY)
        controlsView.addSubview(rightTimeLabel)
        
        playPauseButton = UIButton(frame: .zero)
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "Play"), for: .normal)
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPress), for: .touchUpInside)
        playPauseButton.frame = CGRect(x: 0, y: 0, width: PlayPauseButtonSize, height: PlayPauseButtonSize)
        playPauseButton.center = CGPoint(x: view.frame.width/2, y: ControlButtonsCenterY)
        controlsView.addSubview(playPauseButton)
        
        forwardsButton = UIButton(frame: .zero)
        forwardsButton.setBackgroundImage(#imageLiteral(resourceName: "Forwards"), for: .normal)
        forwardsButton.adjustsImageWhenHighlighted = false
        forwardsButton.addTarget(self, action: #selector(forwardButtonPress), for: .touchUpInside)
        forwardsButton.frame = CGRect(x: 0, y: 0, width: ForwardsBackwardsButtonSize, height: ForwardsBackwardsButtonSize)
        forwardsButton.center = CGPoint(x: playPauseButton.frame.maxX + ControlButtonsCenterHorizontalOffset, y: ControlButtonsCenterY)
        controlsView.addSubview(forwardsButton)
        
        forwardsLabel = UILabel(frame: .zero)
        forwardsLabel.text = "30"
        forwardsLabel.sizeToFit()
        forwardsLabel.center = forwardsButton.center
        controlsView.addSubview(forwardsLabel)
        
        backwardsButton = UIButton(frame: .zero)
        backwardsButton.setBackgroundImage(#imageLiteral(resourceName: "Backwards"), for: .normal)
        backwardsButton.adjustsImageWhenHighlighted = false
        backwardsButton.addTarget(self, action: #selector(backwardButtonPress), for: .touchUpInside)
        backwardsButton.frame = CGRect(x: 0, y: 0, width: ForwardsBackwardsButtonSize, height: ForwardsBackwardsButtonSize)
        backwardsButton.center = CGPoint(x: playPauseButton.frame.minX - ControlButtonsCenterHorizontalOffset, y: ControlButtonsCenterY)
        controlsView.addSubview(backwardsButton)
        
        backwardsLabel = UILabel(frame: .zero)
        backwardsLabel.text = "15"
        backwardsLabel.sizeToFit()
        backwardsLabel.center = backwardsButton.center
        controlsView.addSubview(backwardsLabel)
        
        Player.sharedInstance.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        playerDidUpdateTime()
        playerDidChangeState()
    }
    
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
