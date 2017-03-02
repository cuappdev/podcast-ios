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
}

class EpisodeTableViewCell: UITableViewCell {
    
    ///
    /// Mark: View Constants
    ///
    static let height: CGFloat = 253
    let height: CGFloat = EpisodeTableViewCell.height
    var seperatorHeight: CGFloat = 9
    var episodeNameLabelY: CGFloat = 27
    var episodeNameLabelX: CGFloat = 86.5
    var episodeNameLabelRightX: CGFloat = 21
    var episodeNameLabelHeight: CGFloat = 18
    var dateTimeLabelX: CGFloat = 86.5
    var dateTimeLabelY: CGFloat = 47.5
    var dateTimeLabelHeight: CGFloat = 14.5
    var descriptionLabelX: CGFloat = 17.5
    var descriptionLabelY: CGFloat = 94
    var descriptionLabelHeight: CGFloat = 54
    var descriptionLabelRightX: CGFloat = 11.5
    var recommendedLabelHeight: CGFloat = 18
    var podcastImageX: CGFloat = 17.5
    var podcastImageY: CGFloat = 17
    var podcastImageSize: CGFloat = 60
    var bookmarkButtonX: CGFloat = 304
    var bookmarkButtonHeight: CGFloat = 18
    var bookmarkButtonWidth: CGFloat = 12
    var recommendedButtonWidth: CGFloat = 16
    var recommendedButtonHeight: CGFloat = 16
    var recommendedButtonX: CGFloat = 233
    var buttonPadding: CGFloat = 10
    var lineSeperatorX: CGFloat = 18
    var lineSeperatorHeight: CGFloat = 1
    var playButtonX: CGFloat = 19.5
    var playButtonWidth: CGFloat = 11
    var playButtonHeight: CGFloat = 13.5
    var moreButtonX: CGFloat = 342
    var moreButtonHeight: CGFloat = 3
    var moreButtonWidth: CGFloat = 15
    var contextLabelX: CGFloat = 17
    var contextLabelHeight: CGFloat = 30
    var contextLabelRightX: CGFloat = 43
    var contextImagesSize: CGFloat = 28
    var feedControlButtonX: CGFloat = 345
    var feedControlButtonHieght: CGFloat = 7.5
    var feedControlButtonWidth: CGFloat = 13
    var tagButtonsViewY: CGFloat = 160.5
    
//    var contextViewHeight: CGFloat = 52
    var bottomViewHeight: CGFloat = 48
    var mainViewHeight: CGFloat = 195
    
    ///
    /// Mark: Variables
    ///
    var heightConstraint: NSLayoutConstraint!
    var episodeNameLabel: UILabel!
    var dateTimeLabel: UILabel!
    var descriptionLabel: UILabel!
    var recommendedLabel: UILabel!
    var recommendedButton: UIButton!
    var bookmarkButton: UIButton!
    var moreInfoButton: UIButton!
    var seperator: UIView!
    var podcastImage: UIImageView!
    var lineSeperator: UIView!
    var topLineSeperator: UIView!
    var moreButton: UIButton!
    var playButton: UIButton!
    var playLabel: UILabel!
    var contextLabel: UILabel!
    var contextImages: [UIImageView] = []
    var mainView: UIView! //main view
    var bottomView: UIView! //bottom bar view with buttons
    var tagButtonsView: TagButtonsView!
    
    var cardID: Int?
    
    weak var delegate: EpisodeTableViewCellDelegate?
    
    
    ///
    ///Mark: Init
    ///
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        frame.size.height = height
        
        backgroundColor = .podcastWhite
        selectionStyle = .none
        
        mainView = UIView(frame: CGRect.zero)
        mainView.backgroundColor = .podcastWhite
        contentView.addSubview(mainView)
        
        bottomView = UIView(frame: CGRect.zero)
        bottomView.backgroundColor = .podcastWhite
        contentView.addSubview(bottomView)
        
        seperator = UIView(frame: CGRect.zero)
        seperator.backgroundColor = .podcastGray
        contentView.addSubview(seperator)
        
        lineSeperator = UIView(frame: CGRect.zero)
        lineSeperator.backgroundColor = .podcastGray
        mainView.addSubview(lineSeperator)
        
        topLineSeperator = UIView(frame: CGRect.zero)
        topLineSeperator.backgroundColor = .podcastGray
        mainView.addSubview(topLineSeperator)
        
