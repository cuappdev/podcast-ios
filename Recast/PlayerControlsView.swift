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
    var timeSlider: UISlider!
    var rightTimeLabel: UILabel!
    var leftTimeLabel: UILabel!

    var playPauseButton: UIButton!
    var forwardButton: UIButton!
    var rewindButton: UIButton!

    var speedButton: UIButton!
    var settingsButton: UIButton!

    // swiftlint:disable next function_body_length
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear

        timeSlider = UISlider()
        timeSlider.tintColor = UIColor.recastAquamarine()
        timeSlider.thumbTintColor = UIColor.recastAquamarine()
        timeSlider.isContinuous = false
        addSubview(timeSlider)

        leftTimeLabel = UILabel(frame: .zero)
        leftTimeLabel.font = .systemFont(ofSize: 12)
        leftTimeLabel.textColor = .lightGray
        leftTimeLabel.textAlignment = .left
        addSubview(leftTimeLabel)

        rightTimeLabel = UILabel(frame: .zero)
        rightTimeLabel.font = .systemFont(ofSize: 12)
        rightTimeLabel.textColor = .lightGray
        rightTimeLabel.textAlignment = .right
        addSubview(rightTimeLabel)

        playPauseButton = UIButton(frame: .zero)
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.setImage(UIImage(named: "player_play_icon"), for: .normal)
        playPauseButton.tintColor = .white
        addSubview(playPauseButton)

        forwardButton = UIButton()
        forwardButton.setImage(#imageLiteral(resourceName: "player_skip_forward_icon"), for: .normal)
        forwardButton.adjustsImageWhenHighlighted = false
        forwardButton.tintColor = .white
        addSubview(forwardButton)

        speedButton = UIButton()
        speedButton.setTitleColor(.gray, for: .normal)
        speedButton.contentHorizontalAlignment = .left
        speedButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        speedButton.tintColor = .white
        addSubview(speedButton)

        settingsButton = UIButton()
        settingsButton.setImage(#imageLiteral(resourceName: "settingsButton"), for: .normal)
        settingsButton.tintColor = .white
        addSubview(settingsButton)

        rewindButton = UIButton()
        rewindButton.setImage(#imageLiteral(resourceName: "player_skip_backward_icon"), for: .normal)
        rewindButton.adjustsImageWhenHighlighted = false
        rewindButton.tintColor = .white
        addSubview(rewindButton)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // swiftlint:disable:next function_body_length
    func setupConstraints() {
        // MARK: - Constants
        let sliderHeight: CGFloat = 3
        let marginSpacing: CGFloat = 24.5

        let playPauseButtonWidthMultiplier: CGFloat = 0.21
        let playPauseButtonTopOffset: CGFloat = 40.0
        let skipButtonWidthMultiplier: CGFloat = 0.15
        let skipForwardSpacing: CGFloat = 17.5
        let sliderTopOffset: CGFloat = 26.5
        let timeLabelSpacing: CGFloat = 8
        let speedButtonSize: CGSize = CGSize(width: 40, height: 18)
        let settingsButtonSize: CGFloat = 22

        timeSlider.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(marginSpacing)
            make.top.equalToSuperview().inset(sliderTopOffset)
            make.height.equalTo(sliderHeight)
        }

        playPauseButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(playPauseButtonWidthMultiplier)
            make.height.equalTo(playPauseButton.snp.width)
            make.centerX.equalToSuperview()
            make.top.equalTo(timeSlider.snp.bottom).offset(playPauseButtonTopOffset)
        }

        forwardButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(skipButtonWidthMultiplier)
            make.height.equalTo(forwardButton.snp.width)
            make.centerY.equalTo(playPauseButton)
            make.leading.equalTo(playPauseButton.snp.trailing).offset(skipForwardSpacing)
        }

        rewindButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(skipButtonWidthMultiplier)
            make.height.equalTo(forwardButton.snp.width)
            make.centerY.equalTo(forwardButton)
            make.trailing.equalTo(playPauseButton.snp.leading).offset(0 - skipForwardSpacing)
        }

        speedButton.snp.makeConstraints { make in
            make.size.equalTo(speedButtonSize)
            make.leading.equalTo(timeSlider)
            make.centerY.equalTo(forwardButton)
        }

        settingsButton.snp.makeConstraints { make in
            make.size.equalTo(settingsButtonSize)
            make.centerY.equalTo(forwardButton)
            make.trailing.equalTo(timeSlider)
        }

        leftTimeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(marginSpacing)
            make.top.equalTo(timeSlider.snp.bottom).offset(timeLabelSpacing)
        }

        rightTimeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(marginSpacing)
            make.top.equalTo(leftTimeLabel.snp.top)
        }
    }
}
