//
//  EpisodeDetailHeaderView.swift
//  Podcast
//
//  Created by Mark Bryan on 4/11/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol EpisodeDetailHeaderViewCellDelegate {
    func episodeDetailHeaderDidPressPlayButton(cell: EpisodeDetailHeaderViewCell)
    func episodeDetailHeaderDidPressMoreButton(cell: EpisodeDetailHeaderViewCell)
    func episodeDetailHeaderDidPressRecommendButton(cell: EpisodeDetailHeaderViewCell)
    func episodeDetailHeaderDidPressBookmarkButton(cell: EpisodeDetailHeaderViewCell)
}

class EpisodeDetailHeaderViewCell: UITableViewCell {
    var episodeArtworkImageView: ImageView!
    var seriesTitleLabel: UILabel!
    var publisherLabel: UILabel!
    var episodeTitleLabel: UILabel!
    var dateLabel: UILabel!
    var descriptionLabel: UILabel!
    var playButton: PlayButton!
    var recommendButton: UIButton!
    var moreButton: UIButton!
    var bookmarkButton: UIButton!
    var bottomLineSeparator: UIView!
    var delegate: EpisodeDetailHeaderViewCellDelegate?
    
    let marginSpacing: CGFloat = 18
    let artworkDimension: CGFloat = 79
    
    let seriesTitleLabelXValue: CGFloat = 109
    let seriesTitleLabelYValue: CGFloat = 36.5
    let seriesTitleHeight: CGFloat = 24
    
    let publisherLabelXValue: CGFloat = 109
    let publisherLabelYValue: CGFloat = 62
    let publisherLabelHeight: CGFloat = 17
    
    let episodeTitleLabelYValue: CGFloat = 117
    
    let dateLabelYSpacing: CGFloat = 6
    let descriptionLabelYSpacing: CGFloat = 15
    
    let bottomLineYSpacing: CGFloat = 20
    let bottomSectionHeight: CGFloat = 53.5
    
    let playButtonYSpacing: CGFloat = 24
    let playButtonWidth: CGFloat = 90
    let moreButtonWidth: CGFloat = 15
    let moreButtonRightX: CGFloat = 33
    let bookmarkButtonWidth: CGFloat = 18
    let bookmarkButtonRightX: CGFloat = 74
    let recommendButtonWidth: CGFloat = 18
    let recommendButtonRightX: CGFloat = 110
    
    var buttonPadding: CGFloat = 10
    let bottomViewInnerPadding: CGFloat = 18
    let bottomDescriptionPadding: CGFloat = 10

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.colorFromCode(0xfcfcfe)
        selectionStyle = .none
        
        episodeArtworkImageView = ImageView(frame: CGRect(x: marginSpacing,
                                                            y: marginSpacing,
                                                            width: artworkDimension,
                                                            height: artworkDimension))
        addSubview(episodeArtworkImageView)
        
        seriesTitleLabel = UILabel(frame: CGRect(x: seriesTitleLabelXValue,
                                                 y: seriesTitleLabelYValue,
                                                 width: frame.width - marginSpacing - seriesTitleLabelXValue,
                                                 height: seriesTitleHeight))
        seriesTitleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        seriesTitleLabel.textColor = UIColor.colorFromCode(0x30303c)
        addSubview(seriesTitleLabel)
        
        publisherLabel = UILabel(frame: CGRect(x: publisherLabelXValue,
                                               y: publisherLabelYValue,
                                               width: frame.width - marginSpacing - publisherLabelXValue,
                                               height: publisherLabelHeight))
        publisherLabel.font = UIFont.systemFont(ofSize: 14)
        publisherLabel.textColor = .podcastDetailGray
        addSubview(publisherLabel)
        
        episodeTitleLabel = UILabel(frame: .zero)
        episodeTitleLabel.font = UIFont.systemFont(ofSize: 24)
        episodeTitleLabel.lineBreakMode = .byWordWrapping
        episodeTitleLabel.numberOfLines = 0
        addSubview(episodeTitleLabel)
        
