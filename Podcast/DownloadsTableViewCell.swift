//
//  DownloadsTableViewCell.swift
//  Podcast
//
//  Created by Drew Dunne on 2/19/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

protocol DownloadsTableViewCellDelegate: class {
    func downloadsTableViewCellDidPressPlayPauseButton(downloadsTableViewCell: DownloadsTableViewCell)
    func downloadsTableViewCellDidPressMoreActionsButton(downloadsTableViewCell: DownloadsTableViewCell)
}

class DownloadsTableViewCell: UITableViewCell {

    ///
    /// Mark: View Constants
    ///
    static let height: CGFloat = 96
    let height: CGFloat = DownloadsTableViewCell.height
    let sliderHeight: CGFloat = 2
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
    
    let moreButtonRightX: CGFloat = 18
    let moreButtonBottomY: CGFloat = 18
    let moreButtonHeight: CGFloat = 30
    let moreButtonWidth: CGFloat = 15
    
    ///
    /// Mark: Variables
    ///
    var heightConstraint: NSLayoutConstraint!
    var episodeImage: ImageView!
    var episodeNameLabel: UILabel!
    var dateTimeLabel: UILabel!
    var moreButton: MoreButton!
    var playButton: PlayButton!
    var slider: EpisodeDurationSliderView!
    var separator: UIView!
    
    weak var delegate: DownloadsTableViewCellDelegate?
    var episodeID: String!
    
    
    ///
    ///Mark: Init
    ///
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .offWhite
        selectionStyle = .none
        
        separator = UIView(frame: CGRect.zero)
        separator.backgroundColor = .paleGrey
        contentView.addSubview(separator)
        
        episodeImage = ImageView(frame: CGRect(x: 0, y: 0, width: episodeImageSideLength, height: episodeImageSideLength))
        addSubview(episodeImage)
        
        episodeNameLabel = UILabel(frame: CGRect.zero)
        episodeNameLabel.font = ._16SemiboldFont()
        episodeNameLabel.textColor = .offBlack
        episodeNameLabel.textAlignment = .left
        episodeNameLabel.lineBreakMode = .byTruncatingTail
        episodeNameLabel.numberOfLines = 1
        addSubview(episodeNameLabel)
        
        dateTimeLabel = UILabel(frame: CGRect.zero)
        dateTimeLabel.font = ._12RegularFont()
        dateTimeLabel.textColor = .charcoalGrey
        dateTimeLabel.textAlignment = .left
        dateTimeLabel.lineBreakMode = .byTruncatingTail
        dateTimeLabel.numberOfLines = 1
        addSubview(dateTimeLabel)
        
        playButton = PlayButton()
        moreButton = MoreButton()
        slider = EpisodeDurationSliderView()
        
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(didPressMoreButton), for: .touchUpInside)
        
        addSubview(playButton)
        addSubview(moreButton)
        addSubview(slider)
        
        slider.snp.makeConstraints { make in
            make.leading.bottom.trailing.width.equalToSuperview()
            make.height.equalTo(sliderHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playButton.isSelected = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        episodeNameLabel.frame = CGRect(x: episodeNameLabelX, y: episodeNameLabelY, width: frame.width - padding - episodeNameLabelX, height: episodeNameLabelHeight)
        dateTimeLabel.frame = CGRect(x: dateTimeLabelX, y: dateTimeLabelY, width: frame.width - dateTimeLabelX - padding, height: dateTimeLabelHeight)
        episodeImage.frame = CGRect(x: padding, y: padding, width: episodeImageSideLength, height: episodeImageSideLength)
        
        playButton.frame = CGRect(x: playButtonX, y: frame.height - playButtonBottomY - playButtonHeight, width: playButtonWidth, height: playButtonHeight)

        moreButton.frame = CGRect(x: frame.width - moreButtonWidth - moreButtonRightX, y: 0, width: moreButtonWidth, height: moreButtonHeight)
        moreButton.center.y = playButton.center.y
        
        separator.frame = CGRect(x: 0, y: frame.height - separatorHeight, width: frame.width, height: separatorHeight)
    }
    
    func setupWithEpisode(episode: Episode) {
        episodeID = episode.id
        episodeNameLabel.text = episode.title
        dateTimeLabel.text = episode.dateTimeLabelString
        episodeImage.setImageAsynchronouslyWithDefaultImage(url: episode.smallArtworkImageURL)
        playButton.isSelected = episode.isPlaying
        slider.setSliderProgress(isPlaying: episode.isPlaying, progress: episode.currentProgress)
    }
    
    func updateWithPlayButtonPress(episode: Episode){
        playButton.isSelected = episode.isPlaying
        slider.setSliderProgress(isPlaying: episode.isPlaying, progress: episode.currentProgress)
    }
    
    ///
    ///Mark - Buttons
    ///
    
    @objc func didPressPlayButton() {
        delegate?.downloadsTableViewCellDidPressPlayPauseButton(downloadsTableViewCell: self)
    }
    
    @objc func didPressMoreButton() {
        delegate?.downloadsTableViewCellDidPressMoreActionsButton(downloadsTableViewCell: self)
    }

}
