//
//  EpisodeMiniSubjectView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 5/8/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

protocol EpisodeMiniSubjectViewDelegate: class {
    func didPress(on action: EpisodeAction)
}

class EpisodeMiniSubjectView: UIView {

    ///
    /// Mark: View Constants
    ///
    let artworkImageViewSize: CGFloat = 60
    let padding: CGFloat = 18
    let smallPadding: CGFloat = 12
    let smallestPadding: CGFloat = 4


    ///
    /// Mark: Variables
    ///
    var artworkImageView: ImageView!
    var titleLabel: UILabel!
    var dateTimeLabel: UILabel!
    var moreButton: UIButton!
    weak var delegate: EpisodeMiniSubjectViewDelegate?

    ///
    ///Mark: Init
    ///
    init() {
        super.init(frame: .zero)

        backgroundColor = .paleGrey

        artworkImageView = ImageView()
        artworkImageView.addCornerRadius(height: artworkImageViewSize)
        addSubview(artworkImageView)

        titleLabel = UILabel()
        titleLabel.font = ._16SemiboldFont()
        titleLabel.textColor = .offBlack
        titleLabel.numberOfLines = 2
        addSubview(titleLabel)

        dateTimeLabel = UILabel()
        dateTimeLabel.font = ._12RegularFont()
        dateTimeLabel.textColor = .slateGrey
        addSubview(dateTimeLabel)

        moreButton = Button()
        moreButton.addTarget(self, action: #selector(moreButtonPress), for: .touchUpInside)
        moreButton.setImage(#imageLiteral(resourceName: "iMore"), for: .normal)
        addSubview(moreButton)

        artworkImageView.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(padding)
            make.size.equalTo(artworkImageViewSize)
            make.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(artworkImageView.snp.trailing).offset(smallPadding)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalToSuperview().inset(padding)
        }

        dateTimeLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.trailing.equalTo(titleLabel.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(smallestPadding)
            make.bottom.equalToSuperview().inset(padding)
        }

        moreButton.snp.makeConstraints { make in
            make.size.equalTo(padding)
            make.top.equalToSuperview().inset(padding)
            make.trailing.equalToSuperview().inset(smallestPadding)
        }

        clipsToBounds = true
        layer.cornerRadius = 6
    }

    convenience init(episode: Episode) {
        self.init()
        setup(with: episode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with episode: Episode) {
        artworkImageView.setImageAsynchronouslyWithDefaultImage(url: episode.smallArtworkImageURL)
        titleLabel.text = episode.title
        dateTimeLabel.text = episode.dateTimeLabelString
    }

    @objc func moreButtonPress() {
        delegate?.didPress(on: .more)
    }
    
}
