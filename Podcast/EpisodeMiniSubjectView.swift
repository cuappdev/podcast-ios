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

    static var height: CGFloat = 96

    ///
    /// Mark: View Constants
    ///
    let artworkImageViewSize: CGFloat = 60
    let padding: CGFloat = 18
    let smallPadding: CGFloat = 12
    let smallestPadding: CGFloat = 4
    let playImageWidth: CGFloat = 32
    let playImageHeight: CGFloat = 36


    ///
    /// Mark: Variables
    ///
    var artworkImageView: ImageView!
    var darkBackgroundView: UIView!
    var playImage: UIImageView!
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
        artworkImageView.isUserInteractionEnabled = true
        artworkImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(artworkImageTapped)))
        artworkImageView.addCornerRadius(height: artworkImageViewSize)
        addSubview(artworkImageView)

        darkBackgroundView = UIView()
        darkBackgroundView.backgroundColor = .offBlack
        darkBackgroundView.alpha = 0.45
        darkBackgroundView.addCornerRadius(height: artworkImageViewSize)
        artworkImageView.addSubview(darkBackgroundView)

        darkBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        playImage = UIImageView()
        playImage.image = #imageLiteral(resourceName: "iPlay")
        artworkImageView.addSubview(playImage)

        playImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(playImageHeight - playImageWidth)
            make.width.equalTo(playImageWidth)
            make.height.equalTo(playImageHeight)
        }

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

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.sizeToFit()
    }

    func setup(with episode: Episode) {
        artworkImageView.setImageAsynchronouslyWithDefaultImage(url: episode.smallArtworkImageURL)
        titleLabel.text = episode.title
        dateTimeLabel.text = episode.dateTimeLabelString
        updateWithPlayButtonPress(episode: episode)
    }

    @objc func moreButtonPress() {
        delegate?.didPress(on: .more)
    }

    @objc func artworkImageTapped() {
        delegate?.didPress(on: .play)
    }

    func updateWithPlayButtonPress(episode: Episode) {
        playImage.image = episode.isPlaying ?  #imageLiteral(resourceName: "play_feed_icon_selected") : #imageLiteral(resourceName: "iPlay")
    }
}
