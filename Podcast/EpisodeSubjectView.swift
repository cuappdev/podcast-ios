//
//  EpisodeFeedElementSubjectView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol EpisodeSubjectViewDelegate: class {
    func episodeSubjectViewDidPressPlayPauseButton(episodeSubjectView: EpisodeSubjectView)
    func episodeSubjectViewDidPressRecommendButton(episodeSubjectView: EpisodeSubjectView)
    func episodeSubjectViewDidPressBookmarkButton(episodeSubjectView: EpisodeSubjectView)
    func episodeSubjectViewDidPressTagButton(episodeSubjectView: EpisodeSubjectView, index: Int)
    func episodeSubjectViewDidPressMoreActionsButton(episodeSubjectView: EpisodeSubjectView)
}

class EpisodeSubjectView: UIView {
    
    static let episodeSubjectViewHeight: CGFloat = 256
    static let episodeUtilityButtonBarViewHeight: CGFloat = EpisodeUtilityButtonBarView.height
    
    ///
    /// Mark: View Constants
    ///
    var separatorHeight: CGFloat = 9
    var episodeNameLabelX: CGFloat = 86.5
    var episodeNameLabelRightX: CGFloat = 21
    var descriptionLabelX: CGFloat = 17.5
    var podcastImageX: CGFloat = 17.5
    var podcastImageY: CGFloat = 17
    var podcastImageSize: CGFloat = 60
    var tagButtonBottomMargin: CGFloat = 10
    var tagButtonViewHeight: CGFloat = 0
    var episodeUtilityButtonBarViewHeight: CGFloat = EpisodeSubjectView.episodeUtilityButtonBarViewHeight
    
    var marginSpacing: CGFloat = 6
    
    ///
    /// Mark: Variables
    ///
    var episodeNameLabel: UILabel!
    var dateTimeLabel: UILabel!
    var descriptionLabel: UILabel!
    var separator: UIView!
    var podcastImage: ImageView!
    var mainView: UIView! //main view
    var episodeUtilityButtonBarView: EpisodeUtilityButtonBarView! //bottom bar view with buttons
    
    weak var delegate: EpisodeSubjectViewDelegate?
    
    
    
    ///
    ///Mark: Init
    ///
    init() {
        super.init(frame: .zero)

        backgroundColor = .offWhite
        
        mainView = UIView(frame: CGRect.zero)
        mainView.backgroundColor = .offWhite
        addSubview(mainView)
        
        episodeUtilityButtonBarView = EpisodeUtilityButtonBarView(frame: .zero)
        episodeUtilityButtonBarView.hasTopLineSeparator = true
        addSubview(episodeUtilityButtonBarView)
        
        separator = UIView(frame: CGRect.zero)
        separator.backgroundColor = .paleGrey
        addSubview(separator)
        
        episodeNameLabel = UILabel(frame: CGRect.zero)
        dateTimeLabel = UILabel(frame: CGRect.zero)
        descriptionLabel = UILabel(frame: CGRect.zero)
        
        episodeNameLabel.font = ._14SemiboldFont()
        episodeNameLabel.textColor = .offBlack
        episodeNameLabel.numberOfLines = 5
        episodeNameLabel.textAlignment = .left
        episodeNameLabel.lineBreakMode = .byWordWrapping

        dateTimeLabel.font = ._12RegularFont()
        dateTimeLabel.textColor = .charcoalGrey
        dateTimeLabel.numberOfLines = 5
        dateTimeLabel.textAlignment = .left
        dateTimeLabel.lineBreakMode = .byWordWrapping

        descriptionLabel.font = ._14RegularFont()
        descriptionLabel.textColor = .offBlack
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .left
        descriptionLabel.lineBreakMode = .byTruncatingTail
        
        mainView.addSubview(episodeNameLabel)
        mainView.addSubview(dateTimeLabel)
        mainView.addSubview(descriptionLabel)
        
        podcastImage = ImageView(frame: CGRect(x: 0, y: 0, width: podcastImageSize, height: podcastImageSize))
        mainView.addSubview(podcastImage)
        
        podcastImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(podcastImageY)
            make.leading.equalToSuperview().inset(podcastImageX)
            make.size.equalTo(podcastImageSize)
        }
        
        episodeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(podcastImage.snp.top)
            make.leading.equalToSuperview().inset(episodeNameLabelX)
            make.trailing.equalToSuperview().inset(episodeNameLabelRightX)
        }
        
        dateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeNameLabel.snp.bottom).offset(marginSpacing)
            make.leading.equalTo(episodeNameLabel.snp.leading)
            make.trailing.equalTo(episodeNameLabel.snp.trailing)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(dateTimeLabel.snp.bottom).offset(marginSpacing)
            make.top.greaterThanOrEqualTo(podcastImage.snp.bottom).offset(marginSpacing)
            make.leading.equalToSuperview().inset(descriptionLabelX)
            make.trailing.equalTo(episodeNameLabel.snp.trailing)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(descriptionLabel.snp.bottom)
        }
        
        episodeUtilityButtonBarView.snp.makeConstraints { make in
            make.top.equalTo(mainView.snp.bottom).offset(marginSpacing)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(episodeUtilityButtonBarViewHeight)
            make.bottom.equalToSuperview().inset(separatorHeight)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(episodeUtilityButtonBarView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(separatorHeight)
        }
        
        episodeUtilityButtonBarView.bookmarkButton.addTarget(self, action: #selector(didPressBookmarkButton), for: .touchUpInside)
        episodeUtilityButtonBarView.recommendedButton.addTarget(self, action: #selector(didPressRecommendedButton), for: .touchUpInside)
        episodeUtilityButtonBarView.moreButton.addTarget(self, action: #selector(didPressMoreButton), for: .touchUpInside)
        episodeUtilityButtonBarView.playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
    }
    
    convenience init(episode: Episode) {
        self.init()
        setupWithEpisode(episode: episode)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func prepareForReuse() {
        episodeUtilityButtonBarView.prepareForReuse()
    }
    
    func setupWithEpisode(episode: Episode) {
        episodeNameLabel.text = episode.title
        dateTimeLabel.text = episode.dateTimeSeriesString()
        descriptionLabel.attributedText = episode.attributedDescription
        podcastImage.setImageAsynchronouslyWithDefaultImage(url: episode.smallArtworkImageURL)
        episodeUtilityButtonBarView.setupWithEpisode(episode: episode)
    }

    func updateWithPlayButtonPress(episode: Episode) {
        episodeUtilityButtonBarView.setupWithEpisode(episode: episode)
    }
    
    ///
    ///Mark - Buttons
    ///
    @objc func didPressBookmarkButton() {
        delegate?.episodeSubjectViewDidPressBookmarkButton(episodeSubjectView: self)
    }
    
    @objc func didPressRecommendedButton() {
        delegate?.episodeSubjectViewDidPressRecommendButton(episodeSubjectView: self)
    }
    
    @objc func didPressPlayButton() {
        delegate?.episodeSubjectViewDidPressPlayPauseButton(episodeSubjectView: self)
    }
    
    @objc func didPressMoreButton() {
        delegate?.episodeSubjectViewDidPressMoreActionsButton(episodeSubjectView: self)
    }
    
    @objc func didPressTagButton(button: UIButton) {
        delegate?.episodeSubjectViewDidPressTagButton(episodeSubjectView: self, index: button.tag)
    }
}
