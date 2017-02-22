//
//  PlayerControlsView.swift
//  Podcast
//
//  Created by Mark Bryan on 2/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class PlayerControlsView: UIView {
    
    let ForwardsBackwardsButtonSize: CGFloat = 44
    let PlayPauseButtonSize: CGFloat = 40
    let SliderHeight: CGFloat = 6
    let SliderInset: CGFloat = 48
    let SliderCenterY: CGFloat = 25
    let TimeLabelHorizontalInset: CGFloat = 12
    let ControlButtonsCenterY: CGFloat = 71.5
    let ControlButtonsCenterHorizontalOffset: CGFloat = 55
    
    let PlayerControlsViewHeight: CGFloat = 116
    
    var slider: UISlider!
    var playPauseButton: UIButton!
    var forwardsButton: UIButton!
    var forwardsLabel: UILabel!
    var backwardsButton: UIButton!
    var backwardsLabel: UILabel!
    var rightTimeLabel: UILabel!
    var leftTimeLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = PlayerControlsViewHeight
        backgroundColor = .white
        
        slider = UISlider(frame: .zero)
        slider.frame = CGRect(x: 0, y: 0, width: frame.width - (2 * SliderInset), height: SliderHeight)
        slider.center = CGPoint(x: frame.width/2, y: SliderCenterY)
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
        playPauseButton.frame = CGRect(x: 0, y: 0, width: PlayPauseButtonSize, height: PlayPauseButtonSize)
        playPauseButton.center = CGPoint(x: frame.width/2, y: ControlButtonsCenterY)
        addSubview(playPauseButton)
        
        forwardsButton = UIButton(frame: .zero)
        forwardsButton.setBackgroundImage(#imageLiteral(resourceName: "skip_forward_icon"), for: .normal)
        forwardsButton.adjustsImageWhenHighlighted = false
        forwardsButton.addTarget(self, action: #selector(forwardButtonPress), for: .touchUpInside)
        forwardsButton.frame = CGRect(x: 0, y: 0, width: ForwardsBackwardsButtonSize, height: ForwardsBackwardsButtonSize)
        forwardsButton.center = CGPoint(x: playPauseButton.frame.maxX + ControlButtonsCenterHorizontalOffset, y: ControlButtonsCenterY)
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
        backwardsButton.frame = CGRect(x: 0, y: 0, width: ForwardsBackwardsButtonSize, height: ForwardsBackwardsButtonSize)
        backwardsButton.center = CGPoint(x: playPauseButton.frame.minX - ControlButtonsCenterHorizontalOffset, y: ControlButtonsCenterY)
        addSubview(backwardsButton)
        
        backwardsLabel = UILabel(frame: .zero)
        backwardsLabel.text = "30"
        backwardsLabel.sizeToFit()
        backwardsLabel.center = backwardsButton.center
        addSubview(backwardsLabel)
        
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        if Player.sharedInstance.isPlaying {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "pause_icon"), for: .normal)
        } else {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play_icon"), for: .normal)
        }
        
        leftTimeLabel.text = Player.sharedInstance.currentItemElapsedTime().descriptionText
        rightTimeLabel.text = Player.sharedInstance.currentItemRemainingTime().descriptionText
        leftTimeLabel.sizeToFit()
        rightTimeLabel.sizeToFit()
        
        leftTimeLabel.center = CGPoint(x: TimeLabelHorizontalInset + leftTimeLabel.frame.width/2, y: SliderCenterY)
        rightTimeLabel.center = CGPoint(x: frame.width - rightTimeLabel.frame.width/2 - TimeLabelHorizontalInset, y: SliderCenterY)
        
        if !Player.sharedInstance.scrubbing {
            slider.value = Float(Player.sharedInstance.getProgress())
        }
    }
    
    func playPauseButtonPress() {
        Player.sharedInstance.togglePlaying()
    }
    
    func forwardButtonPress() {
        Player.sharedInstance.skip(seconds: 30.0)
    }
    
    func backwardButtonPress() {
        Player.sharedInstance.skip(seconds: -30.0)
    }
    
    func endScrubbing() {
        Player.sharedInstance.setProgress(progress: Double(slider.value))
        Player.sharedInstance.scrubbing = false
        updateUI()
    }
    
    func sliderValueChanged() {
        Player.sharedInstance.scrubbing = true
        // TODO: update time labels as you scrub
        // TODO: pause while scrubbing?
    }


}
