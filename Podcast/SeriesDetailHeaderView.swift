//
//  SeriesDetailHeaderView.swift
//  Podcast
//
//  Created by Drew Dunne on 2/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol SeriesDetailHeaderViewDelegate {
    func seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: SeriesDetailHeaderView, index: Int)
    func seriesDetailHeaderViewDidPressMoreTagsButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressSettingsButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressShareButton(seriesDetailHeader: SeriesDetailHeaderView)
}

class SeriesDetailHeaderView: UIView {
    
    // Constants
    static let infoViewHeight: CGFloat = 345.0
    static let separatorHeight: CGFloat = 1.0
    static let tagsHeight: CGFloat = 86.0
    static let height: CGFloat = SeriesDetailHeaderView.infoViewHeight + SeriesDetailHeaderView.separatorHeight + SeriesDetailHeaderView.tagsHeight
    
    let infoViewHeight: CGFloat = SeriesDetailHeaderView.infoViewHeight
    let separatorHeight: CGFloat = SeriesDetailHeaderView.separatorHeight
    let tagsHeight: CGFloat = SeriesDetailHeaderView.tagsHeight
    let padding: CGFloat = 18.0
    let imageHeight: CGFloat = 80.0
    let titleY: CGFloat = 37.0
    let titleHeight: CGFloat = 24.0
    let publisherY: CGFloat = 62.0
    let publisherHeight: CGFloat = 17.0
    let descY: CGFloat = 114.0
    let descHeight: CGFloat = 54.0
    let hostLabelY: CGFloat = 186
    let hostEpisodeLabelHeight: CGFloat = 18
    let lastEpisodeLabelY: CGFloat = 236
    let subscribeY: CGFloat = 173.0
    let subscribeWidth: CGFloat = 103.0
    let subscribeHeight: CGFloat = 35.0
    let smallButtonBottomY: CGFloat = 26.0
    let smallButtonSideLength: CGFloat = 20.0
    let relatedTagsHeight: CGFloat = 14.0
    let relatedTagsY: CGFloat = 12.0
    let tagButtonHeight: CGFloat = 34.0
    let tagButtonY: CGFloat = 36.0
    let tagButtonOuterXPadding: CGFloat = 9.0
    let tagButtonInnerXPadding: CGFloat = 12.0
    
    var infoView: UIView!
    var viewSeparator: UIView!
    var tagsView: UIView!
    
    var moreTagsIndex: Int = 0
    
    // Contain all Series information, not accessible outside, set through series variable
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var publisherButton: UIButton!
    var descriptionLabel: UILabel!
    var hostLabel: UILabel!
    var hostNameLabel: UILabel!
    var lastEpisodeLabel: UILabel!
    var lastEpisodeDateLabel: UILabel!
    var subscribeButton: FillButton!
    var settingsButton: UIButton!
    var shareButton: UIButton!
    
    private var relatedTagsLabel: UILabel!
    
    var delegate: SeriesDetailHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        infoView = UIView()
        infoView.backgroundColor = .white
        infoView.clipsToBounds = true
        
