//
//  ContinueListeningCollectionViewCell.swift
//  Recast
//
//  Created by Jaewon Sim on 9/19/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

protocol ContinueCollectionViewCellDelegate: class {
    /// Called when the play button on the collection view cell is pressed
    func didPressPlayButton()
    /// Called when any part of the collection view cell, except for the play button, is pressed
    func didPressCell()
}

class ContinueCollectionViewCell: UICollectionViewCell {
    private var podcastImageView: UIImageView!
    private var podcastDarkOverlayView: UIView! //transparent black layer over artwork
    private var podcastPlayButtonRoundView: UIView! //transparent black circle behind play button
    private var podcastPlayButton: UIButton!
    private var titleLabel: UILabel!
    private var detailLabel: UILabel!
    private var timeLeftLabel: UILabel!
    private var progressView: UIProgressView!

    weak var delegate: ContinueCollectionViewCellDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black

        podcastImageView = UIImageView()
        podcastImageView.setCornerRadius(forViewWithSize: .large)
        contentView.addSubview(podcastImageView)

        podcastDarkOverlayView = UIView()
        podcastDarkOverlayView.backgroundColor = .black
        podcastDarkOverlayView.alpha = 0.6
        podcastDarkOverlayView.setCornerRadius(forViewWithSize: .large)
        contentView.addSubview(podcastDarkOverlayView)
        
//        podcastPlayButtonRoundView = UIView()
//        podcastPlayButtonRoundView.backgroundColor = .black
//        podcastPlayButtonRoundView.alpha = 0.8
//        podcastPlayButtonRoundView.layer.cornerRadius = podcastPlayButtonRoundView.frame.width / 2
//        podcastPlayButtonRoundView.clipsToBounds = true
//        podcastPlayButtonRoundView.layer.masksToBounds = false
//        podcastDarkOverlayView.addSubview(podcastPlayButtonRoundView)
        
        podcastPlayButton = UIButton(type: .custom)
        podcastPlayButton.setImage(UIImage(named: "play_artwork_overlay.png"), for: .normal)
        podcastPlayButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        podcastDarkOverlayView.addSubview(podcastPlayButton)

        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        contentView.addSubview(titleLabel)

        detailLabel = UILabel()
        detailLabel.font = .systemFont(ofSize: 12)
        detailLabel.textColor = .lightGray
        contentView.addSubview(detailLabel)

        timeLeftLabel = UILabel()
        timeLeftLabel.font = .systemFont(ofSize: 12)
        timeLeftLabel.textColor = UIColor.recastAquamarine()
        contentView.addSubview(timeLeftLabel)

        progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .recastAquamarine()
        progressView.trackTintColor = .darkGray
        progressView.progress = 0.5
        contentView.addSubview(progressView)

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let imageViewWidth: CGFloat = 108
        let imageViewHeight: CGFloat = 108
        let roundViewWidthHeight: CGFloat = 36
        let seriesPlayButtonHeightWidth: CGFloat = 16
        let titleLabelWidth: CGFloat = 165
        let titleLabelHeight: CGFloat = 38
        let detailLabelHeight: CGFloat = 36
        let timeLeftLabelHeight: CGFloat = 18
        let titleLabelSeriesImageViewHorizontalSpacing: CGFloat = 12
        let titleLabelDetailLabelVerticalSpacing: CGFloat = 3.5
        let detailLabelTimeLeftLabelVerticalSpacing: CGFloat = 6
        let progressViewHeight: CGFloat = 6

        podcastImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView)
            make.width.equalTo(imageViewWidth)
            make.height.equalTo(imageViewHeight)
        }

        podcastDarkOverlayView.snp.makeConstraints { make in
            make.edges.equalTo(podcastImageView)
        }
        
//        podcastPlayButtonRoundView.snp.makeConstraints { make in
//            make.height.width.equalTo(roundViewWidthHeight)
//            make.center.equalToSuperview()
//        }

        podcastPlayButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(seriesPlayButtonHeightWidth)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(podcastImageView.snp.trailing).offset(titleLabelSeriesImageViewHorizontalSpacing)
            make.height.equalTo(titleLabelHeight)
            make.width.equalTo(titleLabelWidth)
        }

        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(titleLabelDetailLabelVerticalSpacing)
            make.leading.width.equalTo(titleLabel)
            make.height.equalTo(detailLabelHeight)
        }

        timeLeftLabel.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(detailLabelTimeLeftLabelVerticalSpacing)
            make.leading.width.equalTo(titleLabel)
            make.height.equalTo(timeLeftLabelHeight)
        }

        progressView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(podcastImageView)
            make.height.equalTo(progressViewHeight)
        }
    }

    func configure(with dummy: DummyPodcastSeries, delegate: ContinueCollectionViewCellDelegate) {
        podcastImageView.image = dummy.image
        titleLabel.text = dummy.title
        detailLabel.text = "\(dummy.date) · \(dummy.duration) min"
        timeLeftLabel.text = "\(dummy.timeLeft) minutes left"
        self.delegate = delegate
    }

    @objc func didPressPlayButton() {
        delegate?.didPressPlayButton()
    }

    @objc func didPressCell() {
        delegate?.didPressCell()
    }
}
