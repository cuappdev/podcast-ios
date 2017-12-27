//
//  SearchSeriesTableViewCell.swift
//  Podcast
//
//  Created by Kevin Greer on 3/6/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol SearchSeriesTableViewDelegate: class {
    func searchSeriesTableViewCellDidPressSubscribeButton(cell: SearchSeriesTableViewCell)
}

class SearchSeriesTableViewCell: UITableViewCell {

    static let height: CGFloat =  95
    
    let imageViewPaddingX: CGFloat = 18
    let imageViewPaddingY: CGFloat = 18
    let imageViewWidth: CGFloat = 60
    let imageViewHeight: CGFloat = 60
    let imageViewLabelPadding: CGFloat = 12
    let titleLabelHeight: CGFloat = 17
    let publisherLabelHeight: CGFloat = 15
    let subscribersLabelHeight: CGFloat = 15
    let subscribeButtonPaddingX: CGFloat = 18
    let subscribeButtonPaddingY: CGFloat = 31
    let subscribeButtonHeight: CGFloat = 34
    let subscribeButtonWidth: CGFloat = 34
    let separatorHeight: CGFloat = 1
    
    var seriesImageView: ImageView!
    var titleLabel: UILabel!
    var publisherLabel: UILabel!
    var subscribersLabel: UILabel!
    var subscribeButton: UIButton!
    var separator: UIView!
    
    var index: Int!
    
    weak var delegate: SearchSeriesTableViewDelegate?
    
    var subscribeButtonPressed: Bool = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none 
        seriesImageView = ImageView(frame: CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight))
        contentView.addSubview(seriesImageView)
        
        titleLabel = UILabel()
        titleLabel.font = ._16SemiboldFont()
        contentView.addSubview(titleLabel)
        
        publisherLabel = UILabel()
        publisherLabel.font = ._12RegularFont()
        publisherLabel.textColor = .slateGrey
        contentView.addSubview(publisherLabel)
        
        subscribersLabel = UILabel()
        subscribersLabel.font = ._12RegularFont()
        subscribersLabel.textColor = .charcoalGrey
        contentView.addSubview(subscribersLabel)
        
        subscribeButton = FillButton(type: .subscribePicture)
        subscribeButton.addTarget(self, action: #selector(didPressSubscribeButton), for: .touchUpInside)
        contentView.addSubview(subscribeButton)
        
        separator = UIView()
        separator.backgroundColor = .silver
        contentView.addSubview(separator)
        
        separator.snp.makeConstraints { make in
            make.height.equalTo(separatorHeight)
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview().inset(imageViewPaddingX + imageViewWidth)
            make.trailing.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        seriesImageView.frame = CGRect(x: imageViewPaddingX, y: imageViewPaddingY, width: imageViewWidth, height: imageViewHeight)
        let titleLabelX: CGFloat = seriesImageView.frame.maxX + imageViewLabelPadding
        let subscribeButtonX: CGFloat = frame.width - subscribeButtonPaddingX - subscribeButtonWidth
        titleLabel.frame = CGRect(x: titleLabelX, y: imageViewPaddingY-2, width: subscribeButtonX - titleLabelX, height: titleLabelHeight)
        publisherLabel.frame = CGRect(x: titleLabelX, y: titleLabel.frame.maxY, width: titleLabel.frame.width, height: publisherLabelHeight)
        subscribersLabel.frame = CGRect(x: titleLabelX, y: seriesImageView.frame.maxY - subscribersLabelHeight, width: titleLabel.frame.width, height: subscribersLabelHeight)
        subscribeButton.frame = CGRect(x: subscribeButtonX, y: subscribeButtonPaddingY, width: subscribeButtonWidth, height: subscribeButtonHeight)
        separatorInset = UIEdgeInsets(top: 0, left: titleLabelX, bottom: 0, right: 0)
    }
    
    func configure(for series: Series, index: Int) {
        self.index = index
        seriesImageView.setImageAsynchronouslyWithDefaultImage(url: series.largeArtworkImageURL) //TODO: revist and maybe make this smallArtworkImageURL
        seriesImageView.sizeToFit()
        setSubscribeButtonToState(isSubscribed: series.isSubscribed, numberOfSubscribers: series.numberOfSubscribers)
        titleLabel.text = series.title
        publisherLabel.text = series.author
    }
    
    @objc func didPressSubscribeButton() {
        delegate?.searchSeriesTableViewCellDidPressSubscribeButton(cell: self)
    }
    
    func setSubscribeButtonToState(isSubscribed: Bool, numberOfSubscribers: Int) {
        subscribeButton.isSelected = isSubscribed
        subscribersLabel.text = numberOfSubscribers.shortString() + " Subscribers"
    }
}
