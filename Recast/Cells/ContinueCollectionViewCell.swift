//
//  ContinueListeningCollectionViewCell.swift
//  Recast
//
//  Created by Jaewon Sim on 9/19/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

class ContinueCollectionViewCell: UICollectionViewCell {
    private var seriesImageView: UIImageView!
    private var titleLabel: UILabel!
    private var detailLabel: UILabel!
    private var timeLeftLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black

        seriesImageView = UIImageView()
        seriesImageView.setCornerRadius()
        contentView.addSubview(seriesImageView)

        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
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

        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        let imageViewWidth: CGFloat = 108
        let imageViewHeight: CGFloat = 108
        let titleLabelWidth: CGFloat = 165
        let titleLabelHeight: CGFloat = 38
        let detailLabelHeight: CGFloat = 36
        let timeLeftLabelHeight: CGFloat = 18
        let titleLabelSeriesImageViewHorizontalSpacing: CGFloat = 12
        let titleLabelDetailLabelVerticalSpacing: CGFloat = 3.5
        let detailLabelTimeLeftLabelVerticalSpacing: CGFloat = 6

        seriesImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView)
            make.width.equalTo(imageViewWidth)
            make.height.equalTo(imageViewHeight)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(seriesImageView.snp.trailing).offset(titleLabelSeriesImageViewHorizontalSpacing)
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
    }

    func configure(with dummy: DummyPodcastSeries) {
        seriesImageView.image = dummy.image
        titleLabel.text = dummy.title
        detailLabel.text = "\(dummy.date) · \(dummy.duration) min"
        timeLeftLabel.text = "\(dummy.timeLeft) minutes left"
    }
}
