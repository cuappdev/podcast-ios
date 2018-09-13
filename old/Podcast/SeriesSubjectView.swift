//
//  SeriesFeedElementSubjectView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol SeriesSubjectViewDelegate: class {
    func didPress(on action: SeriesAction, for view: SeriesSubjectView)
}

class SeriesSubjectView: UIView {
    
    ///
    /// Mark: Variables
    ///
    var seriesImageView: ImageView!
    var seriesNameLabel: UILabel!
    var lastUpdatedLabel: UILabel!
    var topicsLabel: UILabel!
    var subscribeButton: FillNumberButton!
    var separator: UIView!
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
        
        backgroundColor = .offWhite
        
        seriesImageView = ImageView(frame: CGRect(x: 0, y: 0, width: seriesImageSize, height: seriesImageSize))
        seriesImageView.addCornerRadius(height: seriesImageSize)
        addSubview(seriesImageView)
        
        seriesNameLabel = UILabel()
        seriesNameLabel.textColor = .offBlack
        seriesNameLabel.font = ._20SemiboldFont()
        seriesNameLabel.numberOfLines = 2
        addSubview(seriesNameLabel)
        
        lastUpdatedLabel = UILabel()
        lastUpdatedLabel.textColor = .charcoalGrey
        lastUpdatedLabel.numberOfLines = 2
        lastUpdatedLabel.font = ._12RegularFont()
        addSubview(lastUpdatedLabel)
        
        topicsLabel = UILabel()
        topicsLabel.textColor = .slateGrey
        topicsLabel.numberOfLines = 3
        topicsLabel.font = ._12RegularFont()
        addSubview(topicsLabel)

        subscribeButton = FillNumberButton(type: .subscribe)
        subscribeButton.addTarget(self, action: #selector(didPressSeriesSubjectViewSubscribeButton), for: .touchUpInside)
        addSubview(subscribeButton)
        
        separator = UIView()
        separator.backgroundColor = .paleGrey
        addSubview(separator)
        
        seriesImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(padding)
            make.width.equalToSuperview().multipliedBy(seriesImageWidthMultiplier)
            make.height.equalTo(seriesImageView.snp.width)
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
        
        topicsLabel.snp.makeConstraints { make in
            make.top.equalTo(lastUpdatedLabel.snp.bottom).offset(smallPadding * 4)
            make.leading.equalTo(seriesNameLabel.snp.leading)
            make.trailing.equalTo(seriesNameLabel.snp.trailing)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(topicsLabel.snp.bottom).offset(smallPadding)
            make.leading.equalTo(seriesNameLabel.snp.leading)
            make.size.equalTo(subscribeButtonSize)
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
        lastUpdatedLabel.text = series.lastUpdatedString == "" ? "Never updated" : "Last updated \(series.lastUpdatedString)"
        topicsLabel.text = series.topicString
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressSeriesSubjectViewSubscribeButton() {
        delegate?.didPress(on: .subscribe, for: self)
    }
    
    func updateViewWithSubscribeState(isSubscribed: Bool, numberOfSubscribers: Int) {
        subscribeButton.setupWithNumber(isSelected: isSubscribed, numberOf: numberOfSubscribers)
    }
}
