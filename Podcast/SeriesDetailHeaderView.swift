//
//  SeriesDetailHeaderView.swift
//  Podcast
//
//  Created by Drew Dunne on 2/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

protocol SeriesDetailHeaderViewDelegate: class {
    func seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: SeriesDetailHeaderView, index: Int)
    func seriesDetailHeaderViewDidPressMoreTagsButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressSettingsButton(seriesDetailHeader: SeriesDetailHeaderView)
    func seriesDetailHeaderViewDidPressShareButton(seriesDetailHeader: SeriesDetailHeaderView)
}

class SeriesDetailHeaderView: UIView {
    
    // Constants
    static let minHeight: CGFloat = 308
    static let separatorHeight: CGFloat = 1.0
    static let tagsHeight: CGFloat = 86.0
    
    let separatorHeight: CGFloat = SeriesDetailHeaderView.separatorHeight
    let tagsHeight: CGFloat = SeriesDetailHeaderView.tagsHeight
    let padding: CGFloat = 18.0
    let imageHeight: CGFloat = 80.0
    let subscribeWidth: CGFloat = 97.0
    let subscribeHeight: CGFloat = 34.0
    let subscribeTopOffset: CGFloat = 18.0
    let tagButtonHeight: CGFloat = 34.0
    let tagButtonOuterXPadding: CGFloat = 6.0
    let tagButtonInnerXPadding: CGFloat = 12.0
    let headerViewHeight: CGFloat = 308.5
    let imageViewTopOffset: CGFloat = 24
    let titleLabelTopOffset: CGFloat = 16
    let titleLabelWidth: CGFloat = 259.5
    let titleLabelHeight: CGFloat = 30
    let publisherLabelOffset: CGFloat = 1
    let publisherLabelHeight: CGFloat = 21
    let viewSeparatorHeight: CGFloat = 1
    let tagsViewInsetTop: CGFloat = 18
    let tagsViewInsetSides: CGFloat = 17.5
    let tagsViewHeight: CGFloat = 70
    
    var infoView: UIView!
    var viewSeparator: UIView!
    var tagsView: UIView!
    
    var moreTagsIndex: Int = 0
    
    // Contain all Series information, not accessible outside, set through series variable
    var backgroundImageView: ImageView!
    var imageView: ImageView!
    var titleLabel: UILabel!
    var publisherLabel: UILabel!
    var subscribeButton: FillButton!
    var settingsButton: UIButton!
    var shareButton: UIButton!
    
    weak var delegate: SeriesDetailHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        infoView = UIView()
        infoView.backgroundColor = .offWhite
        infoView.clipsToBounds = true
        
        backgroundImageView = ImageView()
        backgroundImageView.contentMode = .scaleAspectFill

        imageView = ImageView()
        
