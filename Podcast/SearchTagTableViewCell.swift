//
//  SearchTagTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 3/5/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SearchTagTableViewCell: UITableViewCell {
    
    let imageViewPaddingX: CGFloat = 18
    let imageViewPaddingY: CGFloat = 18
    let imageViewWidth: CGFloat = 18
    let imageViewHeight: CGFloat = 18
    let imageViewLabelPadding: CGFloat = 12
    
    var tagImageView: ImageView!
    var nameLabel: UILabel!
    
    var index: Int!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        tagImageView = ImageView(image: #imageLiteral(resourceName: "tag"))
        nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        contentView.addSubview(tagImageView)
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(tagName: String, index: Int) {
        nameLabel.text = tagName
        self.index = index
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tagImageView.frame = CGRect(x: imageViewPaddingX, y: imageViewPaddingY, width: imageViewWidth, height: imageViewHeight)
        let nameLabelX: CGFloat = tagImageView.frame.maxX + imageViewLabelPadding
        nameLabel.frame = CGRect(x: nameLabelX, y: imageViewPaddingY, width: frame.width - nameLabelX, height: imageViewHeight)
        separatorInset = UIEdgeInsets(top: 0, left: nameLabelX, bottom: 0, right: 0)
    }
}
