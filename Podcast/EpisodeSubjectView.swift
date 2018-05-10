//
//  EpisodeFeedElementSubjectView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol EpisodeSubjectViewDelegate: class {
    func didPress(on action: EpisodeAction, for view: EpisodeSubjectView)
}

class EpisodeSubjectView: UIView {
    
    static let episodeSubjectViewHeight: CGFloat = 256
    static let episodeUtilityButtonBarViewHeight: CGFloat = EpisodeUtilityButtonBarView.height
    
    ///
    /// Mark: View Constants
    ///
    let separatorHeight: CGFloat = 9
    let episodeNameLabelX: CGFloat = 86.5
    let episodeNameLabelRightX: CGFloat = 21
    let descriptionLabelX: CGFloat = 17.5
    let descriptionLabelOffset: CGFloat = 12
    let podcastImageX: CGFloat = 17.5
    let podcastImageY: CGFloat = 17
    let podcastImageSize: CGFloat = 60
    let tagButtonBottomMargin: CGFloat = 10
    let tagButtonViewHeight: CGFloat = 0
    let episodeUtilityButtonBarViewHeight: CGFloat = EpisodeSubjectView.episodeUtilityButtonBarViewHeight
    let marginSpacing: CGFloat = 6

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
    var greyedOutLabel: UILabel!
    
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
        episodeNameLabel.numberOfLines = 2
        episodeNameLabel.textAlignment = .left
        episodeNameLabel.lineBreakMode = .byTruncatingTail

        dateTimeLabel.font = ._12RegularFont()
        dateTimeLabel.textColor = .slateGrey
        dateTimeLabel.numberOfLines = 2
        dateTimeLabel.textAlignment = .left
        dateTimeLabel.lineBreakMode = .byTruncatingTail

        descriptionLabel.font = ._14RegularFont()
        descriptionLabel.textColor = .charcoalGrey
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textAlignment = .left
        descriptionLabel.lineBreakMode = .byTruncatingTail
        
        mainView.addSubview(episodeNameLabel)
        mainView.addSubview(dateTimeLabel)
        mainView.addSubview(descriptionLabel)

        greyedOutLabel = UILabel()
        greyedOutLabel.backgroundColor = UIColor.lightGrey.withAlphaComponent(0.5)
        greyedOutLabel.isHidden = true
        mainView.addSubview(greyedOutLabel)
        
        podcastImage = ImageView(frame: CGRect(x: 0, y: 0, width: podcastImageSize, height: podcastImageSize))
        podcastImage.addCornerRadius(height: podcastImageSize)
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
            make.top.greaterThanOrEqualTo(podcastImage.snp.bottom).offset(descriptionLabelOffset).priority(999)
            make.top.greaterThanOrEqualTo(dateTimeLabel.snp.bottom).offset(descriptionLabelOffset).priority(999)
            make.leading.equalToSuperview().inset(descriptionLabelX)
            make.trailing.equalTo(episodeNameLabel.snp.trailing)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(descriptionLabel.snp.bottom).offset(descriptionLabelOffset)
        }
        
        episodeUtilityButtonBarView.snp.makeConstraints { make in
            make.top.equalTo(mainView.snp.bottom).offset(marginSpacing)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(episodeUtilityButtonBarViewHeight).priority(999)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(episodeUtilityButtonBarView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(separatorHeight)
        }

        greyedOutLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        episodeUtilityButtonBarView.bookmarkButton.addTarget(self, action: #selector(didPressBookmarkButton), for: .touchUpInside)
        episodeUtilityButtonBarView.recommendedButton.addTarget(self, action: #selector(didPressRecommendedButton), for: .touchUpInside)
        episodeUtilityButtonBarView.moreButton.addTarget(self, action: #selector(didPressMoreButton), for: .touchUpInside)
        episodeUtilityButtonBarView.playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func prepareForReuse() {
        episodeUtilityButtonBarView.prepareForReuse()
    }
    
    func setup(with episode: Episode, downloadStatus: DownloadStatus) {
        episodeNameLabel.text = episode.title
        dateTimeLabel.text = episode.dateTimeLabelString
        // this is to avoid newlines/paragraphs showing up after truncating text
        let stringWithoutNewlines = episode.attributedDescription.string.replacingOccurrences(of: "\n", with: "")
        let mutableString = NSMutableAttributedString(string: stringWithoutNewlines)
        descriptionLabel.attributedText = mutableString.toEpisodeDescriptionStyle(lineBreakMode: .byTruncatingTail)
        podcastImage.setImageAsynchronouslyWithDefaultImage(url: episode.smallArtworkImageURL)
        episodeUtilityButtonBarView.setup(with: episode, downloadStatus)
        greyedOutLabel.isHidden = episode.audioURL != nil
        backgroundColor = episode.audioURL == nil ? UIColor.lightGrey.withAlphaComponent(0.5) : .offWhite
    }

    func updateWithPlayButtonPress(episode: Episode) {
        episodeUtilityButtonBarView.playButton.configure(for: episode)
    }
    
    ///
    ///Mark - Buttons
    ///
    @objc func didPressBookmarkButton() {
        delegate?.didPress(on: .bookmark, for: self)
    }
    
    @objc func didPressRecommendedButton() {
        delegate?.didPress(on: .recast, for: self)
    }
    
    @objc func didPressPlayButton() {
        delegate?.didPress(on: .play, for: self)
    }
    
    @objc func didPressMoreButton() {
        delegate?.didPress(on: .more, for: self)
    }
}
