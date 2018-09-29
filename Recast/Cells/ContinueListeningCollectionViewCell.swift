//
//  ContinueListeningCollectionViewCell.swift
//  Recast
//
//  Created by Jaewon Sim on 9/19/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class ContinueListeningCollectionViewCell: UICollectionViewCell {

    // MARK: View vars
    var podcastImageView: UIImageView!
    var podcastDarkOverlayView: UIView! //transparent black layer over artwork
    var podcastPlayButtonRoundView: UIView! //transparent black circle behind play button
    var podcastPlayImageView: UIImageView!
    var podcastLabel: UILabel!
    var titleLabel: UILabel!
    var detailLabel: UILabel!
    var timeLeftLabel: UILabel!
    var progressView: UIProgressView!

    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black

        podcastImageView = UIImageView()
        podcastImageView.setCornerRadius(forView: .large)
        contentView.addSubview(podcastImageView)

        podcastDarkOverlayView = UIView()
        podcastDarkOverlayView.backgroundColor = .black
        podcastDarkOverlayView.alpha = 0.6
        podcastDarkOverlayView.setCornerRadius(forView: .large)
        contentView.addSubview(podcastDarkOverlayView)

        podcastPlayImageView = UIImageView(image: #imageLiteral(resourceName: "play_artwork_overlay"))
        podcastDarkOverlayView.addSubview(podcastPlayImageView)

        podcastLabel = UILabel()
        podcastLabel.formatAsSubtitle()
        contentView.addSubview(podcastLabel)

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

    // MARK: Constraint setup
    private func setupConstraints() {
        // MARK: Constraint constants
        let imageViewWidth: CGFloat = 108
        let imageViewHeight: CGFloat = 108
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

        podcastPlayImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.height.width.equalTo(seriesPlayButtonHeightWidth)
        }

        podcastLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(podcastImageView.snp.trailing).offset(titleLabelSeriesImageViewHorizontalSpacing)
            make.height.equalTo(detailLabelHeight)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(podcastLabel.snp.bottom).offset(titleLabelDetailLabelVerticalSpacing)
            make.leading.equalTo(podcastLabel)
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
}
