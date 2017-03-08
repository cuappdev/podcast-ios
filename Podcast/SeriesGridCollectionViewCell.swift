//
//  SeriesGridCollectionViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

enum SeriesGridCollectionViewCellType {
    case subscriptions
    case recommended
}

class SeriesGridCollectionViewCell: UICollectionViewCell {
    
    
    let imageTitlePadding: CGFloat = 8
    let titleAuthorPadding: CGFloat = 2
    let labelHeight: CGFloat = 18
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var subscribersLabel: UILabel!
    var type: SeriesGridCollectionViewCellType?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        titleLabel = UILabel(frame: CGRect(x: 0, y: frame.width + imageTitlePadding, width: frame.width, height: labelHeight))
        subscribersLabel = UILabel(frame: CGRect(x: 0, y: frame.width + imageTitlePadding + labelHeight + titleAuthorPadding, width: frame.width, height: labelHeight))
        
        imageView.backgroundColor = .lightGray
        titleLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightSemibold)
        subscribersLabel.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        subscribersLabel.textColor = .podcastGrayDark
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subscribersLabel)
    }
    
    func configure(series: Series, type: SeriesGridCollectionViewCellType) {
        self.type = type 
        if let url = series.smallArtworkImageURL {
            if let data = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: data)
            }
        } else {
            imageView.image = #imageLiteral(resourceName: "filler_image")
        }
        titleLabel.text = series.title
        
        configureByType(series: series)
    }
    
    func configureByType(series: Series) {
        switch(type!) {
        case .subscriptions:
            subscribersLabel.text = "Last updated " + Date.formatDateDifferenceByLargestComponent(fromDate: series.lastUpdated, toDate: Date())
        case .recommended:
            subscribersLabel.text = series.numberOfSubscribers.shortString() + " Subscribers"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
