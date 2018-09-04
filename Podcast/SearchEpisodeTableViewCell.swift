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

class SearchEpisodeTableViewCell: EpisodeDisplayCell {

    static let height: CGFloat = 84
    let imageViewPaddingX: CGFloat = 18
    let imageViewSize: CGFloat = 48
    let padding: CGFloat = 12
    let playButtonPaddingX: CGFloat = 18
    let playButtonWidthForSelected: CGFloat = 65
    let playButtonWidthForUnselected: CGFloat = 45
    let separatorHeight: CGFloat = 1
    
    var episodeImageView: ImageView!
    var titleLabel: UILabel!
    var detailLabel: UILabel!
    var playButton: PlayButton!
    var separator: UIView!
    var greyedOutLabel: UILabel!

    weak var delegate: SearchEpisodeTableViewCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        displayView = self
        episodeImageView = ImageView(frame: CGRect(x: 0, y: 0, width: imageViewSize, height: imageViewSize))
        episodeImageView.addCornerRadius(height: imageViewSize)
        contentView.addSubview(episodeImageView)
        
        titleLabel = UILabel()
        titleLabel.font = ._14SemiboldFont()
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)
        
        detailLabel = UILabel()
        detailLabel.font = ._12RegularFont()
        detailLabel.textColor = .charcoalGrey
        detailLabel.numberOfLines = 2
        contentView.addSubview(detailLabel)
    
        playButton = PlayButton()
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        contentView.addSubview(playButton)
        
        separator = UIView()
        separator.backgroundColor = .silver
        contentView.addSubview(separator)

        greyedOutLabel = UILabel()
        greyedOutLabel.backgroundColor = UIColor.lightGrey.withAlphaComponent(0.5)
        greyedOutLabel.isHidden = true
        contentView.addSubview(greyedOutLabel)
        
        episodeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(imageViewPaddingX)
            make.size.equalTo(imageViewSize)
            make.centerY.equalToSuperview()
        }
        
        playButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(playButtonPaddingX)
            make.centerY.equalToSuperview()
            make.width.equalTo(playButtonWidthForUnselected)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(episodeImageView.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().inset(padding + playButtonPaddingX + playButtonWidthForSelected)
            make.top.equalTo(episodeImageView.snp.top)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.lessThanOrEqualTo(titleLabel.snp.trailing)
            make.bottom.lessThanOrEqualTo(episodeImageView.snp.bottom)
        }
        
        separator.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalToSuperview()
            make.height.equalTo(separatorHeight)
            make.bottom.equalToSuperview()
        }

        greyedOutLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didPressPlayButton() {
        delegate?.searchEpisodeTableViewCellDidPressPlayButton(cell: self)
    }
    
    func setPlayButtonToState(isPlaying: Bool) {
        playButton.isSelected = isPlaying
        let playButtonWidth = isPlaying ? playButtonWidthForSelected : playButtonWidthForUnselected
        playButton.snp.remakeConstraints { make in
            make.trailing.equalToSuperview().inset(playButtonPaddingX)
            make.centerY.equalToSuperview()
            make.width.equalTo(playButtonWidth)
        }
    }
}

// MARK: EpisodeDisplayView
extension SearchEpisodeTableViewCell: EpisodeDisplayView {
    func set(title: String) {
        titleLabel.text = title
    }

    func set(description: String) {
        detailLabel.text = description
    }

    func set(smallImageUrl: URL) {
        episodeImageView.setImageAsynchronouslyWithDefaultImage(url: smallImageUrl)
    }


    func set(isPlaying: Bool) {
        playButton.isSelected = isPlaying
    }

    func set(isPlayable: Bool) {
        playButton.isEnabled = isPlayable
        greyedOutLabel.isHidden = isPlayable
    }

    func set(dateCreated: String) {}
    func set(seriesTitle: String) {}
    func set(largeImageUrl: URL) {}
    func set(topics: [String]) {}
    func set(duration: String) {}
    func set(isBookmarked: Bool) {}
    func set(isRecasted: Bool) {}
    func set(recastBlurb: String) {}
    func set(numberOfRecasts: Int) {}
    func set(downloadStatus: DownloadStatus) {}
}
