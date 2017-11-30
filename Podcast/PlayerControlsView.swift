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
    func playerControlsDidTapSpeed()
    func playerControlsDidSkipNext()
    func playerControlsDidScrub()
    func playerControlsDidEndScrub()
    func playerControlsDidTapMoreButton()
    func playerControlsDidTapRecommendButton()
}

class PlayerControlsView: UIView {
    
    let sliderHeight: CGFloat = 1.5
    let marginSpacing: CGFloat = 24.5
    
    let playerControlsViewHeight: CGFloat = 200
    
    let playPauseButtonSize: CGSize = CGSize(width: 96, height: 96.5)
    let playPauseButtonWidthMultiplier: CGFloat = 0.21
    let playPauseButtonTopOffset: CGFloat = 40.0
    let skipButtonSize: CGSize = CGSize(width: 56.5, height: 20)
    let skipButtonWidthMultiplier: CGFloat = 0.15
    let skipButtonHeightMultiplier: CGFloat = 0.354
    let skipButtonSpacing: CGFloat = 40.5
    let skipForwardSpacing: CGFloat = 17.5
    let skipBackwardSpacing: CGFloat = 15
    let skipButtonTopOffset: CGFloat = 60
    let sliderTopOffset: CGFloat = 26.5
    let sliderYInset: CGFloat = 132
    let timeLabelSpacing: CGFloat = 8
    let buttonsYInset: CGFloat = 181.5
    let nextButtonSize: CGSize = CGSize(width: 12.5, height: 13)
    let nextButtonLeftOffset: CGFloat = 29
    let nextButtonTopOffset: CGFloat = 65.1
    let recommendButtonSize: CGSize = CGSize(width: 80, height: 18)
    let moreButtonSize: CGSize = CGSize(width: 25, height: 18)
    let speedButtonSize: CGSize = CGSize(width: 30, height: 18)
    let moreButtonBottomOffset: CGFloat = 19.5
    
    var slider: UISlider!
    var playPauseButton: UIButton!
    var forwardsButton: UIButton!
    var backwardsButton: UIButton!
    var rightTimeLabel: UILabel!
    var leftTimeLabel: UILabel!
    var recommendButton: FillNumberButton!
    var moreButton: MoreButton!
    var nextButton: UIButton!
    var speedButton: UIButton!
    
    weak var delegate: PlayerControlsDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = playerControlsViewHeight
        backgroundColor = .clear
                
