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
        seriesImageView.layer.cornerRadius = 8
        contentView.addSubview(seriesImageView)

        titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = .white
        titleLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(titleLabel)

        detailLabel = UILabel()
        detailLabel.font = .systemFont(ofSize: 12)
        detailLabel.textColor = .lightGray
        contentView.addSubview(detailLabel)

        timeLeftLabel = UILabel()
        timeLeftLabel.font = .systemFont(ofSize: 12)
        timeLeftLabel.textColor = UIColor.RecastColor.RecastAquamarine
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

        seriesImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.width.equalTo(imageViewWidth)
            make.height.equalTo(imageViewHeight)
        }

        titleLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.leading.equalTo(seriesImageView.snp.trailing).offset(12)
            make.height.equalTo(titleLabelHeight)
            make.width.equalTo(titleLabelWidth)
        }

        detailLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(3.5)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(titleLabel)
            make.height.equalTo(detailLabelHeight)
        }

        timeLeftLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(detailLabel.snp.bottom).offset(6)
            make.leading.equalTo(titleLabel)
            make.width.equalTo(titleLabel)
            make.height.equalTo(timeLeftLabelHeight)
        }

    }

    func configure(withDummy dummy: DummyPodcastSeries) {
        seriesImageView.image = dummy.image
        titleLabel.text = dummy.title
        detailLabel.text = "\(dummy.date) · \(dummy.duration) min"
        timeLeftLabel.text = "\(dummy.timeLeft) minutes left"
    }
}