        let gradientView = UIView()
        gradientView.backgroundColor = .clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: headerViewHeight)
        gradientLayer.colors = [UIColor.gradientWhite.withAlphaComponent(0.9).cgColor, UIColor.gradientWhite.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = .offBlack
        titleLabel.font = ._20SemiboldFont()
        titleLabel.textAlignment = .center
        
        publisherLabel = UILabel(frame: .zero)
        publisherLabel.font = ._14RegularFont()
        publisherLabel.textColor = .charcoalGrey
        publisherLabel.textAlignment = .center
        
        subscribeButton = FillButton(type: .subscribe)
        subscribeButton.setTitle("Subscribe", for: .normal)
        subscribeButton.setTitle("Subscribed", for: .selected)
        subscribeButton.addTarget(self, action: #selector(didPressSubscribeButton), for: .touchUpInside)
        
        shareButton = UIButton(type: .custom)
        shareButton.adjustsImageWhenHighlighted = true
        shareButton.setImage(#imageLiteral(resourceName: "shareButton"), for: .normal)
        shareButton.addTarget(self, action: #selector(shareWasPressed), for: .touchUpInside)
        
        tagsView = UIView()
        tagsView.backgroundColor = .clear
        tagsView.clipsToBounds = true
        
        viewSeparator = UIView()
        viewSeparator.backgroundColor = .paleGrey

        infoView.addSubview(backgroundImageView)
        infoView.addSubview(gradientView)
        infoView.addSubview(imageView)
        infoView.addSubview(titleLabel)
        infoView.addSubview(subscribeButton)
        infoView.addSubview(tagsView)
        infoView.addSubview(publisherLabel)
        infoView.addSubview(viewSeparator)
        
        addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(imageViewTopOffset)
            make.size.equalTo(imageHeight)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(titleLabelTopOffset)
            make.width.equalTo(titleLabelWidth)
            make.height.equalTo(titleLabelHeight)
        }
        
        publisherLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(publisherLabelOffset)
            make.height.equalTo(publisherLabelHeight)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(publisherLabel.snp.bottom).offset(subscribeTopOffset)
            make.width.equalTo(subscribeWidth)
            make.height.equalTo(subscribeHeight)
        }
        
        tagsView.snp.makeConstraints { make in
            make.top.equalTo(subscribeButton.snp.bottom).offset(tagsViewInsetTop)
            make.leading.equalToSuperview().inset(tagsViewInsetSides) // this causes constraint errors and I'm not sure why
            make.trailing.equalToSuperview().inset(tagsViewInsetSides)
            make.height.equalTo(tagsViewHeight)
        }
        
        viewSeparator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(viewSeparatorHeight)
            make.width.equalTo(tagsView.snp.width)
            make.bottom.equalTo(tagsView.snp.top)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSeries(series: Series) {
        titleLabel.text = series.title
        UILabel.adjustHeightToFit(label: titleLabel, numberOfLines: 3)
        publisherLabel.text = series.author
        UILabel.adjustHeightToFit(label: publisherLabel, numberOfLines: 1)
        
        subscribeButtonChangeState(isSelected: series.isSubscribed)

        imageView.setImageAsynchronouslyWithDefaultImage(url: series.largeArtworkImageURL, defaultImage: #imageLiteral(resourceName: "nullSeries"))
        backgroundImageView.setImageAsynchronouslyWithDefaultImage(url: series.largeArtworkImageURL)

        if series.tags.count > 0 {
            setTagsForSeries(series)
        }
    }
    
    func setTagsForSeries(_ series: Series) {
        // set moreTags first
        let moreTags = FillButton(type: .tag)
        tagsView.addSubview(moreTags)
        moreTags.setTitle("+\(series.tags.count)", for: .normal)
        moreTags.sizeToFit()
        moreTags.isEnabled = false
        moreTags.addTarget(self, action: #selector(self.tagButtonPressed(button:)), for: .touchUpInside)
        moreTags.snp.makeConstraints({ make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        
        // TODO: don't add a tag if it's too wide
        var tagsNotDisplayed = 0
        var tagsArray = [FillButton]()
        var lastTagIndex = 0
        
        for i in 0 ..< series.tags.count {
            let newButton = FillButton(type: .tag)
            newButton.setTitle(series.tags[i].name, for: .normal)
            newButton.tag = i
            newButton.addTarget(self, action: #selector(tagButtonPressed(button:)), for: .touchUpInside)
            newButton.isHidden = true
            newButton.sizeToFit()
            tagsArray.append(newButton)
        }
        
        tagsArray.sort {
            $0.frame.width < $1.frame.width
        }
        
        if tagsArray.count > 0 {
            tagsView.addSubview(tagsArray[0])
            tagsArray[0].snp.makeConstraints({ make in
                make.leading.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.equalTo(tagButtonHeight)
                let currWidth = tagsArray[0].frame.width + 2 * tagButtonInnerXPadding
                make.width.equalTo(currWidth)
            })
            tagsArray[0].isHidden = false
            
            var remainingWidth = tagsView.frame.width - moreTags.frame.width - 2 * tagButtonInnerXPadding - tagButtonOuterXPadding
            for i in 1 ..< tagsArray.count {
                let width = tagsArray[i].frame.width + 2 * tagButtonInnerXPadding
                if width < remainingWidth {
                    tagsView.addSubview(tagsArray[i])
                    tagsArray[i].snp.makeConstraints({ make in
                        make.leading.equalTo(tagsArray[i-1].snp.trailing).offset(tagButtonOuterXPadding)
                        make.centerY.equalToSuperview()
                        make.height.equalTo(tagButtonHeight)
                        make.width.equalTo(width)
                    })
                    tagsArray[i].isHidden = false
                    lastTagIndex = i
                    remainingWidth = remainingWidth - width - 2 * tagButtonOuterXPadding
                } else {
                    tagsNotDisplayed += 1
                }
            }
        }
        
        if tagsNotDisplayed > 0 {
            moreTags.setTitle("+\(tagsNotDisplayed)", for: .normal)
            moreTags.snp.remakeConstraints({ make in
                make.leading.equalTo(tagsArray[lastTagIndex].snp.trailing).offset(tagButtonOuterXPadding)
                make.centerY.equalToSuperview()
                let currWidth = moreTags.frame.width + tagButtonInnerXPadding
                make.width.equalTo(currWidth)
                make.height.equalTo(tagButtonHeight)
            })
        } else {
            moreTags.removeFromSuperview()
        }
    }
    
    @objc func tagButtonPressed(button: FillButton) {
        delegate?.seriesDetailHeaderViewDidPressTagButton(seriesDetailHeader: self, index: button.tag)
    }
    
    func moreTagsPressed() {
        delegate?.seriesDetailHeaderViewDidPressMoreTagsButton(seriesDetailHeader: self)
    }
    
    @objc func didPressSubscribeButton() {
        delegate?.seriesDetailHeaderViewDidPressSubscribeButton(seriesDetailHeader: self)
    }
    
    func subscribeButtonChangeState(isSelected: Bool) {
        subscribeButton.isSelected = isSelected
    }
    
    @objc func settingsWasPressed() {
        delegate?.seriesDetailHeaderViewDidPressSettingsButton(seriesDetailHeader: self)
    }
    
    @objc func shareWasPressed() {
        delegate?.seriesDetailHeaderViewDidPressShareButton(seriesDetailHeader: self)
    }
    
}
