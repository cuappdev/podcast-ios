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
    
    var tagTopConstraint: Constraint?
    var tagHeightContraint: Constraint?
    
    weak var delegate: EpisodeTableViewCellDelegate?
    
    
    ///
    ///Mark: Init
    ///
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .podcastWhite
        selectionStyle = .none
        
        mainView = UIView(frame: CGRect.zero)
        mainView.backgroundColor = .podcastWhite
        contentView.addSubview(mainView)
        
        episodeUtilityButtonBarView = EpisodeUtilityButtonBarView(frame: .zero)
        episodeUtilityButtonBarView.hasTopLineSeperator = true 
        contentView.addSubview(episodeUtilityButtonBarView)
        
        seperator = UIView(frame: CGRect.zero)
        seperator.backgroundColor = .podcastWhiteDark
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
        episodeNameLabel.textColor = .podcastBlack
        episodeNameLabel.numberOfLines = 5
        dateTimeLabel.font = UIFont.systemFont(ofSize: 12.0)
        dateTimeLabel.textColor = .podcastGrayDark
        dateTimeLabel.numberOfLines = 5
        descriptionLabel.textColor = .podcastBlack
        descriptionLabel.numberOfLines = 3
        
        mainView.addSubview(episodeNameLabel)
        mainView.addSubview(dateTimeLabel)
        mainView.addSubview(descriptionLabel)
        
        podcastImage = ImageView(frame: CGRect(x: 0, y: 0, width: podcastImageSize, height: podcastImageSize))
        mainView.addSubview(podcastImage)
        
        podcastImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(podcastImageY)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.size.equalTo(podcastImageSize)
        }
        
        episodeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(podcastImage)
            make.leading.equalTo(episodeNameLabelX)
            make.trailing.equalToSuperview().inset(episodeNameLabelRightX)
        }
        
        dateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeNameLabel).offset(marginSpacing)
            make.leading.equalTo(episodeNameLabel)
            make.trailing.equalTo(episodeNameLabel)
        }
        
        
        
        tagButtonsView = TagButtonsView(frame: .zero)
        mainView.addSubview(tagButtonsView)
        
        
        tagButtonsView.snp.makeConstraints { make in
            tagTopConstraint = make.top.equalTo(descriptionLabel.snp.bottom).constraint
            tagHeightContraint = make.height.equalTo(30).constraint
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
    
    func setupWithEpisode(episode: Episode) {
        episodeNameLabel.text = episode.title
        tagButtonsView.setupTagButtons(tags: episode.tags)
        
        for tagButton in tagButtonsView.tagButtons {
            tagButton.addTarget(self, action: #selector(didPressTagButton(button:)), for: .touchUpInside)
        }
    
        dateTimeLabel.text = episode.dateTimeSeriesString()
        descriptionLabel.attributedText = episode.attributedDescriptionString()
        episodeUtilityButtonBarView.recommendedButton.setTitle(episode.numberOfRecommendations.shortString(), for: .normal)
        if let url = episode.smallArtworkImageURL {
            podcastImage.setImageAsynchronously(url: url, completion: nil)
        } else {
            podcastImage.image = #imageLiteral(resourceName: "nullSeries")
        }
        
        episodeUtilityButtonBarView.bookmarkButton.isSelected = episode.isBookmarked
        episodeUtilityButtonBarView.recommendedButton.isSelected = episode.isRecommended
    }
    
    ///
    ///Mark - Buttons
    ///
    func didPressBookmarkButton() {
        delegate?.episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: self)
    }
    
    func didPressRecommendedButton() {
        delegate?.episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: self)
    }
    
    func didPressPlayButton() {
        delegate?.episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: self)
    }
    
    func didPressMoreButton() {
        delegate?.episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: self)
    }
    
    func didPressTagButton(button: UIButton) {
        delegate?.episodeTableViewCellDidPressTagButton(episodeTableViewCell: self, index: button.tag)
    }
}