        episodeNameLabel = UILabel(frame: CGRect.zero)
        dateTimeLabel = UILabel(frame: CGRect.zero)
        descriptionLabel = UILabel(frame: CGRect.zero)
        recommendedLabel = UILabel(frame: CGRect.zero)
        playLabel = UILabel(frame: CGRect.zero)
        
        
        let labels: [UILabel] = [episodeNameLabel, dateTimeLabel, descriptionLabel, recommendedLabel, playLabel]
        for label in labels {
            label.textAlignment = .left
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont.systemFont(ofSize: 14.0)
        }
        
        mainView.addSubview(episodeNameLabel)
        mainView.addSubview(dateTimeLabel)
        mainView.addSubview(descriptionLabel)
        bottomView.addSubview(recommendedLabel)
        bottomView.addSubview(playLabel)
        
        tagButtonsView = TagButtonsView(frame: CGRect.zero)
        mainView.addSubview(tagButtonsView)
        
        episodeNameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        episodeNameLabel.textColor = .podcastBlack
        
        
        dateTimeLabel.font = UIFont.systemFont(ofSize: 12.0)
        dateTimeLabel.textColor = .podcastGrayDark
        
        descriptionLabel.textColor = .podcastBlack
        descriptionLabel.numberOfLines = 3
        
        recommendedLabel.font = UIFont.systemFont(ofSize: 12.0)
        recommendedLabel.textColor = .podcastGrayDark
        
        playLabel.textColor = .podcastBlueLight
        playLabel.font = UIFont.systemFont(ofSize: 12.0)
        playLabel.text = "Play"
        
        podcastImage = UIImageView(frame: CGRect.zero)
        mainView.addSubview(podcastImage)
        
