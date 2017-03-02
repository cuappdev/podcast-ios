//
//  PlayerControlsView.swift
//  Podcast
//
//  Created by Mark Bryan on 2/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol PlayerControlsDelegate: class {
    func playerControlsDidTapPlayPauseButton()
    func playerControlsDidTapSkipForward()
    func playerControlsDidTapSkipBackward()
    func playerControlsDidScrub()
    func playerControlsDidEndScrub()
}

class PlayerControlsView: UIView {
    
    let forwardsBackwardsButtonSize: CGFloat = 44
    let playPauseButtonSize: CGFloat = 40
    let sliderHeight: CGFloat = 6
    let sliderInset: CGFloat = 48
    let sliderCenterY: CGFloat = 25
    let timeLabelHorizontalInset: CGFloat = 12
    let controlButtonsCenterY: CGFloat = 71.5
    let controlButtonsCenterHorizontalOffset: CGFloat = 55
    
    let playerControlsViewHeight: CGFloat = 116
    
    var slider: UISlider!
    var playPauseButton: UIButton!
    var forwardsButton: UIButton!
    var forwardsLabel: UILabel!
    var backwardsButton: UIButton!
    var backwardsLabel: UILabel!
    var rightTimeLabel: UILabel!
    var leftTimeLabel: UILabel!
    
    weak var delegate: PlayerControlsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = playerControlsViewHeight
        backgroundColor = .white
        
        slider = UISlider(frame: .zero)
        slider.frame.size = CGSize(width: frame.width - (2 * sliderInset), height: sliderHeight)
        slider.center = CGPoint(x: frame.width/2, y: sliderCenterY)
        addSubview(slider)
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(endScrubbing), for: .touchUpInside)
        slider.addTarget(self, action: #selector(endScrubbing), for: .touchUpOutside)
        
        leftTimeLabel = UILabel(frame: .zero)
        leftTimeLabel.font = .systemFont(ofSize: 12)
        leftTimeLabel.textAlignment = .center
        addSubview(leftTimeLabel)
        
        rightTimeLabel = UILabel(frame: .zero)
        rightTimeLabel.font = .systemFont(ofSize: 12)
        rightTimeLabel.textAlignment = .center
        addSubview(rightTimeLabel)
        
        playPauseButton = UIButton(frame: .zero)
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play_icon"), for: .normal)
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPress), for: .touchUpInside)
        playPauseButton.frame = CGRect(x: 0, y: 0, width: playPauseButtonSize, height: playPauseButtonSize)
        playPauseButton.center = CGPoint(x: frame.width/2, y: controlButtonsCenterY)
        addSubview(playPauseButton)
        
        forwardsButton = UIButton(frame: .zero)
        forwardsButton.setBackgroundImage(#imageLiteral(resourceName: "skip_forward_icon"), for: .normal)
        forwardsButton.adjustsImageWhenHighlighted = false
        forwardsButton.addTarget(self, action: #selector(forwardButtonPress), for: .touchUpInside)
        forwardsButton.frame = CGRect(x: 0, y: 0, width: forwardsBackwardsButtonSize, height: forwardsBackwardsButtonSize)
        forwardsButton.center = CGPoint(x: playPauseButton.frame.maxX + controlButtonsCenterHorizontalOffset, y: controlButtonsCenterY)
        addSubview(forwardsButton)
        
        forwardsLabel = UILabel(frame: .zero)
        forwardsLabel.text = "30"
        forwardsLabel.sizeToFit()
        forwardsLabel.center = forwardsButton.center
        addSubview(forwardsLabel)
        
        backwardsButton = UIButton(frame: .zero)
        backwardsButton.setBackgroundImage(#imageLiteral(resourceName: "skip_backward_icon"), for: .normal)
        backwardsButton.adjustsImageWhenHighlighted = false
        backwardsButton.addTarget(self, action: #selector(backwardButtonPress), for: .touchUpInside)
        backwardsButton.frame = CGRect(x: 0, y: 0, width: forwardsBackwardsButtonSize, height: forwardsBackwardsButtonSize)
        backwardsButton.center = CGPoint(x: playPauseButton.frame.minX - controlButtonsCenterHorizontalOffset, y: controlButtonsCenterY)
        addSubview(backwardsButton)
        
        backwardsLabel = UILabel(frame: .zero)
        backwardsLabel.text = "30"
        backwardsLabel.sizeToFit()
        backwardsLabel.center = backwardsButton.center
        addSubview(backwardsLabel)
        
        updateUI(isPlaying: false, elapsedTime: "0:00", timeLeft: "0:00", progress: 0.0, isScrubbing: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(isPlaying: Bool, elapsedTime: String, timeLeft: String, progress: Float, isScrubbing: Bool) {
        if isPlaying {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "pause_icon"), for: .normal)
        } else {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play_icon"), for: .normal)
        }
        if !isScrubbing {
            slider.value = progress
        }
        leftTimeLabel.text = elapsedTime
        rightTimeLabel.text = timeLeft
        leftTimeLabel.sizeToFit()
        rightTimeLabel.sizeToFit()
        leftTimeLabel.center = CGPoint(x: timeLabelHorizontalInset + leftTimeLabel.frame.width/2, y: sliderCenterY)
        rightTimeLabel.center = CGPoint(x: frame.width - rightTimeLabel.frame.width/2 - timeLabelHorizontalInset, y: sliderCenterY)
    }
    
    func playPauseButtonPress() {
        delegate?.playerControlsDidTapPlayPauseButton()
    }
    
    func forwardButtonPress() {
        delegate?.playerControlsDidTapSkipForward()
    }
    
    func backwardButtonPress() {
        delegate?.playerControlsDidTapSkipBackward()
    }
    
    func endScrubbing() {
        delegate?.playerControlsDidEndScrub()
    }
    
    func sliderValueChanged() {
        delegate?.playerControlsDidScrub()
    }


}
