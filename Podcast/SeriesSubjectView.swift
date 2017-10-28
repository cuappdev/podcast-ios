//
//  SeriesFeedElementSubjectView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol SeriesSubjectViewDelegate: class {
    func seriesSubjectViewDidPressSubscribeButton(seriesSubjectView: SeriesSubjectView)
}

class SeriesSubjectView: FeedElementSubjectView {
    
    ///
    /// Mark: Variables
    ///
    var seriesImageView: ImageView!
    var seriesNameLabel: UILabel!
    var lastUpdatedLabel: UILabel!
    var tagsLabel: UILabel!
    var subscribeButton: FillButton!
    var separator: UIView!
    weak var delegate: SeriesSubjectViewDelegate?
    
    // Mark: Constants
    let separatorHeight: CGFloat = 9
    let seriesImageSize: CGFloat = 165
    let padding: CGFloat = 18
    let smallPadding: CGFloat = 4
    let subscribeButtonWidth: CGFloat = 123
    let subscribeButtonHeight: CGFloat = 34
    let subscribeButtonBottomPadding: CGFloat = 24
    let subscribeButtonTopPadding: CGFloat = 50
    
    
    override init() {
        super.init()
        backgroundColor = .offWhite
        
        seriesImageView = ImageView(frame: CGRect(x: 0, y: 0, width: seriesImageSize, height: seriesImageSize))
        addSubview(seriesImageView)
        
        seriesNameLabel = UILabel()
        seriesNameLabel.textColor = .offBlack
        seriesNameLabel.font = ._20SemiboldFont()
        addSubview(seriesNameLabel)
        
        lastUpdatedLabel = UILabel()
        lastUpdatedLabel.textColor = .slateGrey
        lastUpdatedLabel.font = ._12RegularFont()
        addSubview(lastUpdatedLabel)
        
        tagsLabel = UILabel()
        tagsLabel.textColor = .slateGrey
        tagsLabel.numberOfLines = 3
        tagsLabel.font = ._12RegularFont()
        addSubview(tagsLabel)
        
        subscribeButton = FillButton(type: .subscribe)
        subscribeButton.addTarget(self, action: #selector(didPressSeriesSubjectViewSubscribeButton), for: .touchUpInside)
        addSubview(subscribeButton)
        
        separator = UIView()
        separator.backgroundColor = .paleGrey
        addSubview(separator)
        
        seriesImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.size.equalTo(seriesImageSize)
            make.centerY.equalToSuperview()
        }
        
        seriesNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(seriesImageView.snp.trailing).offset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(seriesImageView.snp.top)
        }
        
        lastUpdatedLabel.snp.makeConstraints { make in
            make.top.equalTo(seriesNameLabel.snp.bottom).offset(smallPadding)
            make.leading.equalTo(seriesNameLabel.snp.leading)
            make.trailing.equalTo(seriesNameLabel.snp.trailing)
        }
        
        tagsLabel.snp.makeConstraints { make in
            make.top.equalTo(lastUpdatedLabel.snp.bottom).offset(smallPadding * 4)
            make.leading.equalTo(seriesNameLabel.snp.leading)
            make.trailing.equalTo(seriesNameLabel.snp.trailing)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.leading.equalTo(seriesNameLabel.snp.leading)
            make.width.equalTo(subscribeButtonWidth)
            make.height.equalTo(subscribeButtonHeight)
            make.bottom.equalToSuperview().inset(subscribeButtonBottomPadding + separatorHeight)
        }
    
        separator.snp.makeConstraints { make in
            make.top.equalTo(seriesImageView.snp.bottom).offset(padding)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(separatorHeight)
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
        lastUpdatedLabel.text = "Last updated " + series.lastUpdatedAsString()
        tagsLabel.text = series.allTags()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressSeriesSubjectViewSubscribeButton() {
        delegate?.seriesSubjectViewDidPressSubscribeButton(seriesSubjectView: self)
    }
    
    func updateViewWithSubscribeState(isSubscribed: Bool, numberOfSubscribers: Int) {
        let subscribeString = isSubscribed ? "Subscribed  | " + numberOfSubscribers.shortString() : "Subscribe  | " + numberOfSubscribers.shortString()
        subscribeButton.isSelected = isSubscribed
        subscribeButton.setTitle(subscribeString , for:  isSubscribed ? .selected : .normal)
    }
}
