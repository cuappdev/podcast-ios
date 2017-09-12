//
//  EpisodeTableViewCell.swift
//  Podcast
//
//  Created by Drew Dunne on 2/25/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol EpisodeTableViewCellDelegate: class {
    
    func episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: EpisodeTableViewCell)
    func episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: EpisodeTableViewCell)
    func episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: EpisodeTableViewCell)
    func episodeTableViewCellDidPressTagButton(episodeTableViewCell: EpisodeTableViewCell, index: Int)
    func episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: EpisodeTableViewCell)
}

class EpisodeTableViewCell: UITableViewCell {
    
    static let height: CGFloat = 253
    static let utilityButtonBarViewHeight: CGFloat = 48
    
    ///
    /// Mark: View Constants
    ///
    var height: CGFloat = 253
    var seperatorHeight: CGFloat = 9
    var episodeNameLabelY: CGFloat = 27
    var episodeNameLabelX: CGFloat = 86.5
    var episodeNameLabelRightX: CGFloat = 21
    var episodeNameLabelHeight: CGFloat = 18
    var dateTimeLabelX: CGFloat = 86.5
    var dateTimeLabelY: CGFloat = 47.5
    var dateTimeLabelRightX: CGFloat = 18
    var dateTimeLabelHeight: CGFloat = 30
    var descriptionLabelX: CGFloat = 17.5
    var descriptionLabelY: CGFloat = 94
    var descriptionLabelHeight: CGFloat = 54
    var descriptionLabelRightX: CGFloat = 11.5
    var podcastImageX: CGFloat = 17.5
    var podcastImageY: CGFloat = 17
    var podcastImageSize: CGFloat = 60
    var contextLabelX: CGFloat = 17
    var contextLabelHeight: CGFloat = 30
    var contextLabelRightX: CGFloat = 43
    var contextImagesSize: CGFloat = 28
    var feedControlButtonX: CGFloat = 345
    var feedControlButtonHieght: CGFloat = 7.5
    var feedControlButtonWidth: CGFloat = 13
    var tagButtonsViewY: CGFloat = 160.5
    var utilityButtonBarViewHeight: CGFloat = EpisodeTableViewCell.utilityButtonBarViewHeight
    var mainViewHeight: CGFloat = 195
    
    ///
    /// Mark: Variables
    ///
    var episodeNameLabel: UILabel!
    var dateTimeLabel: UILabel!
    var descriptionLabel: UILabel!
    var seperator: UIView!
    var podcastImage: ImageView!
    var mainView: UIView! //main view
    var utilityButtonBarView: EpisodeUtilityButtonBarView! //bottom bar view with buttons
    var tagButtonsView: TagButtonsView!
    
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
        
        utilityButtonBarView = EpisodeUtilityButtonBarView(frame: .zero)
        utilityButtonBarView.hasTopLineSeperator = true 
        contentView.addSubview(utilityButtonBarView)
        
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
        
        mainView.addSubview(episodeNameLabel)
        mainView.addSubview(dateTimeLabel)
        mainView.addSubview(descriptionLabel)
        
        tagButtonsView = TagButtonsView(frame: CGRect.zero)
        mainView.addSubview(tagButtonsView)
        
        episodeNameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        episodeNameLabel.textColor = .podcastBlack
        
        
        dateTimeLabel.font = UIFont.systemFont(ofSize: 12.0)
        dateTimeLabel.textColor = .podcastGrayDark
        dateTimeLabel.numberOfLines = 2
        
        descriptionLabel.textColor = .podcastBlack
        descriptionLabel.numberOfLines = 3
        
        podcastImage = ImageView(frame: CGRect(x: podcastImageX, y: podcastImageY, width: podcastImageSize, height: podcastImageSize))
        mainView.addSubview(podcastImage)
        
        utilityButtonBarView.bookmarkButton.addTarget(self, action: #selector(didPressBookmarkButton), for: .touchUpInside)
        utilityButtonBarView.recommendedButton.addTarget(self, action: #selector(didPressRecommendedButton), for: .touchUpInside)
        utilityButtonBarView.moreButton.addTarget(self, action: #selector(didPressMoreButton), for: .touchUpInside)
        utilityButtonBarView.playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagButtonsView.prepareForReuse()
        utilityButtonBarView.prepareForReuse()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.frame = CGRect(x: 0, y: 0, width: frame.width, height: mainViewHeight)
        utilityButtonBarView.frame = CGRect(x: 0, y: mainViewHeight, width: frame.width, height: utilityButtonBarViewHeight)
        
        episodeNameLabel.frame = CGRect(x: episodeNameLabelX, y: episodeNameLabelY, width: frame.width - episodeNameLabelRightX - episodeNameLabelX, height: episodeNameLabelHeight)
        dateTimeLabel.frame = CGRect(x: dateTimeLabelX, y: dateTimeLabelY, width: frame.width - dateTimeLabelRightX - dateTimeLabelX, height: dateTimeLabelHeight)
        descriptionLabel.frame = CGRect(x: descriptionLabelX, y: descriptionLabelY, width: frame.width - descriptionLabelRightX - descriptionLabelX, height: descriptionLabelHeight)
        
        seperator.frame = CGRect(x: 0, y: frame.height - seperatorHeight, width: frame.width, height: seperatorHeight)
        
        tagButtonsView.frame = CGRect(x: 0, y: tagButtonsViewY, width: frame.width, height: tagButtonsView.tagButtonHeight)
    }
    
    func setupWithEpisode(episode: Episode) {
        episodeNameLabel.text = episode.title
        tagButtonsView.setupTagButtons(tags: episode.tags)
        
        for tagButton in tagButtonsView.tagButtons {
            tagButton.addTarget(self, action: #selector(didPressTagButton(button:)), for: .touchUpInside)
        }
    
        dateTimeLabel.text = episode.dateTimeSeriesString()
        descriptionLabel.attributedText = episode.attributedDescriptionString()
        utilityButtonBarView.recommendedButton.setTitle(episode.numberOfRecommendations.shortString(), for: .normal)
        if let url = episode.smallArtworkImageURL {
            podcastImage.setImageAsynchronously(url: url, completion: nil)
        } else {
            podcastImage.image = #imageLiteral(resourceName: "nullSeries")
        }
        
        utilityButtonBarView.bookmarkButton.isSelected = episode.isBookmarked
        utilityButtonBarView.recommendedButton.isSelected = episode.isRecommended
    }
    
    ///
    ///Mark - Buttons
    ///
    func didPressBookmarkButton() {
        delegate?.episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: self)
    }
    
    func setBookmarkButtonToState(isBookmarked: Bool) {
        utilityButtonBarView.bookmarkButton.isSelected = isBookmarked
    }
    
    func didPressRecommendedButton() {
        delegate?.episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: self)
    }
    
    func setRecommendedButtonToState(isRecommended: Bool) {
        utilityButtonBarView.recommendedButton.isSelected = isRecommended
    }
    
    func didPressPlayButton() {
        delegate?.episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: self)
    }
    
    func setPlayButtonToState(isPlaying: Bool) {
        utilityButtonBarView.playButton.isSelected = isPlaying
    }
    
    func didPressMoreButton() {
        delegate?.episodeTableViewCellDidPressMoreActionsButton(episodeTableViewCell: self)
    }
    
    
    func didPressFeedControlButton() {
        
    }
    
    func didPressTagButton(button: UIButton) {
        delegate?.episodeTableViewCellDidPressTagButton(episodeTableViewCell: self, index: button.tag)
    }
}




