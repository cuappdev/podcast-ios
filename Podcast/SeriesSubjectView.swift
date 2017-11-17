//
//  SeriesFeedElementSubjectView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import Hero

protocol SeriesSubjectViewDelegate: class {
    func seriesSubjectViewDidPressSubscribeButton(seriesSubjectView: SeriesSubjectView)
}

class SeriesSubjectView: UIView {
    
    ///
    /// Mark: Variables
    ///
    var container: UIView!
    var seriesImageView: ImageView!
    var seriesNameLabel: UILabel!
    var lastUpdatedLabel: UILabel!
    var tagsLabel: UILabel!
    var subscribeButton: FillNumberButton!
    weak var delegate: SeriesSubjectViewDelegate?
    
    // Mark: Constants
    let separatorHeight: CGFloat = 9
    let seriesImageSize: CGFloat = 165
    let seriesImageWidthMultiplier: CGFloat = 0.44
    let padding: CGFloat = 18
    let smallPadding: CGFloat = 4
    let subscribeButtonSize: CGSize = CGSize(width: 123, height: 34)
    let subscribeButtonBottomPadding: CGFloat = 24
    let subscribeButtonTopPadding: CGFloat = 50
    
    
    init() {
        super.init(frame: .zero)
        
        backgroundColor = .paleGrey

        container = UIView()
        container.backgroundColor = .offWhite
        addSubview(container)
        
        seriesImageView = ImageView(frame: CGRect(x: 0, y: 0, width: seriesImageSize, height: seriesImageSize))
        container.addSubview(seriesImageView)
        
        seriesNameLabel = UILabel()
        seriesNameLabel.textColor = .offBlack
        seriesNameLabel.font = ._20SemiboldFont()
        container.addSubview(seriesNameLabel)
        
        lastUpdatedLabel = UILabel()
        lastUpdatedLabel.textColor = .slateGrey
        lastUpdatedLabel.font = ._12RegularFont()
        container.addSubview(lastUpdatedLabel)
        
        tagsLabel = UILabel()
        tagsLabel.textColor = .slateGrey
        tagsLabel.numberOfLines = 3
        tagsLabel.font = ._12RegularFont()
        container.addSubview(tagsLabel)
        
        subscribeButton = FillNumberButton(type: .subscribe)
        subscribeButton.addTarget(self, action: #selector(didPressSeriesSubjectViewSubscribeButton), for: .touchUpInside)
        container.addSubview(subscribeButton)
        
        seriesImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(padding)
            make.bottom.equalToSuperview().inset(padding)
            make.width.equalToSuperview().multipliedBy(seriesImageWidthMultiplier)
            make.height.equalTo(seriesImageView.snp.width)
        }
        
        seriesNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(seriesImageView.snp.trailing).offset(padding)
            make.trailing.lessThanOrEqualToSuperview().inset(padding)
            make.top.equalTo(seriesImageView.snp.top)
        }
        
        lastUpdatedLabel.snp.makeConstraints { make in
            make.top.equalTo(seriesNameLabel.snp.bottom).offset(smallPadding)
            make.leading.equalTo(seriesNameLabel.snp.leading)
            make.trailing.equalToSuperview().inset(padding)
        }
        
        tagsLabel.snp.makeConstraints { make in
            make.top.equalTo(lastUpdatedLabel.snp.bottom).offset(smallPadding * 4)
            make.leading.equalTo(seriesNameLabel.snp.leading)
            make.trailing.equalTo(lastUpdatedLabel.snp.trailing)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.leading.equalTo(seriesNameLabel.snp.leading)
            make.size.equalTo(subscribeButtonSize)
            make.bottom.equalToSuperview().inset(subscribeButtonBottomPadding)
        }

        container.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(separatorHeight)
        }
    }
    
    convenience init(series: Series) {
        self.init()
        setupWithSeries(series: series)
    }
    
    func setupWithSeries(series: Series) {
        seriesImageView.setImageAsynchronouslyWithDefaultImage(url: series.largeArtworkImageURL)
        seriesNameLabel.text = series.title
        updateViewWithSubscribeState(isSubscribed: series.isSubscribed, numberOfSubscribers: series.numberOfSubscribers)
        lastUpdatedLabel.text = "Last updated " + series.lastUpdatedString
        tagsLabel.text = series.tagString

        seriesNameLabel.heroID = Series.Animation.cellTitle.id(series: series)
        seriesNameLabel.heroModifiers = [.source(heroID: Series.Animation.detailTitle.id(series: series)), .fade]
        subscribeButton.heroID = Series.Animation.subscribe.id(series: series)
        seriesImageView.heroID = Series.Animation.container.id(series: series)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressSeriesSubjectViewSubscribeButton() {
        delegate?.seriesSubjectViewDidPressSubscribeButton(seriesSubjectView: self)
    }
    
    func updateViewWithSubscribeState(isSubscribed: Bool, numberOfSubscribers: Int) {
        subscribeButton.setupWithNumber(isSelected: isSubscribed, numberOf: numberOfSubscribers)
    }
}
