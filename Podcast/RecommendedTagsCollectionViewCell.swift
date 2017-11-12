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
    let padding: CGFloat = 12
    var tagLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tagLabel = UILabel()
        tagLabel.textAlignment = .center
        tagLabel.font = RecommendedTagsCollectionViewCell.cellFont
        layer.cornerRadius = 2
        backgroundColor = .paleGrey
        contentView.addSubview(tagLabel)
    }
    
    func setup(with tag: Tag, fontColor: UIColor = .offBlack) {
        tagLabel.text = tag.name
        tagLabel.sizeToFit()
        tagLabel.textColor = fontColor
        
        tagLabel.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
