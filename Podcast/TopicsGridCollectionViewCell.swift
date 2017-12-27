
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
    var topicLabel: UILabel!
    let headerOffset: CGFloat = 60
    let topicLabelHeight: CGFloat = 18

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundLabel = UILabel(frame: .zero)
        backgroundLabel.backgroundColor = .rosyPink
        addSubview(backgroundLabel)
        backgroundLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(headerOffset)
            make.width.height.equalTo(frame.width)
            make.leading.trailing.equalToSuperview()
        }

        topicLabel = UILabel(frame: .zero)
        topicLabel.textAlignment = .center
        topicLabel.textColor = .offWhite
        topicLabel.font = ._12SemiboldFont()
        addSubview(topicLabel)

        topicLabel.snp.makeConstraints { make in
            make.center.equalTo(backgroundLabel.snp.center)
            make.height.equalTo(topicLabelHeight)
            make.leading.trailing.width.equalToSuperview()
        }

    }

    func configure(for topic: Topic) {
        topicLabel.text = topic.name
        // todo: background color
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
