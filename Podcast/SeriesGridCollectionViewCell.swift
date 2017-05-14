//
//  SeriesGridCollectionViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SeriesGridCollectionViewCell: UICollectionViewCell {
    
    
    let imageTitlePadding: CGFloat = 8
    let titleAuthorPadding: CGFloat = 2
    let labelHeight: CGFloat = 18
    
    var imageView: ImageView!
    var titleLabel: UILabel!
    var subscribersLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = ImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
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
    
    func configureForSeries(series: Series) {
        if let url = series.largeArtworkImageURL {
            imageView.setImageAsynchronously(url: url, completion: nil)
        } else {
            imageView.image = #imageLiteral(resourceName: "nullSeries")
        }
        titleLabel.text = series.title
        subscribersLabel.text = series.numberOfSubscribers.shortString() + " Subscribers"
    }
    
    func configureForSubscriptionSeries(series: GridSeries) {
        if let url = series.largeArtworkImageURL {
            imageView.setImageAsynchronously(url: url, completion: nil)
        } else {
            imageView.image = #imageLiteral(resourceName: "nullSeries")
        }
        titleLabel.text = series.seriesTitle
        subscribersLabel.text = "Last updated " + Date.formatDateDifferenceByLargestComponent(fromDate: series.lastUpdated, toDate: Date())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
