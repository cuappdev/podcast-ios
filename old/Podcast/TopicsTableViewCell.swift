//
//  TopicsTableViewCell.swift
//  Podcast
//
//  Created by Mindy Lou on 12/27/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

/// UITableViewCell class for displaying topics
class TopicsTableViewCell: UITableViewCell {
    let imageWidthHeight: CGFloat = 18
    let imageLeadingPadding: CGFloat = 18
    let topicLeadingPadding: CGFloat = 18
    let topPadding: CGFloat = 16.5

    var topicImageView: UIImageView!
    var topicLabel: UILabel!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        backgroundColor = .offWhite

        topicImageView = UIImageView(frame: .zero)
        addSubview(topicImageView)
        topicImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageWidthHeight)
            make.top.equalToSuperview().offset(topPadding)
            make.leading.equalToSuperview().offset(imageLeadingPadding)
        }

        topicLabel = UILabel(frame: .zero)
        topicLabel.textColor = .charcoalGrey
        topicLabel.font = ._14RegularFont()
        addSubview(topicLabel)
        topicLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(topPadding)
            make.leading.equalTo(topicImageView.snp.trailing).offset(topicLeadingPadding)
        }

    }

    func configure(for topic: Topic, isParentTopic: Bool = false, parentTopic: Topic? = nil) {
        if isParentTopic {
            // parent topic: See All ____
            topicLabel.text = "See All \(topic.name)"
        } else {
            topicLabel.text = topic.name
        }
        if let topicType = topic.topicType {
            topicImageView.image = topicType.image
        } else if let parent = parentTopic, let parentTopicType = parent.topicType {
            // children topics: set image to parent topic image
            topicImageView.image = parentTopicType.image
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