        bookmarkButton = UIButton(frame: CGRect.zero)
        bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_feed_icon_unselected"), for: UIControlState())
        bookmarkButton.addTarget(self, action: #selector(didPressBookmarkButton), for: .touchUpInside)
        bottomView.addSubview(bookmarkButton)
        
        recommendedButton = UIButton(frame: CGRect.zero)
        recommendedButton.setImage(#imageLiteral(resourceName: "heart_icon"), for: UIControlState())
        recommendedButton.addTarget(self, action: #selector(didPressRecommendedButton), for: .touchUpInside)
        bottomView.addSubview(recommendedButton)
        
        moreButton = UIButton(frame: CGRect.zero)
        moreButton.setImage(#imageLiteral(resourceName: "more_icon"), for: UIControlState())
        moreButton.addTarget(self, action: #selector(didPressMoreButton), for: .touchUpInside)
        bottomView.addSubview(moreButton)
        
        playButton = UIButton(frame: CGRect.zero)
        playButton.setImage(#imageLiteral(resourceName: "play_feed_icon"), for: UIControlState())
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        bottomView.addSubview(playButton)
        
        heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
        contentView.addConstraint(heightConstraint!)
        NSLayoutConstraint.activate([heightConstraint])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for imageView in contextImages {
            imageView.removeFromSuperview()
        }
        
        contextImages = []
        playButton.setImage(#imageLiteral(resourceName: "play_feed_icon"), for: .normal)
        playLabel.text = "Play"
        recommendedButton.setImage(#imageLiteral(resourceName: "heart_icon"), for: .normal)
        bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_feed_icon_selected"), for: .normal)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.frame = CGRect(x: 0, y: 0, width: frame.width, height: mainViewHeight)
        bottomView.frame = CGRect(x: 0, y: mainViewHeight, width: frame.width, height: bottomViewHeight)
        
        episodeNameLabel.frame = CGRect(x: episodeNameLabelX, y: episodeNameLabelY, width: frame.width - episodeNameLabelRightX - episodeNameLabelX, height: episodeNameLabelHeight)
        dateTimeLabel.frame = CGRect(x: dateTimeLabelX, y: dateTimeLabelY, width: frame.width, height: dateTimeLabelHeight)
        descriptionLabel.frame = CGRect(x: descriptionLabelX, y: descriptionLabelY, width: frame.width - descriptionLabelRightX - descriptionLabelX, height: descriptionLabelHeight)
        podcastImage.frame = CGRect(x: podcastImageX, y: podcastImageY, width: podcastImageSize, height: podcastImageSize)
        
        recommendedLabel.sizeToFit()
        bookmarkButton.frame = CGRect(x: bookmarkButtonX, y: 0, width: bookmarkButtonWidth, height: bookmarkButtonHeight)
        recommendedButton.frame = CGRect(x: recommendedButtonX, y: 0, width: recommendedButtonWidth, height: recommendedButtonHeight)
        recommendedButton.center.y = bottomViewHeight / 2
        bookmarkButton.center.y = bottomViewHeight / 2
        playButton.frame = CGRect(x: playButtonX, y: 0, width: playButtonWidth, height: playButtonHeight)
        moreButton.frame = CGRect(x: moreButtonX, y: 0, width: moreButtonWidth, height: moreButtonHeight)
        playButton.center.y = bottomViewHeight / 2
        moreButton.center.y = bottomViewHeight / 2
        recommendedLabel.center.y = bottomViewHeight / 2
        recommendedLabel.frame.origin.x = recommendedButton.frame.origin.x + buttonPadding + recommendedButton.frame.width
        playLabel.frame = CGRect(x: playButtonX + playButtonWidth + buttonPadding, y: 0, width: 0, height: 0)
        playLabel.sizeToFit()
        playLabel.center.y = bottomViewHeight / 2
        
        lineSeperator.frame = CGRect(x: lineSeperatorX, y: mainViewHeight - 1, width: frame.width - 2 * lineSeperatorX, height: lineSeperatorHeight)
        topLineSeperator.frame = CGRect(x: 0, y: 0, width: frame.width, height: lineSeperatorHeight)
        seperator.frame = CGRect(x: 0, y: frame.height - seperatorHeight, width: frame.width, height: seperatorHeight)
        
        tagButtonsView.frame = CGRect(x: 0, y: tagButtonsViewY, width: frame.width, height: tagButtonsView.tagButtonHeight)
    }
    
    func setupWithEpisode(episode: Episode) {
        
        episodeNameLabel.text = episode.title
        
        tagButtonsView.setupTagButtons(tags: episode.tags)
        
        for tagButton in tagButtonsView.tagButtons {
            tagButton.addTarget(self, action: #selector(didPressTagButton(button:)), for: .touchUpInside)
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateTimeLabel.text = dateFormatter.string(from: episode.dateCreated! as Date)
        dateTimeLabel.text = dateTimeLabel.text! + " • " + String(episode.duration) + " min"
        if episode.seriesTitle != "" {
            dateTimeLabel.text = dateTimeLabel.text! + " • " + episode.seriesTitle
        }
        descriptionLabel.text = episode.descriptionText
        recommendedLabel.text = String(episode.numberOfRecommendations)
        podcastImage.image = episode.smallArtworkImage
        
        if episode.isBookmarked == true {
            bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_feed_icon_selected"), for: .normal)
        }
        if episode.isRecommended == true {
            recommendedButton.setImage(#imageLiteral(resourceName: "heart_icon_selected"), for: .normal)
        }
        if episode.isPlaying == true {
            playButton.setImage(#imageLiteral(resourceName: "play_feed_icon_selected"), for: .normal)
            playLabel.text = "Now Playing"
        }
        
        cardID = episode.id
    }
    
    ///
    ///Mark - Buttons
    ///
    func didPressBookmarkButton() {
        delegate?.episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: self)
    }
    
    func setBookmarkButtonState(isBookmarked: Bool) {
        if isBookmarked {
            bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_feed_icon_selected"), for: .normal)
        } else {
            bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_feed_icon_unselected"), for: .normal)
        }
    }
    
    func didPressRecommendedButton() {
        delegate?.episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: self)
    }
    
    func setRecommendedButtonState(isRecommended: Bool) {
        if isRecommended {
            recommendedButton.setImage(#imageLiteral(resourceName: "heart_icon_selected"), for: .normal)
        } else {
            recommendedButton.setImage(#imageLiteral(resourceName: "heart_icon"), for: .normal)
        }
    }
    
    func didPressPlayButton() {
        delegate?.episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: self)
    }
    
    func setPlayButtonState(isPlaying: Bool) {
        if isPlaying {
            playButton.setImage(#imageLiteral(resourceName: "play_feed_icon_selected"), for: .normal)
            playLabel.text = "Now Playing"
            playLabel.sizeToFit()
        } else {
            playButton.setImage(#imageLiteral(resourceName: "play_feed_icon"), for: .normal)
            playLabel.text = "Play"
        }
    }
    
    func didPressMoreButton() {
        
    }
    
    func didPressTagButton(button: UIButton) {
        
    }
    
}




