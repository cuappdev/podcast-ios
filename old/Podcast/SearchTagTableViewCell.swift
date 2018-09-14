//
//  SearchTopicTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 3/5/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SearchTopicTableViewCell: UITableViewCell {
    
    let imageViewPaddingX: CGFloat = 18
    let imageViewPaddingY: CGFloat = 18
    let imageViewWidth: CGFloat = 18
    let imageViewHeight: CGFloat = 18
    let imageViewLabelPadding: CGFloat = 12
    
    var topicImageView: ImageView!
    var nameLabel: UILabel!
    
    var index: Int!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        topicImageView = ImageView(image: #imageLiteral(resourceName: "tag"))
        nameLabel = UILabel()
        nameLabel.font = ._14RegularFont()
        contentView.addSubview(topicImageView)
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(topicName: String, index: Int) {
        nameLabel.text = topicName
        self.index = index
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        topicImageView.frame = CGRect(x: imageViewPaddingX, y: imageViewPaddingY, width: imageViewWidth, height: imageViewHeight)
        let nameLabelX: CGFloat = topicImageView.frame.maxX + imageViewLabelPadding
        nameLabel.frame = CGRect(x: nameLabelX, y: imageViewPaddingY, width: frame.width - nameLabelX, height: imageViewHeight)
        separatorInset = UIEdgeInsets(top: 0, left: nameLabelX, bottom: 0, right: 0)
    }
}
