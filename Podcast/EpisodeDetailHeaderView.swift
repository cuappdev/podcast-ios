//
//  EpisodeDetailHeaderView.swift
//  Podcast
//
//  Created by Mark Bryan on 4/11/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol EpisodeDetailHeaderViewDelegate: class {
    func episodeDetailHeaderDidPressPlayButton(view: EpisodeDetailHeaderView)
    func episodeDetailHeaderDidPressMoreButton(view: EpisodeDetailHeaderView)
    func episodeDetailHeaderDidPressRecommendButton(view: EpisodeDetailHeaderView)
    func episodeDetailHeaderDidPressBookmarkButton(view: EpisodeDetailHeaderView)
    func episodeDetailHeaderDidPressSeriesTitleLabel(view: EpisodeDetailHeaderView)
}

class EpisodeDetailHeaderView: UIView {
    
    static let marginSpacing: CGFloat = 18 //used in EpisodeDetailViewController to set content insets
    
    var episodeArtworkImageView: ImageView!
    var seriesTitleLabel: UIButton!
    var publisherLabel: UILabel!
    var episodeTitleLabel: UILabel!
    var dateLabel: UILabel!
    var descriptionTextView: UITextView!
    var episodeUtilityButtonBarView: EpisodeUtilityButtonBarView!
    weak var delegate: EpisodeDetailHeaderViewDelegate?
    
    let marginSpacing: CGFloat = EpisodeDetailHeaderView.marginSpacing
    let smallPadding: CGFloat = 5
    let artworkDimension: CGFloat = 79
    let bottomViewYSpacing: CGFloat = 9

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor.colorFromCode(0xfcfcfe)
        
        episodeArtworkImageView = ImageView(frame: CGRect(x: 0, y: 0, width: artworkDimension, height: artworkDimension))
        addSubview(episodeArtworkImageView)
        
        seriesTitleLabel = UIButton()
        seriesTitleLabel.showsTouchWhenHighlighted = true
        seriesTitleLabel.setTitle("", for: .normal)
        seriesTitleLabel.setTitleColor(.offBlack, for: .normal)
        seriesTitleLabel.titleLabel!.font = ._20SemiboldFont()
        seriesTitleLabel.titleLabel!.textAlignment = .left
        seriesTitleLabel.titleLabel!.lineBreakMode = .byWordWrapping
        seriesTitleLabel.contentHorizontalAlignment = .left
        seriesTitleLabel.titleLabel!.numberOfLines = 2
        seriesTitleLabel.addTarget(self, action: #selector(didPressSeriesTitleLabel), for: .touchUpInside)
        addSubview(seriesTitleLabel)
        
        episodeTitleLabel = UILabel()
        episodeTitleLabel.font = ._20SemiboldFont()
        episodeTitleLabel.lineBreakMode = .byWordWrapping
        episodeTitleLabel.numberOfLines = 3
        addSubview(episodeTitleLabel)
        
        dateLabel = UILabel()
        dateLabel.font = ._12RegularFont()
        dateLabel.numberOfLines = 1
        dateLabel.textColor = .slateGrey
        addSubview(dateLabel)
        
        episodeUtilityButtonBarView = EpisodeUtilityButtonBarView(frame: .zero)
        episodeUtilityButtonBarView.hasBottomLineseparator = true
        addSubview(episodeUtilityButtonBarView)
    
        episodeUtilityButtonBarView.playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        episodeUtilityButtonBarView.moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        episodeUtilityButtonBarView.bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        episodeUtilityButtonBarView.recommendedButton.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
        
        episodeArtworkImageView.snp.makeConstraints { make in
            make.size.equalTo(artworkDimension)
            make.top.equalToSuperview().inset(marginSpacing)
            make.leading.equalToSuperview().inset(marginSpacing)
        }
        
        seriesTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(episodeArtworkImageView.snp.trailing).offset(marginSpacing)
            make.top.equalTo(episodeArtworkImageView.snp.top)
            make.trailing.equalToSuperview().inset(marginSpacing)
        }
        
        episodeTitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(marginSpacing)
            make.top.equalTo(episodeArtworkImageView.snp.bottom).offset(marginSpacing)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeTitleLabel.snp.bottom).offset(smallPadding)
            make.leading.equalTo(episodeTitleLabel.snp.leading)
            make.trailing.equalTo(episodeTitleLabel.snp.trailing)
        }
        
        episodeUtilityButtonBarView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(bottomViewYSpacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(EpisodeUtilityButtonBarView.height)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupForEpisode(episode: Episode) {
        episodeArtworkImageView.setImageAsynchronouslyWithDefaultImage(url: episode.smallArtworkImageURL)
        seriesTitleLabel.setTitle(episode.seriesTitle, for: .normal)
        episodeTitleLabel.text = episode.title
        setPlayButtonToState(isPlaying: episode.isPlaying)
        episodeUtilityButtonBarView.recommendedButton.setupWithNumber(isSelected: episode.isRecommended, numberOf: episode.numberOfRecommendations)
        setBookmarkButtonToState(isBookmarked: episode.isBookmarked)
        dateLabel.text = episode.dateString()
    }
    
    //
    // Delegate Methods 
    //
    
    func setPlayButtonToState(isPlaying: Bool) {
        episodeUtilityButtonBarView.playButton.isSelected = isPlaying
    }
    
    func setBookmarkButtonToState(isBookmarked: Bool) {
        episodeUtilityButtonBarView.bookmarkButton.isSelected = isBookmarked
    }
    
    func setRecommendedButtonToState(isRecommended: Bool, numberOfRecommendations: Int) {
        
        episodeUtilityButtonBarView.recommendedButton.setupWithNumber(isSelected: isRecommended, numberOf: numberOfRecommendations)
    }
    
    @objc func playButtonTapped() {
        if !episodeUtilityButtonBarView.playButton.isSelected {
            delegate?.episodeDetailHeaderDidPressPlayButton(view: self)
        }
    }
    
    @objc func bookmarkButtonTapped() {
        delegate?.episodeDetailHeaderDidPressBookmarkButton(view: self)
    }
    
    @objc func moreButtonTapped() {
        delegate?.episodeDetailHeaderDidPressMoreButton(view: self)
    }
    
    @objc func recommendButtonTapped() {
        delegate?.episodeDetailHeaderDidPressRecommendButton(view: self)
    }
    
    @objc func didPressSeriesTitleLabel() {
        delegate?.episodeDetailHeaderDidPressSeriesTitleLabel(view: self)
    }
}