        imageView = UIImageView()
        titleLabel = UILabel()
        titleLabel.textColor = .podcastBlack
        titleLabel.font = .systemFont(ofSize: 20, weight: UIFontWeightSemibold)
        publisherButton = UIButton(type: .system)
        publisherButton.setTitleColor(.podcastGrayDark, for: .normal)
        publisherButton.titleLabel?.font = .systemFont(ofSize: 14, weight: UIFontWeightRegular)
        publisherButton.titleLabel?.textAlignment = .left
        publisherButton.contentHorizontalAlignment = .left
        descriptionLabel = UILabel()
        descriptionLabel.textColor = .podcastBlack
        descriptionLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightRegular)
        descriptionLabel.numberOfLines = 0
        hostLabel = UILabel()
        hostLabel.text = "Hosted by"
        hostLabel.textColor = .podcastGrayLight
        hostLabel.font = .systemFont(ofSize: 12, weight: UIFontWeightRegular)
        hostNameLabel = UILabel()
        hostNameLabel.textColor = .podcastBlack
        hostNameLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightRegular)
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
        infoView.addSubview(publisherButton)
        infoView.addSubview(descriptionLabel)
        infoView.addSubview(hostLabel)
        infoView.addSubview(hostNameLabel)
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
        imageView.frame = CGRect(x: padding, y: padding, width: imageHeight, height: imageHeight)
        let titleX = 2 * padding + imageHeight
        titleLabel.frame = CGRect(x: titleX, y: titleY, width: frame.width - titleX - padding, height: titleHeight)
        publisherButton.frame = CGRect(x: titleX, y: publisherY, width: frame.width - titleX - padding, height: publisherHeight)
        descriptionLabel.frame = CGRect(x: padding, y: descY, width: frame.width - 2 * padding, height: descHeight)
        hostLabel.sizeToFit()
        hostLabel.frame = CGRect(x: padding, y: hostLabelY, width: hostLabel.frame.width, height: hostEpisodeLabelHeight)
        hostNameLabel.frame = CGRect(x: padding, y: hostLabelY + hostEpisodeLabelHeight, width: frame.width - 2 * padding, height: hostEpisodeLabelHeight)
        lastEpisodeLabel.sizeToFit()
        lastEpisodeLabel.frame = CGRect(x: padding, y: lastEpisodeLabelY, width: lastEpisodeLabel.frame.width, height: hostEpisodeLabelHeight)
        lastEpisodeDateLabel.frame = CGRect(x: padding, y: lastEpisodeLabelY + hostEpisodeLabelHeight, width: frame.width - 2 * padding, height: hostEpisodeLabelHeight)
        subscribeButton.frame = CGRect(x: padding, y: infoViewHeight - padding - subscribeHeight, width: subscribeWidth, height: subscribeHeight)
        settingsButton.frame = CGRect(x: 2 * padding + subscribeWidth, y: infoViewHeight - smallButtonBottomY - smallButtonSideLength, width: smallButtonSideLength, height: smallButtonSideLength)
        shareButton.frame = CGRect(x: frame.width - padding - smallButtonSideLength, y: infoViewHeight - smallButtonBottomY - smallButtonSideLength, width: smallButtonSideLength, height: smallButtonSideLength)
        
        infoView.frame = CGRect(x: 0, y: 0, width: frame.width, height: infoViewHeight)
        viewSeparator.frame = CGRect(x: 0, y: infoViewHeight, width: frame.width, height: separatorHeight)
        tagsView.frame = CGRect(x: 0, y: infoViewHeight+separatorHeight, width: frame.width, height: tagsHeight)
        
        relatedTagsLabel.sizeToFit()
        relatedTagsLabel.frame = CGRect(x: padding, y: relatedTagsY, width: relatedTagsLabel.frame.width, height: relatedTagsHeight)
        
    }
    
    func setSeries(series: Series) {
        titleLabel.text = series.title
        descriptionLabel.text = series.descriptionText
        publisherButton.setTitle("\(series.author)", for: .normal)
        if let url = series.smallArtworkImageURL {
            if let data = try? Data(contentsOf: url) {
                imageView.image = UIImage(data: data)
            }
        } else {
            imageView.image = #imageLiteral(resourceName: "sample_series_artwork")
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
                tagButton.frame = CGRect(x: padding+offset, y: tagButtonY, width: tagButton.frame.width + 2 * tagButtonInnerXPadding, height: tagButtonHeight)
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
            moreTags.frame = CGRect(x: padding + offset, y: tagButtonY, width: moreTags.frame.width + 2 * tagButtonInnerXPadding, height: tagButtonHeight)
            moreTags.addTarget(self, action: #selector(self.tagButtonPressed(button:)), for: .touchUpInside)
            tagsView.addSubview(moreTags)
        }
    }
    
    @objc func tagButtonPressed(button: FillButton) {
        delegate?.seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: self, index: button.tag)
    }
    
    @objc func moreTagsPressed() {
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
