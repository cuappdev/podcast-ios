//
//  RecommendedSeriesCollectionViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class RecommendedSeriesCollectionViewCell: UICollectionViewCell {
    
    let ImageTitlePadding: CGFloat = 8
    let TitleAuthorPadding: CGFloat = 2
    let LabelHeight: CGFloat = 18
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var subscribersLabel: UILabel!
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        titleLabel = UILabel(frame: CGRect(x: 0, y: frame.width + ImageTitlePadding, width: frame.width, height: LabelHeight))
        subscribersLabel = UILabel(frame: CGRect(x: 0, y: frame.width + ImageTitlePadding + LabelHeight + TitleAuthorPadding, width: frame.width, height: LabelHeight))
        super.init(frame: frame)
        imageView.backgroundColor = .lightGray
        titleLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        subscribersLabel.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        subscribersLabel.textColor = .podcastGrayDark
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subscribersLabel)
    }
    
    func configure(series: Series) {
        imageView.image = series.smallArtworkImage
        titleLabel.text = series.title
        subscribersLabel.text = series.numberOfSubscribers.shortString() + " Subscribers"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
