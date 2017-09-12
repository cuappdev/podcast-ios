//
//  SeriesDetailHeaderView.swift
//  Podcast
//
//  Created by Drew Dunne on 2/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol SeriesDetailHeaderViewDelegate: class {
    func seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: SeriesDetailHeaderView, index: Int)
    func seriesDetailHeaderViewDidPressMoreTagsButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressSettingsButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressShareButton(seriesDetailHeader: SeriesDetailHeaderView)
}

class SeriesDetailHeaderView: UIView {
    
    // Constants
    static let minHeight: CGFloat = 200
    static let separatorHeight: CGFloat = 1.0
    static let tagsHeight: CGFloat = 86.0
    
    let separatorHeight: CGFloat = SeriesDetailHeaderView.separatorHeight
    let tagsHeight: CGFloat = SeriesDetailHeaderView.tagsHeight
    let padding: CGFloat = 18.0
    let imageHeight: CGFloat = 80.0
    let subscribeWidth: CGFloat = 103.0
    let subscribeHeight: CGFloat = 35.0
    let smallButtonBottomY: CGFloat = 26.0
    let smallButtonSideLength: CGFloat = 20.0
    let relatedTagsHeight: CGFloat = 14.0
    let tagButtonHeight: CGFloat = 34.0
    let tagButtonOuterXPadding: CGFloat = 9.0
    let tagButtonInnerXPadding: CGFloat = 12.0
    let marginPadding: CGFloat = 6
    
    var infoView: UIView!
    var viewSeparator: UIView!
    var tagsView: UIView!
    
    var moreTagsIndex: Int = 0
    
    // Contain all Series information, not accessible outside, set through series variable
    var imageView: ImageView!
    var titleLabel: UILabel!
    var publisherLabel: UILabel!
    var lastEpisodeLabel: UILabel!
    var lastEpisodeDateLabel: UILabel!
    var subscribeButton: FillButton!
    var settingsButton: UIButton!
    var shareButton: UIButton!
    
    private var relatedTagsLabel: UILabel!
    
    weak var delegate: SeriesDetailHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        infoView = UIView()
        infoView.backgroundColor = .white
        infoView.clipsToBounds = true
        
        imageView = ImageView(frame: CGRect(x: padding, y: padding, width: imageHeight, height: imageHeight))
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = .podcastBlack
        titleLabel.font = .systemFont(ofSize: 20, weight: UIFontWeightSemibold)
        
