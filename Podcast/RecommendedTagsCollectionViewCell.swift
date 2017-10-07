//
//  RecommendedTagsCollectionViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class RecommendedTagsCollectionViewCell: UICollectionViewCell {
    
    static let cellFont: UIFont = ._14RegularFont()
    
    var tagLabel: UILabel!
    var podcastTag: Tag! //named to not conflit with tag property of a view
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tagLabel = UILabel(frame: bounds)
        tagLabel.textAlignment = .center
        tagLabel.font = RecommendedTagsCollectionViewCell.cellFont
        layer.cornerRadius = 2
        backgroundColor = .paleGrey
        contentView.addSubview(tagLabel)
    }
    
    func setupWithTag(tag: Tag) {
        self.podcastTag = tag
        self.tagLabel.text = tag.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
