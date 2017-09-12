//
//  EpisodeUtilityButtonBar.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

class EpisodeUtilityButtonBarView: UIView {
    
    var bottomLineSeperator: UIView!
    var topLineSeperator: UIView!
    var recommendedButton: RecommendButton!
    var bookmarkButton: BookmarkButton!
    var moreButton: MoreButton!
    var playButton: PlayButton!
    var hasBottomLineSeperator: Bool = false
    var hasTopLineSeperator: Bool = false
    
    //Constants 
    var playButtonX: CGFloat = 18
    var playButtonWidth: CGFloat = 75
    var playButtonHeight: CGFloat = CardTableViewCell.utilityButtonBarViewHeight
    
    var bookmarkButtonHeight: CGFloat = CardTableViewCell.utilityButtonBarViewHeight
    var bookmarkButtonWidth: CGFloat = 23
    
    var recommendedButtonWidth: CGFloat = 60
    var recommendedButtonHeight: CGFloat = CardTableViewCell.utilityButtonBarViewHeight
    var recommendedButtonRightX: CGFloat = 70
    
    var buttonPadding: CGFloat = 10
    let bottomViewInnerPadding: CGFloat = 18
    
    var lineSeperatorX: CGFloat = 18
    var lineSeperatorHeight: CGFloat = 1
    
    let moreButtonHeight: CGFloat = CardTableViewCell.utilityButtonBarViewHeight
    let moreButtonWidth: CGFloat = 23
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .podcastWhite
        
        playButton = PlayButton(frame: .zero)
        moreButton = MoreButton(frame: .zero)
        bookmarkButton = BookmarkButton(frame: .zero)
        recommendedButton = RecommendButton(frame: .zero)
        
        addSubview(playButton)
        addSubview(moreButton)
        addSubview(bookmarkButton)
        addSubview(recommendedButton)
        
        bottomLineSeperator = UIView(frame: CGRect.zero)
        topLineSeperator = UIView(frame: CGRect.zero)
        topLineSeperator.backgroundColor = .podcastGray
        bottomLineSeperator.backgroundColor = .podcastGray
        addSubview(bottomLineSeperator)
        addSubview(topLineSeperator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        bottomLineSeperator.frame = CGRect(x: lineSeperatorX, y: 0, width: frame.width - 2 * lineSeperatorX, height: lineSeperatorHeight)
        topLineSeperator.frame = CGRect(x: lineSeperatorX, y: frame.height - lineSeperatorHeight, width: frame.width - 2 * lineSeperatorX, height: lineSeperatorHeight)
        playButton.frame = CGRect(x: playButtonX, y: 0, width: playButtonWidth, height: playButtonHeight)
        moreButton.frame = CGRect(x: frame.width - bottomViewInnerPadding - moreButtonWidth, y: 0, width: moreButtonWidth, height: moreButtonHeight)
        bookmarkButton.frame = CGRect(x: moreButton.frame.minX - bookmarkButtonWidth - buttonPadding, y: 0, width: bookmarkButtonWidth, height: bookmarkButtonHeight)
        recommendedButton.frame = CGRect(x: frame.width - recommendedButtonRightX - recommendedButtonWidth, y: 0, width: recommendedButtonWidth, height:recommendedButtonHeight)
    
        topLineSeperator.isHidden = hasTopLineSeperator
        bottomLineSeperator.isHidden = hasBottomLineSeperator
    }
    
    
    func prepareForReuse() {
        playButton.isSelected = false
        recommendedButton.isSelected = false
        bookmarkButton.isSelected = false
    }
}
