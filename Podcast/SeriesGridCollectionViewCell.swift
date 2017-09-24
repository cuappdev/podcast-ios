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
    let frameHeight: CGFloat = 175
    
    var imageView: ImageView!
    var titleLabel: UILabel!
    var subscribersLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = frameHeight
        imageView = ImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
        titleLabel = UILabel(frame: CGRect(x: 0, y: frame.width + imageTitlePadding, width: frame.width, height: 0))
        subscribersLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 0))
        
        imageView.backgroundColor = .lightGray
        titleLabel.font = .systemFont(ofSize: 12, weight: UIFont.Weight.semibold)
        titleLabel.lineBreakMode = .byWordWrapping
        subscribersLabel.font = .systemFont(ofSize: 10, weight: UIFont.Weight.regular)
        subscribersLabel.textColor = .podcastGrayDark
        subscribersLabel.lineBreakMode = .byWordWrapping
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subscribersLabel)
    }
    
    func configureForSeries(series: GridSeries) {
        if let url = series.largeArtworkImageURL {
            imageView.setImageAsynchronously(url: url, completion: nil)
        } else {
            imageView.image = #imageLiteral(resourceName: "nullSeries")
        }
        titleLabel.text = series.title
        UILabel.adjustHeightToFit(label: titleLabel, numberOfLines: 2)
        if let fullSeries = series as? Series {
            subscribersLabel.text = fullSeries.numberOfSubscribers.shortString() + " Subscribers"
        } else {
            subscribersLabel.text = "Last updated " + Date.formatDateDifferenceByLargestComponent(fromDate: series.lastUpdated, toDate: Date())
        }
        UILabel.adjustHeightToFit(label: subscribersLabel, numberOfLines: 2)
        subscribersLabel.frame.origin.y = titleLabel.frame.maxY + titleAuthorPadding
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
