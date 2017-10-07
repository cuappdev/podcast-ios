//
//  EpisodeTableViewCell.swift
//  Podcast
//
//  Created by Drew Dunne on 2/25/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

protocol EpisodeTableViewCellDelegate: class {
    
    func episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: EpisodeTableViewCell)
    func episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell)
    func episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell)
    func episodeTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, index: Int)
    func episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: EpisodeTableViewCell)
}

class EpisodeTableViewCell: UITableViewCell {
    
    static let episodeTableViewCellHeight: CGFloat = 253
    static let episodeUtilityButtonBarViewHeight: CGFloat = 48
    
    ///
    /// Mark: View Constants
    ///
    var seperatorHeight: CGFloat = 9
    var episodeNameLabelX: CGFloat = 86.5
    var episodeNameLabelRightX: CGFloat = 21
    var descriptionLabelX: CGFloat = 17.5
    var podcastImageX: CGFloat = 17.5
    var podcastImageY: CGFloat = 17
    var podcastImageSize: CGFloat = 60
    var tagButtonBottomMargin: CGFloat = 10
    var tagButtonViewHeight: CGFloat = 0
    var episodeUtilityButtonBarViewHeight: CGFloat = EpisodeTableViewCell.episodeUtilityButtonBarViewHeight
    
    var marginSpacing: CGFloat = 6
    
    ///
    /// Mark: Variables
    ///
    var episodeNameLabel: UILabel!
    var dateTimeLabel: UILabel!
    var descriptionLabel: UILabel!
    var seperator: UIView!
    var podcastImage: ImageView!
    var mainView: UIView! //main view
    var episodeUtilityButtonBarView: EpisodeUtilityButtonBarView! //bottom bar view with buttons
    var tagButtonsView: TagButtonsView!
    
    weak var delegate: EpisodeTableViewCellDelegate?
    
    
    ///
    ///Mark: Init
    ///
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .offWhite
        selectionStyle = .none
        
        mainView = UIView(frame: CGRect.zero)
        mainView.backgroundColor = .offWhite
        contentView.addSubview(mainView)
        
        episodeUtilityButtonBarView = EpisodeUtilityButtonBarView(frame: .zero)
        episodeUtilityButtonBarView.hasTopLineSeperator = true 
        contentView.addSubview(episodeUtilityButtonBarView)
        
        seperator = UIView(frame: CGRect.zero)
        seperator.backgroundColor = .paleGrey
        contentView.addSubview(seperator)
        
        episodeNameLabel = UILabel(frame: CGRect.zero)
        dateTimeLabel = UILabel(frame: CGRect.zero)
        descriptionLabel = UILabel(frame: CGRect.zero)
        
        let labels: [UILabel] = [episodeNameLabel, dateTimeLabel, descriptionLabel]
        for label in labels {
            label.textAlignment = .left
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont.systemFont(ofSize: 14.0)
        }
        episodeNameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        episodeNameLabel.textColor = .offBlack
        episodeNameLabel.numberOfLines = 5
        dateTimeLabel.font = UIFont.systemFont(ofSize: 12.0)
        dateTimeLabel.textColor = .charcoalGrey
        dateTimeLabel.numberOfLines = 5
        descriptionLabel.textColor = .offBlack
        descriptionLabel.numberOfLines = 3
        
        mainView.addSubview(episodeNameLabel)
        mainView.addSubview(dateTimeLabel)
        mainView.addSubview(descriptionLabel)
        
        podcastImage = ImageView(frame: CGRect(x: 0, y: 0, width: podcastImageSize, height: podcastImageSize))
        mainView.addSubview(podcastImage)
        
        tagButtonsView = TagButtonsView()
        mainView.addSubview(tagButtonsView)
        
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
    
        tagButtonsView.snp.makeConstraints{ make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(marginSpacing)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(tagButtonViewHeight)
        }
        
        mainView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(tagButtonsView.snp.bottom)
        }
        
        episodeUtilityButtonBarView.snp.makeConstraints { make in
            make.top.equalTo(tagButtonsView.snp.bottom).offset(marginSpacing)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(episodeUtilityButtonBarViewHeight)
            make.bottom.equalToSuperview().inset(seperatorHeight)
        }
        
        seperator.snp.makeConstraints { make in
            make.top.equalTo(episodeUtilityButtonBarView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(seperatorHeight)
        }
        
        episodeUtilityButtonBarView.bookmarkButton.addTarget(self, action: #selector(didPressBookmarkButton), for: .touchUpInside)
        episodeUtilityButtonBarView.recommendedButton.addTarget(self, action: #selector(didPressRecommendedButton), for: .touchUpInside)
        episodeUtilityButtonBarView.moreButton.addTarget(self, action: #selector(didPressMoreButton), for: .touchUpInside)
        episodeUtilityButtonBarView.playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        tagButtonsView.prepareForReuse()
        episodeUtilityButtonBarView.prepareForReuse() 
    }

    func updateConstraintsWithEpisode(episode: Episode) {
        if episode.tags.isEmpty {
            tagButtonViewHeight = 0
        } else {
            tagButtonViewHeight = tagButtonsView.tagButtonHeight
        }
        updateConstraints()
    }
    
    override func updateConstraints() {
        tagButtonsView.snp.updateConstraints { make in
            make.height.equalTo(tagButtonViewHeight)
        }
        super.updateConstraints()
    }
    
    func setupWithEpisode(episode: Episode) {
        episodeNameLabel.text = episode.title
        
        updateConstraintsWithEpisode(episode: episode)
        tagButtonsView.setupTagButtons(tags: episode.tags)
        
        for tagButton in tagButtonsView.tagButtons {
            tagButton.addTarget(self, action: #selector(didPressTagButton(button:)), for: .touchUpInside)
        }
    
        dateTimeLabel.text = episode.dateTimeSeriesString()
        descriptionLabel.attributedText = episode.attributedDescriptionString()
        episodeUtilityButtonBarView.recommendedButton.setTitle(episode.numberOfRecommendations.shortString(), for: .normal)
        podcastImage.setImageAsynchronouslyWithDefaultImage(url: episode.smallArtworkImageURL)
        episodeUtilityButtonBarView.bookmarkButton.isSelected = episode.isBookmarked
        episodeUtilityButtonBarView.recommendedButton.isSelected = episode.isRecommended
    }
    
    ///
    ///Mark - Buttons
    ///
    @objc func didPressBookmarkButton() {
        delegate?.episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: self)
    }
    
    @objc func didPressRecommendedButton() {
        delegate?.episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: self)
    }
    
    @objc func didPressPlayButton() {
        delegate?.episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: self)
    }
    
    @objc func didPressMoreButton() {
        delegate?.episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: self)
    }
    
    @objc func didPressTagButton(button: UIButton) {
        delegate?.episodeTableViewCellDidPressTagButton(episodeTableViewCell: self, index: button.tag)
    }
}




