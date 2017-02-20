//
//  RecommendedTagsCollectionViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class RecommendedTagsCollectionViewCell: UICollectionViewCell {
    
    let kImageTitlePadding: CGFloat = 8
    let kTitleAuthorPadding: CGFloat = 0
    let kLabelHeight: CGFloat = 18
    static let CellFont: UIFont = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
    
    var tagLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tagLabel = UILabel(frame: bounds)
        tagLabel.textAlignment = .center
        tagLabel.text = "Doggos"
        tagLabel.font = RecommendedTagsCollectionViewCell.CellFont
        layer.cornerRadius = 2
        backgroundColor = .white
        contentView.addSubview(tagLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
