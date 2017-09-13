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
    
    static let episodeTableViewCellHeight: CGFloat = 253
    static let episodeUtilityButtonBarViewHeight: CGFloat = 48
    
    ///
    /// Mark: View Constants
    ///
    var seperatorHeight: CGFloat = 9
    var episodeNameLabelY: CGFloat = 17
    var episodeNameLabelX: CGFloat = 86.5
    var episodeNameLabelRightX: CGFloat = 21
    var dateTimeLabelX: CGFloat = 86.5
    var descriptionLabelX: CGFloat = 17.5
    var podcastImageX: CGFloat = 17.5
    var podcastImageY: CGFloat = 17
    var podcastImageSize: CGFloat = 60
    var tagButtonBottomMargin: CGFloat = 20
    var episodeUtilityButtonBarViewHeight: CGFloat = EpisodeTableViewCell.episodeUtilityButtonBarViewHeight
    var mainViewHeight: CGFloat = 195
    
    var marginSpacing: CGFloat = 6
    var rightMarginSpacing: CGFloat = 11.5
    
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
        
        mainView.addSubview(episodeNameLabel)
        mainView.addSubview(dateTimeLabel)
        mainView.addSubview(descriptionLabel)
        
        tagButtonsView = TagButtonsView(frame: CGRect.zero)
        mainView.addSubview(tagButtonsView)
        
        episodeNameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        episodeNameLabel.textColor = .podcastBlack
        episodeNameLabel.numberOfLines = 5
        
        dateTimeLabel.font = UIFont.systemFont(ofSize: 12.0)
        dateTimeLabel.textColor = .podcastGrayDark
        dateTimeLabel.numberOfLines = 5
        
        descriptionLabel.textColor = .podcastBlack
        descriptionLabel.numberOfLines = 3
        
        podcastImage = ImageView(frame: CGRect(x: podcastImageX, y: podcastImageY, width: podcastImageSize, height: podcastImageSize))
        mainView.addSubview(podcastImage)
        
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
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.frame = CGRect(x: 0, y: 0, width: frame.width, height: mainViewHeight)
        episodeUtilityButtonBarView.frame = CGRect(x: 0, y: frame.height - episodeUtilityButtonBarViewHeight - seperatorHeight, width: frame.width, height: episodeUtilityButtonBarViewHeight)
        
        episodeNameLabel.frame = CGRect(x: episodeNameLabelX, y: episodeNameLabelY, width: frame.width - episodeNameLabelRightX - episodeNameLabelX, height: 0)
        UILabel.adjustHeightToFit(label: episodeNameLabel)
        dateTimeLabel.frame = CGRect(x: dateTimeLabelX, y: episodeNameLabel.frame.maxY + marginSpacing, width: frame.width - rightMarginSpacing - dateTimeLabelX, height: 0)
        UILabel.adjustHeightToFit(label: dateTimeLabel)
        podcastImage.frame = CGRect(x: podcastImageX, y: podcastImageY, width: podcastImageSize, height: podcastImageSize)
        
        let descriptionLabelY = podcastImage.frame.maxY >  dateTimeLabel.frame.maxY ? podcastImage.frame.maxY + marginSpacing : dateTimeLabel.frame.maxY + marginSpacing
        descriptionLabel.frame = CGRect(x: descriptionLabelX, y: descriptionLabelY, width: frame.width - rightMarginSpacing - descriptionLabelX, height: 0)
        UILabel.adjustHeightToFit(label: descriptionLabel, numberOfLines: 4)
        
        seperator.frame = CGRect(x: 0, y: frame.height - seperatorHeight, width: frame.width, height: seperatorHeight)
        tagButtonsView.frame = CGRect(x: 0, y: episodeUtilityButtonBarView.frame.minY - tagButtonBottomMargin - tagButtonsView.tagButtonHeight, width: frame.width, height: tagButtonsView.tagButtonHeight)
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




