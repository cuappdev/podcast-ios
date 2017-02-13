//
//  SeriesDetailHeaderView.swift
//  Podcast
//
//  Created by Drew Dunne on 2/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol SeriesDetailHeaderViewDelegate {
    func subscribeButtonPressed(subscribed: Bool)
    func tagButtonPressed(index: Int)
}

class SeriesDetailHeaderView: UIView {
    
    // Constants
    static let infoViewH: CGFloat = 345.0
    static let separatorH: CGFloat = 1.0
    static let tagsH: CGFloat = 86.0
    static let height: CGFloat = SeriesDetailHeaderView.infoViewH + SeriesDetailHeaderView.separatorH + SeriesDetailHeaderView.tagsH
    
    let infoViewH: CGFloat = SeriesDetailHeaderView.infoViewH
    let separatorH: CGFloat = SeriesDetailHeaderView.separatorH
    let tagsH: CGFloat = SeriesDetailHeaderView.tagsH
    let padding: CGFloat = 18.0
    let imageH: CGFloat = 80.0
    let titleY: CGFloat = 37.0
    let titleH: CGFloat = 24.0
    let publisherY: CGFloat = 62.0
    let publisherH: CGFloat = 17.0
    let descY: CGFloat = 114.0
    let descH: CGFloat = 54.0
    let hostLabelY: CGFloat = 186
    let hostEpiLabelH: CGFloat = 18
    let lastEpiLabelY: CGFloat = 236
    let subscribeY: CGFloat = 173.0
    let subscribeW: CGFloat = 103.0
    let subscribeH: CGFloat = 35.0
    let smallButtonBY: CGFloat = 26.0
    let smallButtonS: CGFloat = 20.0
    let relatedTagsH: CGFloat = 14.0
    let relatedTagsY: CGFloat = 12.0
    let tagButtonH: CGFloat = 34.0
    let tagButtonY: CGFloat = 36.0
    let tagButtonPadding: CGFloat = 9.0
    let tagButtonInnerXPadding: CGFloat = 12.0
    
    var infoView: UIView!
    var viewSeparator: UIView!
    var tagsView: UIView!
    
