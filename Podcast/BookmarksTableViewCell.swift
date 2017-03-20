//
//  BookmarksTableViewCell.swift
//  Podcast
//
//  Created by Drew Dunne on 3/20/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol BookmarksTableViewCellDelegate: class {
    
    func bookmarksTableViewCellDidPressPlayPauseButton(bookmarksTableViewCell: BookmarksTableViewCell)
    func bookmarksTableViewCellDidPressRecommendButton(bookmarksTableViewCell: BookmarksTableViewCell)
    func bookmarksTableViewCellDidPressMoreActionsButton(bookmarksTableViewCell: BookmarksTableViewCell)
}

class BookmarksTableViewCell: UITableViewCell {

    ///
    /// Mark: View Constants
    ///
    static let height: CGFloat = 96
    let height: CGFloat = BookmarksTableViewCell.height
    let separatorHeight: CGFloat = 1
    let padding: CGFloat = 18
    let episodeImageSideLength: CGFloat = 60
    let episodeNameLabelY: CGFloat = 18
    let episodeNameLabelX: CGFloat = 90
    let episodeNameLabelHeight: CGFloat = 21
    let dateTimeLabelX: CGFloat = 90
    let dateTimeLabelY: CGFloat = 41.5
    let dateTimeLabelHeight: CGFloat = 14.5
    
    let buttonTitlePadding: CGFloat = 7
    
    let playButtonX: CGFloat = 90
    let playButtonBottomY: CGFloat = 18
    let playButtonHeight: CGFloat = 15
    let playButtonWidth: CGFloat = 75
    
    let recommendedButtonX: CGFloat = 168
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
    var recommendedButton: UIButton!
    var moreButton: UIButton!
    var playButton: UIButton!
    var separator: UIView!
    
    weak var delegate: BookmarksTableViewCellDelegate?
    
    
    ///
    ///Mark: Init
    ///
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        frame.size.height = height
        
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
        addSubview(episodeNameLabel)
        
        dateTimeLabel = UILabel(frame: CGRect.zero)
        dateTimeLabel.font = UIFont.systemFont(ofSize: 12.0)
        dateTimeLabel.textColor = .podcastGrayDark
        addSubview(dateTimeLabel)
        
        let labels: [UILabel] = [episodeNameLabel, dateTimeLabel]
        for label in labels {
            label.textAlignment = .left
            label.lineBreakMode = .byTruncatingTail
            label.numberOfLines = 1
        }
        
        playButton = UIButton(frame: CGRect.zero)
        playButton.setImage(#imageLiteral(resourceName: "bookmarks_play_small"), for: .normal)
        playButton.setTitleColor(.podcastGrayDark, for: .normal)
        playButton.setTitle("Play", for: .normal)
        playButton.contentHorizontalAlignment = .left
        playButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonTitlePadding, bottom: 0, right: 0)
        playButton.titleLabel?.textColor = .podcastGrayDark
        playButton.titleLabel?.font = .systemFont(ofSize: 12)
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        addSubview(playButton)
        
        recommendedButton = UIButton(frame: CGRect.zero)
        recommendedButton.setImage(#imageLiteral(resourceName: "bookmarks_recommend_small"), for: .normal)
        recommendedButton.setImage(#imageLiteral(resourceName: "bookmarks_recommend_small_selected"), for: .selected)
        recommendedButton.contentHorizontalAlignment = .left
        recommendedButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: buttonTitlePadding, bottom: 0, right: 0)
        recommendedButton.setTitleColor(.podcastGrayDark, for: .normal)
        recommendedButton.setTitleColor(.cancelButtonRed, for: .selected)
        recommendedButton.setTitle("0", for: .normal)
        recommendedButton.titleLabel?.font = .systemFont(ofSize: 12)
        recommendedButton.addTarget(self, action: #selector(didPressRecommendedButton), for: .touchUpInside)
        addSubview(recommendedButton)
        
        moreButton = UIButton(frame: CGRect.zero)
        moreButton.setImage(#imageLiteral(resourceName: "more_icon"), for: .normal)
        moreButton.addTarget(self, action: #selector(didPressMoreButton), for: .touchUpInside)
        addSubview(moreButton)
        
        heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
        contentView.addConstraint(heightConstraint!)
        NSLayoutConstraint.activate([heightConstraint])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        episodeNameLabel.frame = CGRect(x: episodeNameLabelX, y: episodeNameLabelY, width: frame.width - padding - episodeNameLabelX, height: episodeNameLabelHeight)
        dateTimeLabel.frame = CGRect(x: dateTimeLabelX, y: dateTimeLabelY, width: frame.width - dateTimeLabelX - padding, height: dateTimeLabelHeight)
        episodeImage.frame = CGRect(x: padding, y: padding, width: episodeImageSideLength, height: episodeImageSideLength)
        
        playButton.frame = CGRect(x: playButtonX, y: frame.height - playButtonBottomY - playButtonHeight, width: playButtonWidth, height: playButtonHeight)
        recommendedButton.frame = CGRect(x: recommendedButtonX, y: frame.height - recommendedButtonBottomY - recommendedButtonHeight, width: recommendedButtonWidth, height: recommendedButtonHeight)
        moreButton.frame = CGRect(x: frame.width - moreButtonWidth - moreButtonRightX, y: frame.height - moreButtonBottomY - moreButtonHeight, width: moreButtonWidth, height: moreButtonHeight)
        
        separator.frame = CGRect(x: 0, y: frame.height - separatorHeight, width: frame.width, height: separatorHeight)
    }
    
    func setupWithEpisode(episode: Episode) {
        
        episodeNameLabel.text = episode.title
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateTimeLabel.text = dateFormatter.string(from: episode.dateCreated as Date)
        dateTimeLabel.text = dateTimeLabel.text! + " • " + String(episode.duration) + " min"
        if episode.seriesTitle != "" {
            dateTimeLabel.text = dateTimeLabel.text! + " • " + episode.seriesTitle
        }
        
        let numberOfRecommendations = convertNumberToShortenedString(n: episode.numberOfRecommendations)
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
    
    // Changes numbers from 108397878 to 108.3M 
    func convertNumberToShortenedString(n: Int) -> String {
        var final: Double = Double(n)
        var numberOfDivisions = 0
        while final >= 1000 {
            final /= 1000
            numberOfDivisions += 1
        }
        let suffixes = ["", "k", "M", "B", "T"]
        var suffix = ""
        if numberOfDivisions < suffixes.count {
            suffix = suffixes[numberOfDivisions]
        }
        return "\(String(format: "%.1f", final))\(suffix)"
    }
    
    ///
    ///Mark - Buttons
    ///
    func didPressRecommendedButton() {
        delegate?.bookmarksTableViewCellDidPressRecommendButton(bookmarksTableViewCell: self)
    }
    
    func setRecommendedButtonToState(isRecommended: Bool) {
        recommendedButton.isSelected = isRecommended
    }
    
    func didPressPlayButton() {
        delegate?.bookmarksTableViewCellDidPressPlayPauseButton(bookmarksTableViewCell: self)
    }
    
    func setPlayButtonToState(isPlaying: Bool) {
        if isPlaying {
            playButton.setImage(#imageLiteral(resourceName: "play_feed_icon_selected"), for: .normal)
            playButton.setTitle("Playing", for: .normal)
        } else {
            playButton.setImage(#imageLiteral(resourceName: "bookmarks_play_small"), for: .normal)
            playButton.setTitle("Play", for: .normal)
        }
    }
    
    func didPressMoreButton() {
        delegate?.bookmarksTableViewCellDidPressMoreActionsButton(bookmarksTableViewCell: self)
    }

}
