
//
//  TopicsGridCollectionViewCell.swift
//  Podcast
//
//  Created by Mindy Lou on 12/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class TopicsGridCollectionViewCell: UICollectionViewCell {
    var backgroundLabel: UILabel!
    var backgroundTileImageView: ImageView!
    var topicLabel: UILabel!
    let topicLabelHeight: CGFloat = 18
    let topicTileAlpha: CGFloat = 0.25

    let backgroundColors: [UIColor] = [.rosyPink, .sea, .duskyBlue, .dullYellow]

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundLabel = UILabel(frame: frame)
        backgroundLabel.clipsToBounds = true
        addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(frame.width)
            make.leading.trailing.equalToSuperview()
        }

        backgroundTileImageView = ImageView(frame: .zero)
        addSubview(backgroundTileImageView)
        backgroundTileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(frame.width)
            make.leading.trailing.equalToSuperview()
        }
        backgroundTileImageView.clipsToBounds = true

        topicLabel = UILabel(frame: .zero)
        topicLabel.textAlignment = .center
        topicLabel.lineBreakMode = .byWordWrapping
        topicLabel.numberOfLines = 0
        topicLabel.textColor = .offWhite
        topicLabel.font = ._12SemiboldFont()
        addSubview(topicLabel)

        topicLabel.snp.makeConstraints { make in
            make.center.equalTo(backgroundLabel.snp.center)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(backgroundLabel.snp.width)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLabel.layer.cornerRadius = frame.width * cornerRadiusPercentage
        backgroundTileImageView.layer.cornerRadius = frame.width * cornerRadiusPercentage
    }

    func configure(for topic: Topic, at index: Int) {
        topicLabel.text = topic.name
        backgroundLabel.backgroundColor = backgroundColors[index % 4]
        if let topicType = topic.topicType {
            backgroundTileImageView.image = topicType.tileImage.withAlpha(topicTileAlpha)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
