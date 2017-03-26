//
//  SearchEpisodeTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 3/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol SearchEpisodeTableViewCellDelegate: class {
    func searchEpisodeTableViewCell(cell: SearchEpisodeTableViewCell, didSetPlayButton toNewValue: Bool)
}

class SearchEpisodeTableViewCell: UITableViewCell {
    
    let imageViewPaddingX: CGFloat = 18
    let imageViewPaddingY: CGFloat = 18
    let imageViewWidth: CGFloat = 48
    let imageViewHeight: CGFloat = 48
    let imageViewLabelPadding: CGFloat = 12
    let titleLabelHeight: CGFloat = 36
    let playButtonPaddingX: CGFloat = 18
    let playButtonPaddingY: CGFloat = 30
    let playButtonHeight: CGFloat = 30
    let playButtonWidth: CGFloat = 90
    
    var episodeImageView: UIImageView!
    var titleLabel: UILabel!
    var detailLabel: UILabel!
    var playButton: UIButton!
    
    var playButtonActivated = false
    var index: Int!
    
    weak var delegate: SearchEpisodeTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        episodeImageView = UIImageView()
        contentView.addSubview(episodeImageView)
        
        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        detailLabel = UILabel()
        detailLabel.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        detailLabel.textColor = .podcastGrayDark
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
        let playButtonX: CGFloat = frame.width - playButtonPaddingX - playButtonWidth
        titleLabel.frame = CGRect(x: titleLabelX, y: imageViewPaddingY-2, width: playButtonX - titleLabelX, height: titleLabelHeight)
        detailLabel.frame = CGRect(x: titleLabelX, y: titleLabel.frame.maxY, width: titleLabel.frame.width, height:episodeImageView.frame.height - titleLabel.frame.height + 2)
        playButton.frame = CGRect(x: playButtonX, y: playButtonPaddingY, width: playButtonWidth, height: playButtonHeight)
        separatorInset = UIEdgeInsets(top: 0, left: titleLabelX, bottom: 0, right: 0)
    }
    
    func configure(for episode: Episode, index: Int) {
        self.index = index
        episodeImageView.image = #imageLiteral(resourceName: "sample_series_artwork")
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
    
    func didPressPlayButton() {
        delegate?.searchEpisodeTableViewCell(cell: self, didSetPlayButton: playButtonActivated)
    }
    
    func setPlayButtonToState(isPlaying: Bool) {
        if isPlaying {
            playButton.isSelected = true
        } else {
            playButton.isSelected = false
        }
    }
}