        dateLabel = UILabel(frame: CGRect(x: marginSpacing, y: 0, width: frame.width - 2 * marginSpacing, height: 0))
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .podcastDetailGray
        addSubview(dateLabel)
        
        descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .podcastBlack
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
        
        bottomLineSeparator = UIView(frame: .zero)
        bottomLineSeparator.backgroundColor = .podcastGray
        addSubview(bottomLineSeparator)
        
        playButton = PlayButton(frame: .zero)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        addSubview(playButton)
        
        moreButton = UIButton(frame: .zero)
        moreButton.setImage(#imageLiteral(resourceName: "more_icon"), for: .normal)
        moreButton.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        addSubview(moreButton)
        
        bookmarkButton = UIButton(frame: .zero)
        bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_feed_icon_unselected"), for: .normal)
        bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_feed_icon_selected"), for: .selected)
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        addSubview(bookmarkButton)
        
        recommendButton = RecommendButton(frame: .zero)
        recommendButton.setImage(#imageLiteral(resourceName: "heart_icon"), for: .normal)
        recommendButton.setImage(#imageLiteral(resourceName: "heart_icon_selected"), for: .selected)
        recommendButton.addTarget(self, action: #selector(recommendButtonTapped), for: .touchUpInside)
        addSubview(recommendButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        episodeTitleLabel.frame = CGRect(x: marginSpacing, y: episodeTitleLabelYValue, width: frame.width - 2 * marginSpacing, height: 0)
        episodeTitleLabel.sizeToFit()
        
        dateLabel.sizeToFit()
        dateLabel.frame.origin.y = episodeTitleLabel.frame.maxY + dateLabelYSpacing
        
        playButton.frame = CGRect(x: marginSpacing, y: dateLabel.frame.maxY, width: playButtonWidth, height: bottomSectionHeight)
        
        moreButton.frame = CGRect(x: frame.width - moreButtonRightX, y: playButton.frame.origin.y, width: moreButtonWidth, height: bottomSectionHeight)
        
        bookmarkButton.frame = CGRect(x: frame.width - bookmarkButtonRightX, y: playButton.frame.origin.y, width: bookmarkButtonWidth, height: bottomSectionHeight)
        
        recommendButton.frame = CGRect(x: frame.width - recommendButtonRightX, y: playButton.frame.origin.y, width: recommendButtonWidth, height: bottomSectionHeight)
        
        bottomLineSeparator.frame = CGRect(x: marginSpacing, y: playButton.frame.maxY, width: frame.width - 2 * marginSpacing, height: 1)
        
        descriptionLabel.frame = CGRect(x: marginSpacing, y: bottomLineSeparator.frame.maxY + descriptionLabelYSpacing, width: frame.width - 2 * marginSpacing, height: 0)
        descriptionLabel.sizeToFit()
        
        frame.size.height = descriptionLabel.frame.maxY + bottomDescriptionPadding
    }
    
    func setupForEpisode(episode: Episode) {
        if let imageUrl = episode.largeArtworkImageURL {
            episodeArtworkImageView.setImageAsynchronously(url: imageUrl, completion: nil)
        }
        seriesTitleLabel.text = episode.seriesTitle
        publisherLabel.text = "NPR"
        episodeTitleLabel.text = episode.title
        dateLabel.text = episode.dateString()
        descriptionLabel.attributedText = episode.attributedDescriptionString()
    }
    
    func setPlaying(playing: Bool) {
        playButton.isSelected = playing
    }
    
    func playButtonTapped() {
        if !playButton.isSelected {
            delegate?.episodeDetailHeaderDidPressPlayButton(cell: self)
        }
    }
    
    func bookmarkButtonTapped() {
        delegate?.episodeDetailHeaderDidPressBookmarkButton(cell: self)
        bookmarkButton.isSelected = !bookmarkButton.isSelected
    }
    
    func moreButtonTapped() {
        delegate?.episodeDetailHeaderDidPressMoreButton(cell: self)
        moreButton.isSelected = !moreButton.isSelected
    }
    
    func recommendButtonTapped() {
        delegate?.episodeDetailHeaderDidPressRecommendButton(cell: self)
        recommendButton.isSelected = !recommendButton.isSelected
    }

}
