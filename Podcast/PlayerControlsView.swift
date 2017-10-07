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
    func playerControlsDidTapMoreButton()
    func playerControlsDidTapRecommendButton()
}

class PlayerControlsView: UIView {
    
    let sliderHeight: CGFloat = 1.5
    let marginSpacing: CGFloat = 18.5
    
    let playerControlsViewHeight: CGFloat = 192
    
    let playPauseButtonSize: CGSize = CGSize(width: 72, height: 72)
    let skipButtonSize: CGSize = CGSize(width: 27, height: 29)
    let skipButtonSpacing: CGFloat = 40.5
    let skipButtonYInset: CGFloat = 79
    let sliderYInset: CGFloat = 132
    let timeLabelSpacing: CGFloat = 8
    let buttonsYInset: CGFloat = 181.5
    
    let recommendButtonSize: CGSize = CGSize(width: 80, height: 18)
    let moreButtonSize: CGSize = CGSize(width: 25, height: 18)
    
    var slider: UISlider!
    var playPauseButton: UIButton!
    var forwardsButton: UIButton!
    var backwardsButton: UIButton!
    var rightTimeLabel: UILabel!
    var leftTimeLabel: UILabel!
    var recommendButton: RecommendButton!
    var moreButton: MoreButton!
    
    weak var delegate: PlayerControlsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = playerControlsViewHeight
        backgroundColor = .lightGrey
        
        slider = UISlider(frame: .zero)
        slider.frame.origin = CGPoint(x: marginSpacing, y: self.frame.maxY - sliderYInset)
        slider.frame.size = CGSize(width: frame.width - 2 * marginSpacing, height: sliderHeight)
        slider.minimumTrackTintColor = .sea
        slider.maximumTrackTintColor = .silver
        addSubview(slider)
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(endScrubbing), for: .touchUpInside)
        slider.addTarget(self, action: #selector(endScrubbing), for: .touchUpOutside)
        
        leftTimeLabel = UILabel(frame: .zero)
        leftTimeLabel.font = .systemFont(ofSize: 12)
        leftTimeLabel.textColor = .slateGrey
        leftTimeLabel.textAlignment = .left
        addSubview(leftTimeLabel)
        
        rightTimeLabel = UILabel(frame: .zero)
        rightTimeLabel.font = .systemFont(ofSize: 12)
        rightTimeLabel.textColor = .slateGrey
        rightTimeLabel.textAlignment = .right
        addSubview(rightTimeLabel)
        
        playPauseButton = UIButton(frame: .zero)
        playPauseButton.frame.size = playPauseButtonSize
        playPauseButton.frame.origin = CGPoint(x: self.frame.width/2 - playPauseButtonSize.width/2, y: self.frame.maxY - 102)
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPress), for: .touchUpInside)
        addSubview(playPauseButton)
        
        forwardsButton = UIButton(frame: .zero)
        forwardsButton.frame.size = skipButtonSize
        forwardsButton.frame.origin = CGPoint(x: playPauseButton.frame.maxX + skipButtonSpacing, y: self.frame.maxY - skipButtonYInset)
        forwardsButton.setBackgroundImage(#imageLiteral(resourceName: "player_skip_forward_icon"), for: .normal)
        forwardsButton.adjustsImageWhenHighlighted = false
        forwardsButton.addTarget(self, action: #selector(forwardButtonPress), for: .touchUpInside)
        addSubview(forwardsButton)
        
        backwardsButton = UIButton(frame: .zero)
        backwardsButton.frame.size = skipButtonSize
        backwardsButton.frame.origin = CGPoint(x: playPauseButton.frame.minX - skipButtonSpacing - skipButtonSize.width, y: self.frame.maxY - skipButtonYInset)
        backwardsButton.setBackgroundImage(#imageLiteral(resourceName: "player_skip_backward_icon"), for: .normal)
        backwardsButton.adjustsImageWhenHighlighted = false
        backwardsButton.addTarget(self, action: #selector(backwardButtonPress), for: .touchUpInside)
        addSubview(backwardsButton)
        
        recommendButton = RecommendButton(frame: CGRect(x: marginSpacing, y: self.frame.maxY - buttonsYInset, width: recommendButtonSize.width, height: recommendButtonSize.height))
        recommendButton.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
        addSubview(recommendButton)
        
        moreButton = MoreButton(frame: .zero)
        moreButton.frame.size = moreButtonSize
        moreButton.frame.origin = CGPoint(x: frame.maxX - marginSpacing - moreButtonSize.width, y: self.frame.maxY - buttonsYInset)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        addSubview(moreButton)
        
        updateUI(isPlaying: false, elapsedTime: "0:00", timeLeft: "0:00", progress: 0.0, isScrubbing: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(isPlaying: Bool, elapsedTime: String, timeLeft: String, progress: Float, isScrubbing: Bool) {
        if isPlaying {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "player_pause_icon"), for: .normal)
        } else {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "player_play_icon"), for: .normal)
        }
        if !isScrubbing {
            slider.value = progress
        }
        leftTimeLabel.text = elapsedTime
        rightTimeLabel.text = timeLeft
        leftTimeLabel.sizeToFit()
        rightTimeLabel.sizeToFit()
        leftTimeLabel.frame.origin = CGPoint(x: marginSpacing, y: slider.frame.maxY + timeLabelSpacing)
        rightTimeLabel.frame.origin = CGPoint(x: frame.maxX - marginSpacing - rightTimeLabel.frame.width, y: slider.frame.maxY + timeLabelSpacing)
    }
    
    @objc func playPauseButtonPress() {
        delegate?.playerControlsDidTapPlayPauseButton()
    }
    
    @objc func forwardButtonPress() {
        delegate?.playerControlsDidTapSkipForward()
    }
    
    @objc func backwardButtonPress() {
        delegate?.playerControlsDidTapSkipBackward()
    }
    
    @objc func endScrubbing() {
        delegate?.playerControlsDidEndScrub()
    }
    
    @objc func sliderValueChanged() {
        delegate?.playerControlsDidScrub()
    }
    
    @objc func moreButtonTapped() {
        delegate?.playerControlsDidTapMoreButton()
    }
    
    @objc func recommendButtonTapped() {
        delegate?.playerControlsDidTapRecommendButton()
    }
    
    func setRecommendButtonToState(isRecommended: Bool) {
        recommendButton.isSelected = isRecommended
    }
    
    func setNumberRecommended(numberRecommended: Int) {
        recommendButton.setNumberRecommended(numberRecommended: numberRecommended)
    }


}
