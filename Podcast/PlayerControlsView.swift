//
//  PlayerControlsView.swift
//  Podcast
//
//  Created by Mark Bryan on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class PlayerControlsView: UIView {
    
    //Mark: -
    //Mark: Constants
    //Mark: -
    let TopViewHeight: CGFloat = 40
    let SliderPanelHeight: CGFloat = 40
    let CornerButtonSize: CGFloat = 40
    let TopInset: CGFloat = 8
    let SliderEdgeInset: CGFloat = 50
    
    //Mark: -
    //Mark: Properties
    //Mark: -
    
    var episodeNameTextView: UILabel!
    var authorTextView: UILabel!
    
    // Slider stuff
    var slider: UISlider!
    var timePassed: UILabel!
    var timeLeft: UILabel!
    
    var likeButton: UIButton!
    var moreButton: UIButton!
    var playButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        
        // Top View
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: TopViewHeight))
        episodeNameTextView = UILabel(frame: CGRect(x: 0, y: TopInset, width: frame.width, height: 15))
        episodeNameTextView.textAlignment = .Center
        episodeNameTextView.font = UIFont(name: ".SFUIText-Medium", size: 12)
        episodeNameTextView.text = "Writing on Medium - Steven Levy"
        
        authorTextView = UILabel(frame: CGRect(x: 0, y: episodeNameTextView.frame.maxY, width: frame.width, height: 15))
        authorTextView.textAlignment = .Center
        authorTextView.font = UIFont(name: ".SFUIText-Light", size: 12)
        authorTextView.text = "Hidden Brain"
        
        likeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        likeButton.setImage(UIImage(named: "heart"), forState: .Normal)
        
        moreButton = UIButton(frame: CGRect(x: frame.width - 40, y: 0, width: 40, height: 40))
        moreButton.setImage(UIImage(named: "more"), forState: .Normal)
        
        topView.addSubview(episodeNameTextView)
        topView.addSubview(authorTextView)
        topView.addSubview(likeButton)
        topView.addSubview(moreButton)
        
        // Slider Panel
        let sliderPanel = UIView(frame: CGRect(x: 0, y: topView.frame.maxY, width: frame.width, height: SliderPanelHeight))
        
        timePassed = UILabel(frame: CGRect(x: 0, y: 0, width: SliderEdgeInset, height: SliderPanelHeight))
        timePassed.font = UIFont(name: ".SFUIText-Medium", size: 12)
        timePassed.textAlignment = .Center
        timePassed.text = "4:31"
        
        timeLeft = UILabel(frame: CGRect(x: frame.width - SliderEdgeInset, y: 0, width: SliderEdgeInset, height: SliderPanelHeight))
        timeLeft.font = UIFont(name: ".SFUIText-Medium", size: 12)
        timeLeft.textAlignment = .Center
        timePassed.text = "6:24"
        
        slider = UISlider(frame: CGRect(x: SliderEdgeInset, y: 0, width: frame.width - (2 * SliderEdgeInset), height: SliderPanelHeight))
        sliderPanel.addSubview(timePassed)
        sliderPanel.addSubview(timeLeft)
        sliderPanel.addSubview(slider)
        
        // Buttons Control Panel
        let buttonControlPanel = UIView(frame: CGRect(x: 0, y: sliderPanel.frame.maxY, width: frame.width, height: frame.maxY - sliderPanel.frame.maxY))
        
        // add as subviews
        self.addSubview(topView)
        self.addSubview(sliderPanel)
        self.addSubview(buttonControlPanel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
