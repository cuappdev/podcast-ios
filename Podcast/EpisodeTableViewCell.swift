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
    static let bottomViewHeight: CGFloat = 48
    
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
    
    var bookmarkButtonHeight: CGFloat = EpisodeTableViewCell.bottomViewHeight
    var bookmarkButtonWidth: CGFloat = 23
    
    var recommendedButtonWidth: CGFloat = 60
    var recommendedButtonHeight: CGFloat = EpisodeTableViewCell.bottomViewHeight
    var recommendedButtonRightX: CGFloat = 70

    var buttonPadding: CGFloat = 10
    let bottomViewInnerPadding: CGFloat = 18
    
    var lineSeperatorX: CGFloat = 18
    var lineSeperatorHeight: CGFloat = 1
    
    var playButtonX: CGFloat = 18
    var playButtonWidth: CGFloat = 75
    var playButtonHeight: CGFloat = EpisodeTableViewCell.bottomViewHeight
    
    let moreButtonHeight: CGFloat = EpisodeTableViewCell.bottomViewHeight
    let moreButtonWidth: CGFloat = 23
    
    var contextLabelX: CGFloat = 17
    var contextLabelHeight: CGFloat = 30
    var contextLabelRightX: CGFloat = 43
    var contextImagesSize: CGFloat = 28
    var feedControlButtonX: CGFloat = 345
    var feedControlButtonHieght: CGFloat = 7.5
    var feedControlButtonWidth: CGFloat = 13
    var tagButtonsViewY: CGFloat = 160.5
    var bottomViewHeight: CGFloat = EpisodeTableViewCell.bottomViewHeight
    var mainViewHeight: CGFloat = 195
    
    ///
    /// Mark: Variables
    ///
    var episodeNameLabel: UILabel!
    var dateTimeLabel: UILabel!
    var descriptionLabel: UILabel!
    var recommendedButton: RecommendButton!
    var bookmarkButton: BookmarkButton!
    var seperator: UIView!
    var podcastImage: UIImageView!
    var lineSeperator: UIView!
    var bottomLineSeperator: UIView!
    var moreButton: MoreButton!
    var playButton: PlayButton!
    var mainView: UIView! //main view
    var bottomView: UIView! //bottom bar view with buttons
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
        
        bottomView = UIView(frame: CGRect.zero)
        bottomView.backgroundColor = .podcastWhite
        contentView.addSubview(bottomView)
        
        seperator = UIView(frame: CGRect.zero)
        seperator.backgroundColor = .podcastWhiteDark
        contentView.addSubview(seperator)
        
        lineSeperator = UIView(frame: CGRect.zero)
        lineSeperator.backgroundColor = .podcastGray
        mainView.addSubview(lineSeperator)
        
        bottomLineSeperator = UIView(frame: CGRect.zero)
        bottomLineSeperator.backgroundColor = .podcastGray
        mainView.addSubview(bottomLineSeperator)
        
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
        
        podcastImage = UIImageView(frame: CGRect.zero)
        mainView.addSubview(podcastImage)
        
        bookmarkButton = BookmarkButton(frame: .zero)
        recommendedButton = RecommendButton(frame: .zero)
        moreButton = MoreButton(frame: .zero)
        playButton = PlayButton(frame: .zero)
        
        bookmarkButton.addTarget(self, action: #selector(didPressBookmarkButton), for: .touchUpInside)
        recommendedButton.addTarget(self, action: #selector(didPressRecommendedButton), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(didPressMoreButton), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        
        bottomView.addSubview(bookmarkButton)
        bottomView.addSubview(recommendedButton)
        bottomView.addSubview(moreButton)
        bottomView.addSubview(playButton)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tagButtonsView.prepareForReuse()
        playButton.isSelected = false
        recommendedButton.isSelected = false
        bookmarkButton.isSelected = false
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.frame = CGRect(x: 0, y: 0, width: frame.width, height: mainViewHeight)
        bottomView.frame = CGRect(x: 0, y: mainViewHeight, width: frame.width, height: bottomViewHeight)
        
        episodeNameLabel.frame = CGRect(x: episodeNameLabelX, y: episodeNameLabelY, width: frame.width - episodeNameLabelRightX - episodeNameLabelX, height: episodeNameLabelHeight)
        dateTimeLabel.frame = CGRect(x: dateTimeLabelX, y: dateTimeLabelY, width: frame.width - dateTimeLabelRightX - dateTimeLabelX, height: dateTimeLabelHeight)
        descriptionLabel.frame = CGRect(x: descriptionLabelX, y: descriptionLabelY, width: frame.width - descriptionLabelRightX - descriptionLabelX, height: descriptionLabelHeight)
        podcastImage.frame = CGRect(x: podcastImageX, y: podcastImageY, width: podcastImageSize, height: podcastImageSize)
        
        playButton.frame = CGRect(x: playButtonX, y: 0, width: playButtonWidth, height: playButtonHeight)
        moreButton.frame = CGRect(x: frame.width - bottomViewInnerPadding - moreButtonWidth, y: 0, width: moreButtonWidth, height: moreButtonHeight)
        bookmarkButton.frame = CGRect(x: moreButton.frame.minX - bookmarkButtonWidth - buttonPadding, y: 0, width: bookmarkButtonWidth, height: bookmarkButtonHeight)
        recommendedButton.frame = CGRect(x: frame.width - recommendedButtonRightX - recommendedButtonWidth, y: 0, width: recommendedButtonWidth, height: recommendedButtonHeight)
        
        lineSeperator.frame = CGRect(x: lineSeperatorX, y: mainViewHeight - 1, width: frame.width - 2 * lineSeperatorX, height: lineSeperatorHeight)
        bottomLineSeperator.frame = CGRect(x: 0, y: frame.height - seperatorHeight - lineSeperatorHeight, width: frame.width, height: lineSeperatorHeight)
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
        recommendedButton.setTitle(episode.numberOfRecommendations.shortString(), for: .normal)
        if let url = episode.smallArtworkImageURL {
            if let data = try? Data(contentsOf: url) {
                podcastImage.image = UIImage(data: data)
            }
        } else {
            podcastImage.image = #imageLiteral(resourceName: "nullSeries")
        }
        
        bookmarkButton.isSelected = episode.isBookmarked
        recommendedButton.isSelected = episode.isRecommended
    }
    
    ///
    ///Mark - Buttons
    ///
    func didPressBookmarkButton() {
        delegate?.episodeTableViewCellDidPressBookmarkButton(episodeTableViewCell: self)
    }
    
    func setBookmarkButtonToState(isBookmarked: Bool) {
        bookmarkButton.isSelected = isBookmarked
    }
    
    func didPressRecommendedButton() {
        delegate?.episodeTableViewCellDidPressRecommendButton(episodeTableViewCell: self)
    }
    
    func setRecommendedButtonToState(isRecommended: Bool) {
        recommendedButton.isSelected = isRecommended
    }
    
    func didPressPlayButton() {
        delegate?.episodeTableViewCellDidPressPlayPauseButton(episodeTableViewCell: self)
    }
    
    func setPlayButtonToState(isPlaying: Bool) {
        playButton.isSelected = isPlaying
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




