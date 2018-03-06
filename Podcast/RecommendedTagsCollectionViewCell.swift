//
//  RecommendedTopicsCollectionViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class RecommendedTopicsCollectionViewCell: UICollectionViewCell {
    
    static let cellFont: UIFont = ._14RegularFont()
    let padding: CGFloat = 12
    var topicLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        topicLabel = UILabel()
        topicLabel.textAlignment = .center
        topicLabel.font = RecommendedTopicsCollectionViewCell.cellFont
        layer.cornerRadius = 2
        backgroundColor = .paleGrey
        contentView.addSubview(topicLabel)
    }
    
    func setup(with topic: Topic, fontColor: UIColor = .offBlack) {
        topicLabel.text = topic.name
        topicLabel.sizeToFit()
        topicLabel.textColor = fontColor
        
        topicLabel.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(padding)
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
