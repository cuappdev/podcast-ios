//
//  SeriesGridCollectionViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//
import SnapKit
import UIKit

class SeriesGridCollectionViewCell: UICollectionViewCell {

    let headerOffset: CGFloat = 60
    let imageTitlePadding: CGFloat = 8
    let titleAuthorPadding: CGFloat = 2
    
    var imageView: ImageView!
    var titleLabel: UILabel!
    var subscribersLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        isUserInteractionEnabled = true
        
        imageView = ImageView(frame: .zero)
        addSubview(imageView)
        titleLabel = UILabel(frame: .zero)
        addSubview(titleLabel)
        subscribersLabel = UILabel(frame: .zero)
        addSubview(subscribersLabel)
        
        titleLabel.font = ._12SemiboldFont()
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .offBlack
        subscribersLabel.font = ._10RegularFont()
        subscribersLabel.textColor = .charcoalGrey
        subscribersLabel.lineBreakMode = .byWordWrapping
        subscribersLabel.numberOfLines = 2
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(frame.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(imageTitlePadding)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        subscribersLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(titleAuthorPadding)
            make.leading.trailing.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureForSeries(series: Series, showLastUpdatedText: Bool = false) {
        imageView.setImageAsynchronouslyWithDefaultImage(url: series.largeArtworkImageURL)
        titleLabel.text = series.title
        
        if showLastUpdatedText {
            subscribersLabel.text = series.lastUpdatedString == "" ? "Never updated" : "Last updated \(series.lastUpdatedString)"

        } else {
            subscribersLabel.text = series.numberOfSubscribers.shortString() + (series.numberOfSubscribers == 1 ? " Subscriber" : " Subscribers")
        }
    }
}
