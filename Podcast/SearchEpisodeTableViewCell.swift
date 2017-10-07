//
//  SearchEpisodeTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 3/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol SearchEpisodeTableViewCellDelegate: class {
    func searchEpisodeTableViewCellDidPressPlayButton(cell: SearchEpisodeTableViewCell)
}

class SearchEpisodeTableViewCell: UITableViewCell {
    
    let imageViewPaddingX: CGFloat = 18
    let imageViewPaddingY: CGFloat = 18
    let imageViewWidth: CGFloat = 48
    let imageViewHeight: CGFloat = 48
    let imageViewLabelPadding: CGFloat = 12
    let titleLabelHeight: CGFloat = 36
    let titleLabelPlayButtonSpacing: CGFloat = 8
    let playButtonPaddingX: CGFloat = 18
    let playButtonPaddingY: CGFloat = 30
    let playButtonHeight: CGFloat = 30
    let playButtonWidthForSelected: CGFloat = 65
    let playButtonWidthForUnselected: CGFloat = 45
    
    var episodeImageView: ImageView!
    var titleLabel: UILabel!
    var detailLabel: UILabel!
    var playButton: PlayButton!
    
    var playButtonActivated = false
    var index: Int!
    
    weak var delegate: SearchEpisodeTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        episodeImageView = ImageView(frame: CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight))
        contentView.addSubview(episodeImageView)
        
        titleLabel = UILabel()
        titleLabel.font = ._14SemiboldFont()
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        detailLabel = UILabel()
        detailLabel.font = ._12RegularFont()
        detailLabel.textColor = .charcoalGrey
        contentView.addSubview(detailLabel)
    
        playButton = PlayButton()
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        contentView.addSubview(playButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        episodeImageView.frame = CGRect(x: imageViewPaddingX, y: imageViewPaddingY, width: imageViewWidth, height: imageViewHeight)
        let titleLabelX: CGFloat = episodeImageView.frame.maxX + imageViewLabelPadding
        let playButtonX: CGFloat = frame.width - playButtonPaddingX - (playButton.isSelected ? playButtonWidthForSelected : playButtonWidthForUnselected)
        titleLabel.frame = CGRect(x: titleLabelX, y: imageViewPaddingY-2, width: playButtonX - titleLabelX - titleLabelPlayButtonSpacing, height: titleLabelHeight)
        detailLabel.frame = CGRect(x: titleLabelX, y: titleLabel.frame.maxY, width: titleLabel.frame.width, height:episodeImageView.frame.height - titleLabel.frame.height + 2)
        playButton.frame = CGRect(x: playButtonX, y: playButtonPaddingY, width: (playButton.isSelected ? playButtonWidthForSelected : playButtonWidthForUnselected), height: playButtonHeight)
        separatorInset = UIEdgeInsets(top: 0, left: titleLabelX, bottom: 0, right: 0)
    }
    
    func configure(for episode: Episode, index: Int) {
        self.index = index
        episodeImageView.setImageAsynchronouslyWithDefaultImage(url: episode.smallArtworkImageURL)
        episodeImageView.sizeToFit()
        titleLabel.text = episode.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        detailLabel.text = dateFormatter.string(from: episode.dateCreated as Date)
        detailLabel.text = detailLabel.text!
        if episode.seriesTitle != "" {
            detailLabel.text = detailLabel.text! + " • " + episode.seriesTitle
        }
    }
    
    @objc func didPressPlayButton() {
        delegate?.searchEpisodeTableViewCellDidPressPlayButton(cell: self)
    }
    
    func setPlayButtonToState(isPlaying: Bool) {
        playButton.isSelected = isPlaying
        setNeedsLayout()
    }
}
