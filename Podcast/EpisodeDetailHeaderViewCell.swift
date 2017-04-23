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
    var episodeArtworkImageView: UIImageView!
    var seriesTitleLabel: UILabel!
    var publisherLabel: UILabel!
    var episodeTitleLabel: UILabel!
    var dateLabel: UILabel!
    var descriptionLabel: UILabel!
    var playButton: PlayButton!
    var recommendedButton: UIButton!
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
    let descriptionLabelYSpacing: CGFloat = 6
    
    let bottomLineYSpacing: CGFloat = 20
    let bottomSectionHeight: CGFloat = 53.5
    
    let playButtonYSpacing: CGFloat = 24
    let playButtonWidth: CGFloat = 90
    let moreButtonWidth: CGFloat = 15
    let moreButtonRightX: CGFloat = 33
    let bookmarkButtonWidth: CGFloat = 18
    let bookmarkButtonRightX: CGFloat = 74
    let recommendedButtonWidth: CGFloat = 18
    let recommendedButtonRightX: CGFloat = 110
    
    var buttonPadding: CGFloat = 10
    let bottomViewInnerPadding: CGFloat = 18

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.colorFromCode(0xfcfcfe)
        selectionStyle = .none
        
        episodeArtworkImageView = UIImageView(frame: CGRect(x: marginSpacing,
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
        publisherLabel.textColor = UIColor.colorFromCode(0x959ba5)
        addSubview(publisherLabel)
        
        episodeTitleLabel = UILabel(frame: .zero)
        episodeTitleLabel.font = UIFont.systemFont(ofSize: 24)
        episodeTitleLabel.lineBreakMode = .byWordWrapping
        episodeTitleLabel.numberOfLines = 0
        addSubview(episodeTitleLabel)
        
        dateLabel = UILabel(frame: CGRect(x: marginSpacing, y: 0, width: frame.width - 2 * marginSpacing, height: 0))
        dateLabel.font = UIFont.systemFont(ofSize: 14)
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
        
        recommendedButton = UIButton(frame: .zero)
        recommendedButton.setImage(#imageLiteral(resourceName: "heart_icon"), for: .normal)
        recommendedButton.setImage(#imageLiteral(resourceName: "heart_icon_selected"), for: .selected)
        recommendedButton.addTarget(self, action: #selector(recommendedButtonTapped), for: .touchUpInside)
        addSubview(recommendedButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        episodeTitleLabel.frame = CGRect(x: marginSpacing, y: episodeTitleLabelYValue, width: frame.width - 2 * marginSpacing, height: 0)
        episodeTitleLabel.sizeToFit()
        
        dateLabel.sizeToFit()
        dateLabel.frame.origin.y = episodeTitleLabel.frame.maxY + dateLabelYSpacing
        
        descriptionLabel.frame = CGRect(x: marginSpacing, y: dateLabel.frame.maxY + descriptionLabelYSpacing, width: frame.width - 2 * marginSpacing, height: 0)
        descriptionLabel.sizeToFit()
        
        bottomLineSeparator.frame = CGRect(x: marginSpacing, y: descriptionLabel.frame.maxY + bottomLineYSpacing, width: frame.width - 2 * marginSpacing, height: 1)
        
        playButton.frame = CGRect(x: marginSpacing, y: bottomLineSeparator.frame.maxY, width: playButtonWidth, height: bottomSectionHeight)
        
        moreButton.frame = CGRect(x: frame.width - moreButtonRightX, y: playButton.frame.origin.y, width: moreButtonWidth, height: bottomSectionHeight)
        
        bookmarkButton.frame = CGRect(x: frame.width - bookmarkButtonRightX, y: playButton.frame.origin.y, width: bookmarkButtonWidth, height: bottomSectionHeight)
        
        recommendedButton.frame = CGRect(x: frame.width - recommendedButtonRightX, y: playButton.frame.origin.y, width: recommendedButtonWidth, height: bottomSectionHeight)
        
        frame.size.height = playButton.frame.maxY
    }
    
    func setupForEpisode(episode: Episode) {
        episodeArtworkImageView.image = #imageLiteral(resourceName: "filler_image")
        if let url = episode.largeArtworkImageURL {
            if let data = try? Data(contentsOf: url) {
                episodeArtworkImageView.image = UIImage(data: data)
            }
        }
        
        seriesTitleLabel.text = episode.seriesTitle
        publisherLabel.text = "NPR >"
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
    
    func recommendedButtonTapped() {
        delegate?.episodeDetailHeaderDidPressRecommendButton(cell: self)
        recommendedButton.isSelected = !recommendedButton.isSelected
    }

}
