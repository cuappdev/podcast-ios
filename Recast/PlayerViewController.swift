//
//  PlayerViewController.swift
//  Recast
//
//  Created by Jack Thompson on 9/16/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {
    
    /// MARK: Variables
    var slider: UISlider!
    var controlView: UIView!
    var playPauseButton: UIButton!
    var forwardsButton: UIButton!
    var backwardsButton: UIButton!
    var dismissButton: UIButton!
    
    /// MARK: Constants
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
    let moreButtonSize: CGSize = CGSize(width: 35, height: 28)
    let speedButtonSize: CGSize = CGSize(width: 40, height: 18)
    let settingsButtonSize: CGFloat = 22
    let moreButtonBottomOffset: CGFloat = 19.5
    let moreButtonTrailingSpacing: CGFloat = 14.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        controlView = UIView(frame: .zero)
        view.addSubview(controlView)
        
        slider = UISlider(frame: .zero)
        slider.setThumbImage(#imageLiteral(resourceName: "oval"), for: .normal)
        controlView.addSubview(slider)
        
        playPauseButton = UIButton(frame: .zero)
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "player_pause_icon"), for: .selected)
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "player_play_icon"), for: .normal)
        //playPauseButton.addTarget(self, action: #selector(playPauseButtonPress), for: .touchUpInside)
        controlView.addSubview(playPauseButton)
        
        
        
        forwardsButton = UIButton()
        forwardsButton.setBackgroundImage(#imageLiteral(resourceName: "player_skip_forward_icon"), for: .normal)
        forwardsButton.adjustsImageWhenHighlighted = false
        //forwardsButton.addTarget(self, action: #selector(forwardButtonPress), for: .touchUpInside)
        controlView.addSubview(forwardsButton)
        
        
        backwardsButton = UIButton()
        backwardsButton.setBackgroundImage(#imageLiteral(resourceName: "player_skip_backward_icon"), for: .normal)
        backwardsButton.adjustsImageWhenHighlighted = false
        //backwardsButton.addTarget(self, action: #selector(backwardButtonPress), for: .touchUpInside)
        controlView.addSubview(backwardsButton)
        
        dismissButton = UIButton()
        dismissButton.setBackgroundImage(#imageLiteral(resourceName: "down_arrow_icon"), for: .normal)
        dismissButton.adjustsImageWhenHighlighted = false
        dismissButton.addTarget(self, action: #selector(collapse), for: .touchUpInside)
        view.addSubview(dismissButton)
        
        layoutSubviews()
    }
    
    func layoutSubviews() {
        controlView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(100)
            make.height.equalTo(200)
        }
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
            make.height.equalTo(forwardsButton.snp.width).multipliedBy(skipButtonHeightMultiplier)
            make.top.equalTo(slider.snp.bottom).offset(skipButtonTopOffset)
            make.leading.equalTo(playPauseButton.snp.trailing).offset(skipForwardSpacing)
        }
        
        backwardsButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(skipButtonWidthMultiplier)
            make.height.equalTo(forwardsButton.snp.width).multipliedBy(skipButtonHeightMultiplier)
            make.centerY.equalTo(forwardsButton.snp.centerY)
            make.trailing.equalTo(playPauseButton.snp.leading).offset(0 - skipForwardSpacing)
        }
        
        dismissButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.width.equalTo(30)
        }
    }
    
    @objc func collapse() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
