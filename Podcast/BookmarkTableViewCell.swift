//
//  BookmarksTableViewCell.swift
//  Podcast
//
//  Created by Drew Dunne on 3/20/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol BookmarkTableViewCellDelegate: class {
    func bookmarkTableViewCellDidPressPlayPauseButton(bookmarksTableViewCell: BookmarkTableViewCell)
    func bookmarkTableViewCellDidPressRecommendButton(bookmarksTableViewCell: BookmarkTableViewCell)
    func bookmarkTableViewCellDidPressMoreActionsButton(bookmarksTableViewCell: BookmarkTableViewCell)
}

class BookmarkTableViewCell: UITableViewCell {

    ///
    /// Mark: View Constants
    ///
    static let height: CGFloat = 96
    let height: CGFloat = BookmarkTableViewCell.height
    let separatorHeight: CGFloat = 1
    let padding: CGFloat = 18
    let episodeImageSideLength: CGFloat = 60
    let episodeNameLabelY: CGFloat = 18
    let episodeNameLabelX: CGFloat = 90
    let episodeNameLabelHeight: CGFloat = 21
    let dateTimeLabelX: CGFloat = 90
    let dateTimeLabelY: CGFloat = 41.5
    let dateTimeLabelHeight: CGFloat = 14.5
    
    let playButtonX: CGFloat = 90
    let playButtonBottomY: CGFloat = 18
    let playButtonHeight: CGFloat = 15
    let playButtonWidth: CGFloat = 75
    
    let recommendedButtonX: CGFloat = 148
    let recommendedButtonXPlaying: CGFloat = 168
    let recommendedButtonBottomY: CGFloat = 18
    let recommendedButtonHeight: CGFloat = 15
    let recommendedButtonWidth: CGFloat = 60
    
    let moreButtonRightX: CGFloat = 18
    let moreButtonBottomY: CGFloat = 18
    let moreButtonHeight: CGFloat = 15
    let moreButtonWidth: CGFloat = 15
    
    ///
    /// Mark: Variables
    ///
    var heightConstraint: NSLayoutConstraint!
    var episodeImage: UIImageView!
    var episodeNameLabel: UILabel!
    var dateTimeLabel: UILabel!
    var recommendedButton: RecommendButton!
    var moreButton: MoreButton!
    var playButton: PlayButton!
    var separator: UIView!
    
    weak var delegate: BookmarkTableViewCellDelegate?
    
    
    ///
    ///Mark: Init
    ///
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .podcastWhite
        selectionStyle = .none
        
        separator = UIView(frame: CGRect.zero)
        separator.backgroundColor = .podcastWhiteDark
        contentView.addSubview(separator)
        
        episodeImage = UIImageView(frame: CGRect.zero)
        addSubview(episodeImage)
        
        episodeNameLabel = UILabel(frame: CGRect.zero)
        episodeNameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        episodeNameLabel.textColor = .podcastBlack
        episodeNameLabel.textAlignment = .left
        episodeNameLabel.lineBreakMode = .byTruncatingTail
        episodeNameLabel.numberOfLines = 1
        addSubview(episodeNameLabel)
        
        dateTimeLabel = UILabel(frame: CGRect.zero)
        dateTimeLabel.font = UIFont.systemFont(ofSize: 12.0)
        dateTimeLabel.textColor = .podcastGrayDark
        dateTimeLabel.textAlignment = .left
        dateTimeLabel.lineBreakMode = .byTruncatingTail
        dateTimeLabel.numberOfLines = 1
        addSubview(dateTimeLabel)
        
        playButton = PlayButton(frame: .zero)
        recommendedButton = RecommendButton(frame: .zero)
        moreButton = MoreButton(frame: .zero)
        
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        recommendedButton.addTarget(self, action: #selector(didPressRecommendedButton), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(didPressMoreButton), for: .touchUpInside)
        
        addSubview(playButton)
        addSubview(recommendedButton)
        addSubview(moreButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playButton.isEnabled = true
        recommendedButton.isSelected = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        episodeNameLabel.frame = CGRect(x: episodeNameLabelX, y: episodeNameLabelY, width: frame.width - padding - episodeNameLabelX, height: episodeNameLabelHeight)
        dateTimeLabel.frame = CGRect(x: dateTimeLabelX, y: dateTimeLabelY, width: frame.width - dateTimeLabelX - padding, height: dateTimeLabelHeight)
        episodeImage.frame = CGRect(x: padding, y: padding, width: episodeImageSideLength, height: episodeImageSideLength)
        
        playButton.frame = CGRect(x: playButtonX, y: frame.height - playButtonBottomY - playButtonHeight, width: playButtonWidth, height: playButtonHeight)
        if playButton.isSelected {
            recommendedButton.frame = CGRect(x: recommendedButtonXPlaying, y: frame.height - recommendedButtonBottomY - recommendedButtonHeight, width: recommendedButtonWidth, height: recommendedButtonHeight)
        } else {
            recommendedButton.frame = CGRect(x: recommendedButtonX, y: frame.height - recommendedButtonBottomY - recommendedButtonHeight, width: recommendedButtonWidth, height: recommendedButtonHeight)
        }
        moreButton.frame = CGRect(x: frame.width - moreButtonWidth - moreButtonRightX, y: frame.height - moreButtonBottomY - moreButtonHeight, width: moreButtonWidth, height: moreButtonHeight)
        
        separator.frame = CGRect(x: 0, y: frame.height - separatorHeight, width: frame.width, height: separatorHeight)
    }
    
    func setupWithEpisode(episode: Episode) {
        
        episodeNameLabel.text = episode.title
        dateTimeLabel.text = episode.dateTimeSeriesString()
        
        let numberOfRecommendations = episode.numberOfRecommendations.shortString()
        recommendedButton.setTitle(numberOfRecommendations, for: .normal)
        recommendedButton.setTitle(numberOfRecommendations, for: .selected)
        recommendedButton.isSelected = episode.isRecommended
        
        if let url = episode.smallArtworkImageURL {
            if let data = try? Data(contentsOf: url) {
                episodeImage.image = UIImage(data: data)
            }
        } else {
            episodeImage.image = #imageLiteral(resourceName: "filler_image")
        }
    }
    
    ///
    ///Mark - Buttons
    ///
    func didPressRecommendedButton() {
        delegate?.bookmarkTableViewCellDidPressRecommendButton(bookmarksTableViewCell: self)
    }
    
    func setRecommendedButtonToState(isRecommended: Bool) {
        recommendedButton.isSelected = isRecommended
    }
    
    func didPressPlayButton() {
        delegate?.bookmarkTableViewCellDidPressPlayPauseButton(bookmarksTableViewCell: self)
    }
    
    func setPlayButtonToState(isPlaying: Bool) {
        playButton.isSelected = isPlaying
        if isPlaying {
            recommendedButton.frame = CGRect(x: recommendedButtonXPlaying, y: frame.height - recommendedButtonBottomY - recommendedButtonHeight, width: recommendedButtonWidth, height: recommendedButtonHeight)
        } else {
            recommendedButton.frame = CGRect(x: recommendedButtonX, y: frame.height - recommendedButtonBottomY - recommendedButtonHeight, width: recommendedButtonWidth, height: recommendedButtonHeight)
        }
    }
    
    func didPressMoreButton() {
        delegate?.bookmarkTableViewCellDidPressMoreActionsButton(bookmarksTableViewCell: self)
    }

}