    // Contain all Series information, not accessible outside, set through series variable
    private var imageView: UIImageView!
    private var titleLabel: UILabel!
    private var publisherButton: UIButton!
    private var descLabel: UILabel!
    private var hostLabel: UILabel!
    private var hostNameLabel: UILabel!
    private var lastEpisodeLabel: UILabel!
    private var lastEpisodeDateLabel: UILabel!
    private var subscribeButton: SubscribeButton!
    private var settingsButton: UIButton!
    private var shareButton: UIButton!
    
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
        descLabel = UILabel()
        descLabel.textColor = .podcastBlack
        descLabel.font = .systemFont(ofSize: 14, weight: UIFontWeightRegular)
        descLabel.numberOfLines = 0
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
        subscribeButton = SubscribeButton()
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.setTitle("Subscribed", for: .selected)
        subscribeButton.setTitleColor(.podcastTeal, for: .normal)
        subscribeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: UIFontWeightRegular)
        subscribeButton.addTarget(self, action: #selector(SeriesDetailHeaderView.subscribeWasPressed), for: .touchUpInside)
        subscribeButton.isEnabled = true
        settingsButton = UIButton(type: .custom)
        settingsButton.adjustsImageWhenHighlighted = true
        settingsButton.setImage(#imageLiteral(resourceName: "settingsButton"), for: .normal)
        settingsButton.isHidden = true
        shareButton = UIButton(type: .custom)
        shareButton.adjustsImageWhenHighlighted = true
        shareButton.setImage(#imageLiteral(resourceName: "shareButton"), for: .normal)
        
        infoView.addSubview(imageView)
        infoView.addSubview(titleLabel)
        infoView.addSubview(publisherButton)
        infoView.addSubview(descLabel)
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
        imageView.frame = CGRect(x: padding, y: padding, width: imageH, height: imageH)
        let titleX = 2*padding+imageH
        titleLabel.frame = CGRect(x: titleX, y: titleY, width: frame.width - titleX - padding, height: titleH)
        publisherButton.frame = CGRect(x: titleX, y: publisherY, width: frame.width - titleX - padding, height: publisherH)
        descLabel.frame = CGRect(x: padding, y: descY, width: frame.width - 2*padding, height: descH)
        hostLabel.sizeToFit()
        hostLabel.frame = CGRect(x: padding, y: hostLabelY, width: hostLabel.frame.width, height: hostEpiLabelH)
        hostNameLabel.frame = CGRect(x: padding, y: hostLabelY+hostEpiLabelH, width: frame.width - 2*padding, height: hostEpiLabelH)
        lastEpisodeLabel.sizeToFit()
        lastEpisodeLabel.frame = CGRect(x: padding, y: lastEpiLabelY, width: lastEpisodeLabel.frame.width, height: hostEpiLabelH)
        lastEpisodeDateLabel.frame = CGRect(x: padding, y: lastEpiLabelY+hostEpiLabelH, width: frame.width - 2*padding, height: hostEpiLabelH)
        subscribeButton.frame = CGRect(x: padding, y: infoViewH - padding - subscribeH, width: subscribeW, height: subscribeH)
        settingsButton.frame = CGRect(x: 2*padding + subscribeW, y: infoViewH - smallButtonBY - smallButtonS, width: smallButtonS, height: smallButtonS)
        shareButton.frame = CGRect(x: frame.width - padding - smallButtonS, y: infoViewH - smallButtonBY - smallButtonS, width: smallButtonS, height: smallButtonS)
        
        infoView.frame = CGRect(x: 0, y: 0, width: frame.width, height: infoViewH)
        viewSeparator.frame = CGRect(x: 0, y: infoViewH, width: frame.width, height: separatorH)
        tagsView.frame = CGRect(x: 0, y: infoViewH+separatorH, width: frame.width, height: tagsH)
        
        relatedTagsLabel.sizeToFit()
        relatedTagsLabel.frame = CGRect(x: padding, y: relatedTagsY, width: relatedTagsLabel.frame.width, height: relatedTagsH)
        
//        let moreTags = TagButton.tagButton()
//        moreTags.setTitle("+8", for: .normal)
//        moreTags.sizeToFit()
//        moreTags.frame = CGRect(x: padding, y: tagButtonY, width: moreTags.frame.width+2*tagButtonInnerXPadding, height: tagButtonH)
//        tagsView.addSubview(moreTags)
        
    }
    
    func updateViewWithSeries(series: Series) {
        titleLabel.text = series.title
        descLabel.text = series.desc
        publisherButton.setTitle("\(series.publisher) >", for: .normal)
        imageView.image = series.largeArtworkImage!
        
        // Create tags
        var remainingWidth = frame.width - 2*padding
        let moreTags = TagButton.tagButton()
        moreTags.setTitle("+\(series.tags.count)", for: .normal)
        moreTags.sizeToFit()
        remainingWidth = remainingWidth - (moreTags.frame.width+2*tagButtonInnerXPadding + tagButtonPadding)
        var offset: CGFloat = 0
        var numAdded = 0
        for index in 0 ..< series.tags.count {
            let tag = series.tags[index]
            let tagB = TagButton.tagButton()
            tagB.setTitle(tag, for: .normal)
            tagB.sizeToFit()
            let width = tagB.frame.width + 2*tagButtonInnerXPadding
            if width < remainingWidth {
                // Add tag
                tagB.frame = CGRect(x: padding+offset, y: tagButtonY, width: tagB.frame.width+2*tagButtonInnerXPadding, height: tagButtonH)
                tagB.tag = index
                tagB.addTarget(self, action: #selector(self.tagButtonPressed(button:)), for: .touchUpInside)
                tagsView.addSubview(tagB)
                remainingWidth = remainingWidth - (tagB.frame.width + tagButtonPadding)
                offset = offset + (tagB.frame.width + tagButtonPadding)
                numAdded += 1
            }
        }
        moreTags.setTitle("+\(series.tags.count-numAdded)", for: .normal)
        moreTags.sizeToFit()
        moreTags.frame = CGRect(x: padding+offset, y: tagButtonY, width: moreTags.frame.width+2*tagButtonInnerXPadding, height: tagButtonH)
        tagsView.addSubview(moreTags)
    }
    
    @objc private func tagButtonPressed(button: TagButton) {
        
    }
    
    @objc private func subscribeWasPressed() {
        guard let delegate = delegate else { return }
        subscribeButton.isSelected = !subscribeButton.isSelected
        settingsButton.isHidden = !subscribeButton.isSelected
        delegate.subscribeButtonPressed(subscribed: subscribeButton.isSelected)
    }
    
}