        publisherLabel = UILabel(frame: .zero)
        publisherLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightRegular)
        publisherLabel.textAlignment = .left
    
        lastEpisodeLabel = UILabel()
        lastEpisodeLabel.text = "Last Episode"
        lastEpisodeLabel.textColor = .podcastGrayLight
        lastEpisodeLabel.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        lastEpisodeDateLabel = UILabel()
        lastEpisodeDateLabel.textColor = .podcastBlack
        lastEpisodeDateLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightRegular)
        
        subscribeButton = FillButton(type: .subscribe)
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.setTitle("Subscribed", for: .selected)
        subscribeButton.addTarget(self, action: #selector(didPressSubscribeButton), for: .touchUpInside)
        
        settingsButton = UIButton(type: .custom)
        settingsButton.adjustsImageWhenHighlighted = true
        settingsButton.setImage(#imageLiteral(resourceName: "settingsButton"), for: .normal)
        settingsButton.isHidden = true
        settingsButton.addTarget(self, action: #selector(settingsWasPressed), for: .touchUpInside)
        
        shareButton = UIButton(type: .custom)
        shareButton.adjustsImageWhenHighlighted = true
        shareButton.setImage(#imageLiteral(resourceName: "shareButton"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareWasPressed), for: .touchUpInside)
        
        infoView.addSubview(imageView)
        infoView.addSubview(titleLabel)
        infoView.addSubview(publisherLabel)
        infoView.addSubview(lastEpisodeLabel)
        infoView.addSubview(lastEpisodeDateLabel)
        infoView.addSubview(subscribeButton)
        infoView.addSubview(settingsButton)
        infoView.addSubview(shareButton)
        
        viewSeparator = UIView()
        viewSeparator.backgroundColor = .podcastGray
        
        tagsView = UIView()
        tagsView.backgroundColor = .white
        tagsView.clipsToBounds = true
        
        relatedTagsLabel = UILabel()
        relatedTagsLabel.text = "Similar Tags"
        relatedTagsLabel.textColor = .podcastGrayLight
        relatedTagsLabel.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        
        tagsView.addSubview(relatedTagsLabel)
    
        addSubview(infoView)
        addSubview(viewSeparator)
        addSubview(tagsView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let titleX = 2 * padding + imageHeight
        
        titleLabel.frame = CGRect(x: titleX, y: padding, width: frame.width - titleX - padding, height: 0)
        publisherLabel.frame = CGRect(x: titleX, y: 0, width: frame.width - titleX - padding, height: 0)
        lastEpisodeLabel.frame = CGRect(x: padding, y: 0, width: 0, height: 0)
        lastEpisodeLabel.sizeToFit()
        lastEpisodeDateLabel.frame = CGRect(x: padding, y: 0, width: frame.width - 2 * padding, height: 0)
        UILabel.adjustHeightToFit(label: lastEpisodeDateLabel, numberOfLines: 1)
        
        subscribeButton.frame = CGRect(x: padding, y: 0, width: subscribeWidth, height: subscribeHeight)
        settingsButton.frame = CGRect(x: 2 * padding + subscribeWidth, y: 0, width: smallButtonSideLength, height: smallButtonSideLength)
        shareButton.frame = CGRect(x: frame.width - padding - smallButtonSideLength, y: 0, width: smallButtonSideLength, height: smallButtonSideLength)
        
        infoView.frame = CGRect(x: 0, y: 0, width: frame.width, height: SeriesDetailHeaderView.minHeight)
        viewSeparator.frame = CGRect(x: 0, y: 0, width: frame.width, height: separatorHeight)
        tagsView.frame = CGRect(x: 0, y: 0, width: frame.width, height: tagsHeight)
        
        relatedTagsLabel.sizeToFit()
        relatedTagsLabel.frame.origin.x = padding
        
    }
    
    func setSeries(series: Series) {
        titleLabel.text = series.title
        UILabel.adjustHeightToFit(label: titleLabel, numberOfLines: 3)
        publisherLabel.text = series.author
        publisherLabel.frame.origin.y = titleLabel.frame.maxY + marginPadding
        UILabel.adjustHeightToFit(label: publisherLabel, numberOfLines: 1)
        let lastEpisodeLabelY = publisherLabel.frame.maxY > imageView.frame.maxY ? publisherLabel.frame.maxY + padding : imageView.frame.maxY + padding
        lastEpisodeLabel.frame.origin.y = lastEpisodeLabelY
        lastEpisodeDateLabel.text = Date.formatDateDifferenceByLargestComponent(fromDate: series.lastUpdated, toDate: Date())
        lastEpisodeDateLabel.frame.origin.y = lastEpisodeLabel.frame.maxY + marginPadding
        subscribeButton.frame.origin.y = lastEpisodeDateLabel.frame.maxY + padding
        shareButton.center.y = subscribeButton.center.y
        settingsButton.center.y = subscribeButton.center.y
        infoView.frame.size.height = subscribeButton.frame.maxY + padding
        viewSeparator.frame.origin.y = infoView.frame.maxY
        tagsView.frame.origin.y = infoView.frame.maxY + separatorHeight
        relatedTagsLabel.frame.origin.y = viewSeparator.frame.maxY + marginPadding
        
        subscribeButtonChangeState(isSelected: series.isSubscribed)
        if let url = series.largeArtworkImageURL{
            imageView.setImageAsynchronously(url: url, completion: nil)
        } else {
            imageView.image = #imageLiteral(resourceName: "nullSeries")
        }
        // Create tags (Need no tags design)
        var remainingWidth = frame.width - 2 * padding
        let moreTags = FillButton(type: .tag)
        moreTags.setTitle("+\(series.tags.count)", for: .normal)
        moreTags.sizeToFit()
        remainingWidth = remainingWidth - (moreTags.frame.width + 2 * tagButtonInnerXPadding + tagButtonOuterXPadding)
        var offset: CGFloat = 0
        var numAdded = 0
        for index in 0 ..< series.tags.count {
            let tag = series.tags[index]
            let tagButton = FillButton(type: .tag)
            tagButton.setTitle(tag.name, for: .normal)
            tagButton.sizeToFit()
            let width = tagButton.frame.width + 2 * tagButtonInnerXPadding
            if width < remainingWidth {
                // Add tag
                tagButton.frame = CGRect(x: padding+offset, y: relatedTagsLabel.frame.maxY + padding, width: tagButton.frame.width + 2 * tagButtonInnerXPadding, height: tagButtonHeight)
                tagButton.tag = index
                tagButton.addTarget(self, action: #selector(tagButtonPressed(button:)), for: .touchUpInside)
                tagsView.addSubview(tagButton)
                remainingWidth = remainingWidth - (tagButton.frame.width + tagButtonOuterXPadding)
                offset = offset + (tagButton.frame.width + tagButtonOuterXPadding)
                numAdded += 1
            }
        }
        moreTagsIndex = numAdded
        if numAdded != series.tags.count {
            moreTags.setTitle("+\(series.tags.count-numAdded)", for: .normal)
            moreTags.isEnabled = false 
            moreTags.sizeToFit()
            moreTags.frame = CGRect(x: padding + offset, y: relatedTagsLabel.frame.maxY + padding, width: moreTags.frame.width + 2 * tagButtonInnerXPadding, height: tagButtonHeight)
            moreTags.addTarget(self, action: #selector(self.tagButtonPressed(button:)), for: .touchUpInside)
            tagsView.addSubview(moreTags)
        }
    }
    
    @objc func tagButtonPressed(button: FillButton) {
        delegate?.seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: self, index: button.tag)
    }
    
    func moreTagsPressed() {
        delegate?.seriesDetailHeaderViewDidPressMoreTagsButton(seriesDetailHeader: self)
    }
    
    func didPressSubscribeButton() {
        delegate?.seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: self)
    }
    
    func subscribeButtonChangeState(isSelected: Bool) {
        subscribeButton.isSelected = isSelected
        settingsButton.isHidden = !subscribeButton.isSelected
    }
    
    func settingsWasPressed() {
        delegate?.seriesDetailHeaderViewDidPressSettingsButton(seriesDetailHeader: self)
    }
    
    func shareWasPressed() {
        delegate?.seriesDetailHeaderViewDidPressShareButton(seriesDetailHeader: self)
    }
    
}
