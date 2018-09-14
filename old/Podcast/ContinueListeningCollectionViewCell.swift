//
//  ContinueListeningCollectionViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/29/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

protocol ContinueListeningCollectionViewCellDelegate: class {
    func dismissButtonPress(on cell: ContinueListeningCollectionViewCell)
}

class ContinueListeningCollectionViewCell: UICollectionViewCell {

    var artworkImageView: ImageView!
    var titleLabel: UILabel!
    var descriptionLabel: UILabel!
    var timeLeftLabel: UILabel!
    var timeLeftView: UIView!
    var dismissButton: Button!

    let artworkImageViewSize: CGFloat = 108
    let padding: CGFloat = 18
    let smallPadding: CGFloat = 12
    let smallestPadding: CGFloat = 6
    let timeLeftViewHeight: CGFloat = 25

    weak var delegate: ContinueListeningCollectionViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .offWhite

        artworkImageView = ImageView()
        artworkImageView.addCornerRadius(height: artworkImageViewSize)
        addSubview(artworkImageView)
        artworkImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.size.equalTo(artworkImageViewSize)
            make.top.equalToSuperview()
        }

        titleLabel = UILabel()
        titleLabel.font = ._16SemiboldFont()
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .offBlack
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(artworkImageView.snp.trailing).offset(smallPadding)
            make.trailing.equalToSuperview().inset(padding + smallPadding)
            make.top.equalTo(artworkImageView.snp.top)
        }

        descriptionLabel = UILabel()
        descriptionLabel.font = ._12RegularFont()
        descriptionLabel.textColor = .charcoalGrey
        descriptionLabel.numberOfLines = 2
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(smallestPadding)
        }

        timeLeftView = UIView()
        timeLeftView.backgroundColor = .slateGrey
        timeLeftView.clipsToBounds = true
        timeLeftView.layer.cornerRadius = 3
        addSubview(timeLeftView)

        timeLeftLabel = UILabel()
        timeLeftLabel.font = ._12SemiboldFont()
        timeLeftLabel.textAlignment = .center
        timeLeftLabel.textColor = .offWhite
        timeLeftView.addSubview(timeLeftLabel)

        timeLeftView.snp.makeConstraints { make in
            make.bottom.equalTo(artworkImageView.snp.bottom)
            make.leading.equalTo(titleLabel.snp.leading)
            make.height.equalTo(timeLeftViewHeight)
        }

        timeLeftLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(smallestPadding)
        }

        dismissButton = Button()
        dismissButton.setImage(#imageLiteral(resourceName: "failure_icon"), for: .normal)
        dismissButton.imageEdgeInsets = UIEdgeInsets.zero
        dismissButton.addTarget(self, action: #selector(dismissButtonPress), for: .touchUpInside)
        addSubview(dismissButton)

        dismissButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(smallPadding)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(for episode: Episode) {
        artworkImageView.setImageAsynchronouslyWithDefaultImage(url: episode.largeArtworkImageURL)
        titleLabel.text = episode.title
        descriptionLabel.text = episode.getDateTimeLabelString(includeSeriesTitle: true)
        if let duration = Double(episode.duration), episode.isDurationWritten {
            let minsLeft = Int((duration - duration * episode.currentProgress) / 60)
            timeLeftLabel.text = "\(minsLeft) min left"
            timeLeftView.isHidden = false
        } else {
            timeLeftView.isHidden = true
        }
    }

    @objc func dismissButtonPress() {
        delegate?.dismissButtonPress(on: self)
    }
}
