//
//  PlayerControlsView.swift
//  Podcast
//
//  Created by Jack Thompson on 9/18/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class PlayerControlsView: UIView {

    // MARK: - Variables
    var slider: UISlider!
    var playPauseButton: UIButton!
    var forwardsButton: UIButton!
    var backwardsButton: UIButton!
    var rightTimeLabel: UILabel!
    var leftTimeLabel: UILabel!
    //    var recommendButton: FillNumberButton!
    //    var moreButton: MoreButton!
    var speedButton: UIButton!
    var settingsButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        slider = UISlider()
        slider.setThumbImage(#imageLiteral(resourceName: "oval"), for: .normal)
        addSubview(slider)

        leftTimeLabel = UILabel(frame: .zero)
        leftTimeLabel.font = .systemFont(ofSize: 12)
        leftTimeLabel.textColor = .gray
        leftTimeLabel.textAlignment = .left
        addSubview(leftTimeLabel)

        rightTimeLabel = UILabel(frame: .zero)
        rightTimeLabel.font = .systemFont(ofSize: 12)
        rightTimeLabel.textColor = .gray
        rightTimeLabel.textAlignment = .right
        addSubview(rightTimeLabel)

        playPauseButton = UIButton(frame: .zero)
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "player_pause_icon"), for: .selected)
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "player_play_icon"), for: .normal)
//        playPauseButton.addTarget(self, action: #selector(playPauseButtonPress), for: .touchUpInside)
        addSubview(playPauseButton)

        forwardsButton = UIButton()
        forwardsButton.setBackgroundImage(#imageLiteral(resourceName: "player_skip_forward_icon"), for: .normal)
        forwardsButton.adjustsImageWhenHighlighted = false
//        forwardsButton.addTarget(self, action: #selector(forwardButtonPress), for: .touchUpInside)
        addSubview(forwardsButton)

        speedButton = UIButton()
        speedButton.setTitleColor(.gray, for: .normal)
        speedButton.contentHorizontalAlignment = .left
        speedButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        speedButton.addTarget(self, action: #selector(speedButtonPress), for: .touchUpInside)
        addSubview(speedButton)

        settingsButton = UIButton()
        settingsButton.setImage(#imageLiteral(resourceName: "settingsButton"), for: .normal)
//        settingsButton.addTarget(self, action: #selector(settingsButtonPress), for: .touchUpInside)
        addSubview(settingsButton)

        backwardsButton = UIButton()
        backwardsButton.setBackgroundImage(#imageLiteral(resourceName: "player_skip_backward_icon"), for: .normal)
        backwardsButton.adjustsImageWhenHighlighted = false
//        backwardsButton.addTarget(self, action: #selector(backwardButtonPress), for: .touchUpInside)
        addSubview(backwardsButton)

        updateUI(isPlaying: false, elapsedTime: "0:00", timeLeft: "0:00", progress: 0.0,
                 isScrubbing: false /*, rate: .one */)

        layoutSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        // MARK: - Constants
        let sliderHeight: CGFloat = 1.5
        let marginSpacing: CGFloat = 24.5

        let playPauseButtonWidthMultiplier: CGFloat = 0.21
        let playPauseButtonTopOffset: CGFloat = 40.0
        let skipButtonWidthMultiplier: CGFloat = 0.15
        let skipForwardSpacing: CGFloat = 17.5
        let skipButtonTopOffset: CGFloat = 60
        let sliderTopOffset: CGFloat = 26.5
        let timeLabelSpacing: CGFloat = 8
        let speedButtonSize: CGSize = CGSize(width: 40, height: 18)
        let settingsButtonSize: CGFloat = 22

        slider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(marginSpacing)
            make.top.equalToSuperview().offset(sliderTopOffset)
            make.height.equalTo(sliderHeight)
        }

        playPauseButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(playPauseButtonWidthMultiplier)
            make.height.equalTo(playPauseButton.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(slider.snp.bottom).offset(playPauseButtonTopOffset)
        }

        forwardsButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(skipButtonWidthMultiplier)
            make.height.equalTo(forwardsButton.snp.width)
            make.top.equalTo(slider.snp.bottom).offset(skipButtonTopOffset)
            make.leading.equalTo(playPauseButton.snp.trailing).offset(skipForwardSpacing)
        }

        backwardsButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(skipButtonWidthMultiplier)
            make.height.equalTo(forwardsButton.snp.width)
            make.centerY.equalTo(forwardsButton.snp.centerY)
            make.trailing.equalTo(playPauseButton.snp.leading).offset(0 - skipForwardSpacing)
        }

        speedButton.snp.makeConstraints { make in
            make.size.equalTo(speedButtonSize)
            make.leading.equalTo(slider.snp.leading)
            make.centerY.equalTo(forwardsButton.snp.centerY)
        }

        settingsButton.snp.makeConstraints { make in
            make.size.equalTo(settingsButtonSize)
            make.centerY.equalTo(forwardsButton.snp.centerY)
            make.trailing.equalTo(slider.snp.trailing)
        }

        leftTimeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(marginSpacing)
            make.top.equalTo(slider.snp.bottom).offset(timeLabelSpacing)
        }

        rightTimeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(marginSpacing)
            make.top.equalTo(leftTimeLabel.snp.top)
        }
    }

    func updateUI(isPlaying: Bool, elapsedTime: String, timeLeft: String, progress: Float,
                  isScrubbing: Bool /*,  rate: PlayerRate */) {
        playPauseButton.isSelected = isPlaying
        if !isScrubbing {
            slider.value = progress
        }
        speedButton.setTitle("1x", for: .normal)
        leftTimeLabel.text = elapsedTime
        rightTimeLabel.text = timeLeft
        leftTimeLabel.sizeToFit()
        rightTimeLabel.sizeToFit()
    }
}
