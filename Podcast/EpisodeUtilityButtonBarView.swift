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
    var slider: EpisodeDurationSliderView!
    var downloaded: DownloadedIconView!
    var greyedOutLabel: UILabel!
    var hasBottomLineSeparator: Bool = false
    var hasTopLineSeparator: Bool = false
    
    //Constants 
    var playButtonX: CGFloat = 18
    var playButtonWidth: CGFloat = 75
    var playButtonHeight: CGFloat = EpisodeUtilityButtonBarView.height
    
    var downloadedIconX: CGFloat = 147
    var downloadedIconTopPadding: CGFloat = 21
    
    var bookmarkButtonHeight: CGFloat = EpisodeUtilityButtonBarView.height
    var bookmarkButtonWidth: CGFloat = 32
    
    var recommendedButtonWidth: CGFloat = 56
    var recommendedButtonHeight: CGFloat = EpisodeUtilityButtonBarView.height
    var recommendedButtonRightX: CGFloat = 70
    
    var buttonPadding: CGFloat = 10
    let bottomViewInnerPadding: CGFloat = 18
    
    var lineseparatorX: CGFloat = 18
    var lineseparatorHeight: CGFloat = 1
    
    let moreButtonHeight: CGFloat = EpisodeUtilityButtonBarView.height
    let moreButtonWidth: CGFloat = 23

    let sliderHeight: CGFloat = 3
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .offWhite
        
        playButton = PlayButton()
        moreButton = MoreButton()
        bookmarkButton = BookmarkButton()
        recommendedButton = FillNumberButton(type: .recommend)
        downloaded = DownloadedIconView()
        greyedOutLabel = UILabel()
        greyedOutLabel.backgroundColor = UIColor.lightGrey.withAlphaComponent(0.5)
        greyedOutLabel.isHidden = true
        
        addSubview(downloaded)
        addSubview(playButton)
        addSubview(moreButton)
        addSubview(bookmarkButton)
        addSubview(recommendedButton)
        addSubview(greyedOutLabel)
        
        bottomLineseparator = UIView(frame: CGRect.zero)
        topLineseparator = UIView(frame: CGRect.zero)
        topLineseparator.backgroundColor = .lightGrey
        bottomLineseparator.backgroundColor = .lightGrey
        addSubview(bottomLineseparator)
        addSubview(topLineseparator)

        slider = EpisodeDurationSliderView()
        addSubview(slider)
        
        slider.snp.makeConstraints { make in
            make.top.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalTo(sliderHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        downloaded.frame = CGRect(x: frame.width - DownloadedIconView.viewWidth - downloadedIconX, y: 0, width: DownloadedIconView.viewWidth, height: EpisodeUtilityButtonBarView.height)
        bottomLineseparator.frame = CGRect(x: lineseparatorX, y: 0, width: frame.width - 2 * lineseparatorX, height: lineseparatorHeight)
        topLineseparator.frame = CGRect(x: lineseparatorX, y: frame.height - lineseparatorHeight, width: frame.width - 2 * lineseparatorX, height: lineseparatorHeight)
        playButton.frame = CGRect(x: playButtonX, y: 0, width: playButtonWidth, height: playButtonHeight)
        moreButton.frame = CGRect(x: frame.width - bottomViewInnerPadding - moreButtonWidth, y: 0, width: moreButtonWidth, height: moreButtonHeight)
        bookmarkButton.frame = CGRect(x: moreButton.frame.minX - bookmarkButtonWidth - buttonPadding, y: 0, width: bookmarkButtonWidth, height: bookmarkButtonHeight)
        recommendedButton.frame = CGRect(x: bookmarkButton.frame.minX - recommendedButtonWidth, y: 0, width: recommendedButtonWidth, height:recommendedButtonHeight)
    
        topLineseparator.isHidden = hasTopLineSeparator
        bottomLineseparator.isHidden = hasBottomLineSeparator

        greyedOutLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    
    func prepareForReuse() {
        slider.isHidden = true
        if hasTopLineSeparator { topLineseparator.isHidden = false }
        playButton.isSelected = false
        recommendedButton.isSelected = false
        bookmarkButton.isSelected = false
        downloaded.isHidden = true
    }
    
    func setDownloadedToState(isDownloaded: Bool) {
        downloaded.isHidden = !isDownloaded
    }
    
    func setBookmarkButtonToState(isBookmarked: Bool) {
        bookmarkButton.isSelected = isBookmarked
    }
    
    func setRecommendedButtonToState(isRecommended: Bool, numberOfRecommendations: Int) {
        recommendedButton.setupWithNumber(isSelected: isRecommended, numberOf: numberOfRecommendations)
    }

    func setup(with episode: Episode, _ downloadStatus: DownloadStatus) {
        slider.setSliderProgress(isPlaying: episode.isPlaying, progress: episode.currentProgress)
        bookmarkButton.isSelected = episode.isBookmarked
        recommendedButton.setupWithNumber(isSelected: episode.isRecommended, numberOf: episode.numberOfRecommendations)
        topLineseparator.isHidden = !slider.isHidden
        downloaded.setup(downloadStatus)
        playButton.configure(for: episode)
        bookmarkButton.isHidden = episode.audioURL == nil
        recommendedButton.isHidden = episode.audioURL == nil
        greyedOutLabel.isHidden = episode.audioURL != nil
        moreButton.isHidden = episode.audioURL == nil
    }
}
