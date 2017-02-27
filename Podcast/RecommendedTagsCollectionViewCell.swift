//
//  RecommendedTagsCollectionViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class RecommendedTagsCollectionViewCell: UICollectionViewCell {
    
    static let CellFont: UIFont = .systemFont(ofSize: 14, weight: UIFontWeightRegular)
    
    var tagLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tagLabel = UILabel(frame: bounds)
        tagLabel.textAlignment = .center
        tagLabel.font = RecommendedTagsCollectionViewCell.CellFont
        layer.cornerRadius = 2
        backgroundColor = .podcastWhiteDark
        contentView.addSubview(tagLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