        slider = Slider()
        slider.setThumbImage(#imageLiteral(resourceName: "oval"), for: .normal)
        slider.minimumTrackTintColor = .sea
        slider.maximumTrackTintColor = .silver
        addSubview(slider)
        slider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(marginSpacing)
            make.top.equalToSuperview().offset(sliderTopOffset)
            make.height.equalTo(sliderHeight)
        }
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(endScrubbing), for: .touchUpInside)
        slider.addTarget(self, action: #selector(endScrubbing), for: .touchUpOutside)
        
        leftTimeLabel = UILabel(frame: .zero)
        leftTimeLabel.font = ._12RegularFont()
        leftTimeLabel.textColor = .slateGrey
        leftTimeLabel.textAlignment = .left
        addSubview(leftTimeLabel)
        
        rightTimeLabel = UILabel(frame: .zero)
        rightTimeLabel.font = ._12RegularFont()
        rightTimeLabel.textColor = .slateGrey
        rightTimeLabel.textAlignment = .right
        addSubview(rightTimeLabel)
        
        playPauseButton = UIButton(frame: .zero)
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "pause"), for: .selected)
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play"), for: .normal)
        playPauseButton.addTarget(self, action: #selector(playPauseButtonPress), for: .touchUpInside)
        addSubview(playPauseButton)
        
        playPauseButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(playPauseButtonWidthMultiplier)
            make.height.equalTo(playPauseButton.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(slider.snp.bottom).offset(playPauseButtonTopOffset)
        }
        
        forwardsButton = Button()
        forwardsButton.setBackgroundImage(#imageLiteral(resourceName: "forward30"), for: .normal)
        forwardsButton.adjustsImageWhenHighlighted = false
        forwardsButton.addTarget(self, action: #selector(forwardButtonPress), for: .touchUpInside)
        addSubview(forwardsButton)
        forwardsButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(skipButtonWidthMultiplier)
            make.height.equalTo(forwardsButton.snp.width).multipliedBy(skipButtonHeightMultiplier)
            make.top.equalTo(slider.snp.bottom).offset(skipButtonTopOffset)
            make.leading.equalTo(playPauseButton.snp.trailing).offset(skipForwardSpacing)
        }
        
        speedButton = Button()
        speedButton.titleLabel?.font = ._12RegularFont()
        speedButton.setTitleColor(.slateGrey, for: .normal)
        speedButton.addTarget(self, action: #selector(speedButtonPress), for: .touchUpInside)
        addSubview(speedButton)
        speedButton.snp.makeConstraints { make in
            make.size.equalTo(speedButtonSize)
            make.leading.equalTo(slider.snp.leading)
            make.centerY.equalTo(forwardsButton.snp.centerY)
        }
        
        backwardsButton = Button()
        backwardsButton.setBackgroundImage(#imageLiteral(resourceName: "back30"), for: .normal)
        backwardsButton.adjustsImageWhenHighlighted = false
        backwardsButton.addTarget(self, action: #selector(backwardButtonPress), for: .touchUpInside)
        addSubview(backwardsButton)
        backwardsButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(skipButtonWidthMultiplier)
            make.height.equalTo(forwardsButton.snp.width).multipliedBy(skipButtonHeightMultiplier)
            make.centerY.equalTo(forwardsButton.snp.centerY)
            make.trailing.equalTo(playPauseButton.snp.leading).offset(0 - skipForwardSpacing)
        }
        
        recommendButton = FillNumberButton(type: .recommend)
        recommendButton.frame = CGRect(x: marginSpacing, y: self.frame.maxY - buttonsYInset, width: recommendButtonSize.width, height: recommendButtonSize.height)
        recommendButton.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
        
        nextButton = UIButton(frame: .zero)
        nextButton.setBackgroundImage(#imageLiteral(resourceName: "next"), for: .normal)
        nextButton.adjustsImageWhenHighlighted = false
        nextButton.addTarget(self, action: #selector(nextButtonPress), for: .touchUpInside)
        addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.size.equalTo(nextButtonSize)
            make.centerY.equalTo(forwardsButton.snp.centerY)
            make.trailing.equalTo(slider.snp.trailing)
        }
        nextButton.isHidden = true // Remove this once we implement a queue
        
        moreButton = MoreButton()
        moreButton.frame.origin = CGPoint(x: frame.maxX - marginSpacing - moreButtonSize.width, y: self.frame.maxY - buttonsYInset)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        addSubview(moreButton)
        moreButton.snp.makeConstraints { make in
            make.size.equalTo(moreButtonSize)
            make.bottom.equalToSuperview().inset(moreButtonBottomOffset)
            make.trailing.equalToSuperview().inset(marginSpacing)
        }
        
        updateUI(isPlaying: false, elapsedTime: "0:00", timeLeft: "0:00", progress: 0.0, isScrubbing: false, rate: .one)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI(isPlaying: Bool, elapsedTime: String, timeLeft: String, progress: Float, isScrubbing: Bool, rate: PlayerRate) {
        playPauseButton.isSelected = isPlaying
        if !isScrubbing {
            slider.value = progress
        }
        speedButton.setTitle(rate.toString(), for: .normal)
        leftTimeLabel.text = elapsedTime
        rightTimeLabel.text = timeLeft
        leftTimeLabel.sizeToFit()
        rightTimeLabel.sizeToFit()
        leftTimeLabel.frame.origin = CGPoint(x: marginSpacing, y: slider.frame.maxY + timeLabelSpacing)
        rightTimeLabel.frame.origin = CGPoint(x: frame.maxX - marginSpacing - rightTimeLabel.frame.width, y: slider.frame.maxY + timeLabelSpacing)
    }
    
    @objc func playPauseButtonPress() {
        playPauseButton.isSelected = !playPauseButton.isSelected
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
    
    @objc func speedButtonPress() {
        delegate?.playerControlsDidTapSpeed()
    }
    
    @objc func nextButtonPress() {
        delegate?.playerControlsDidSkipNext()
    }
    
    @objc func moreButtonTapped() {
        delegate?.playerControlsDidTapMoreButton()
    }
    
    @objc func recommendButtonTapped() {
        delegate?.playerControlsDidTapRecommendButton()
    }
        
    func setRecommendButtonToState(isRecommended: Bool, numberOfRecommendations: Int) {
        recommendButton.setupWithNumber(isSelected: isRecommended, numberOf: numberOfRecommendations)
    }
}
