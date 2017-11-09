//
//  EpisodeUtilityButtonBar.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

class EpisodeUtilityButtonBarView: UIView {
    
    static var height: CGFloat = 48
    
    var bottomLineseparator: UIView!
    var topLineseparator: UIView!
    var recommendedButton: FillNumberButton!
    var bookmarkButton: BookmarkButton!
    var moreButton: MoreButton!
    var playButton: PlayButton!
    var hasBottomLineseparator: Bool = false
    var hasTopLineseparator: Bool = false
    
    //Constants 
    var playButtonX: CGFloat = 18
    var playButtonWidth: CGFloat = 75
    var playButtonHeight: CGFloat = EpisodeUtilityButtonBarView.height
    
    var bookmarkButtonHeight: CGFloat = EpisodeUtilityButtonBarView.height
    var bookmarkButtonWidth: CGFloat = 23
    
    var recommendedButtonWidth: CGFloat = 60
    var recommendedButtonHeight: CGFloat = EpisodeUtilityButtonBarView.height
    var recommendedButtonRightX: CGFloat = 70
    
    var buttonPadding: CGFloat = 10
    let bottomViewInnerPadding: CGFloat = 18
    
    var lineseparatorX: CGFloat = 18
    var lineseparatorHeight: CGFloat = 1
    
    let moreButtonHeight: CGFloat = EpisodeUtilityButtonBarView.height
    let moreButtonWidth: CGFloat = 23
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .offWhite
        
        playButton = PlayButton()
        moreButton = MoreButton()
        bookmarkButton = BookmarkButton()
        recommendedButton = FillNumberButton(type: .recommend)
        
        addSubview(playButton)
        addSubview(moreButton)
        addSubview(bookmarkButton)
        addSubview(recommendedButton)
        
        bottomLineseparator = UIView(frame: CGRect.zero)
        topLineseparator = UIView(frame: CGRect.zero)
        topLineseparator.backgroundColor = .lightGrey
        bottomLineseparator.backgroundColor = .lightGrey
        addSubview(bottomLineseparator)
        addSubview(topLineseparator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        bottomLineseparator.frame = CGRect(x: lineseparatorX, y: 0, width: frame.width - 2 * lineseparatorX, height: lineseparatorHeight)
        topLineseparator.frame = CGRect(x: lineseparatorX, y: frame.height - lineseparatorHeight, width: frame.width - 2 * lineseparatorX, height: lineseparatorHeight)
        playButton.frame = CGRect(x: playButtonX, y: 0, width: playButtonWidth, height: playButtonHeight)
        moreButton.frame = CGRect(x: frame.width - bottomViewInnerPadding - moreButtonWidth, y: 0, width: moreButtonWidth, height: moreButtonHeight)
        bookmarkButton.frame = CGRect(x: moreButton.frame.minX - bookmarkButtonWidth - buttonPadding, y: 0, width: bookmarkButtonWidth, height: bookmarkButtonHeight)
        recommendedButton.frame = CGRect(x: frame.width - recommendedButtonRightX - recommendedButtonWidth, y: 0, width: recommendedButtonWidth, height:recommendedButtonHeight)
    
        topLineseparator.isHidden = hasTopLineseparator
        bottomLineseparator.isHidden = hasBottomLineseparator
    }
    
    
    func prepareForReuse() {
        playButton.isSelected = false
        recommendedButton.isSelected = false
        bookmarkButton.isSelected = false
    }
    
    func setBookmarkButtonToState(isBookmarked: Bool) {
        bookmarkButton.isSelected = isBookmarked
    }
    
    func setRecommendedButtonToState(isRecommended: Bool, numberOfRecommendations: Int) {
        recommendedButton.setupWithNumber(isSelected: isRecommended, numberOf: numberOfRecommendations)
    }

    func setPlayButtonToState(isPlaying: Bool) {
        playButton.isSelected = isPlaying
    }
}
