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
    let subscribeWidth: CGFloat = 103.0
    let subscribeHeight: CGFloat = 35.0
    let smallButtonBottomY: CGFloat = 26.0
    let smallButtonSideLength: CGFloat = 20.0
    let relatedTagsHeight: CGFloat = 14.0
    let tagButtonHeight: CGFloat = 34.0
    let tagButtonOuterXPadding: CGFloat = 6.0
    let tagButtonInnerXPadding: CGFloat = 12.0
    let marginPadding: CGFloat = 6
    
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
        infoView.backgroundColor = .white
        infoView.clipsToBounds = true
        
        backgroundImageView = ImageView()
        backgroundImageView.contentMode = .scaleAspectFill

        imageView = ImageView()
        
        let gradientView = UIView()
        gradientView.backgroundColor = .clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.width, height: 308.5)
        gradientLayer.colors = [UIColor.seriesDetailGradientWhite.withAlphaComponent(0.9).cgColor, UIColor.seriesDetailGradientWhite.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        
        titleLabel = UILabel(frame: .zero)
        titleLabel.textColor = .podcastBlack
        titleLabel.font = .systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        titleLabel.textAlignment = .center
        
        publisherLabel = UILabel(frame: .zero)
        publisherLabel.font = .systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        publisherLabel.textColor = .podcastGray
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
        viewSeparator.backgroundColor = .podcastGray

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
            make.height.equalTo(308.0)
            make.width.equalToSuperview()
        }
        
//        infoView.addSubview(shareButton)
        
        backgroundImageView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(24.0)
            make.size.equalTo(CGSize(width: imageHeight, height: imageHeight))
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(16.0)
            make.width.equalTo(259.5)
            make.height.equalTo(30.0)
        }
        
        publisherLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.width.equalToSuperview()
            make.height.equalTo(21.0)
        }
        
        subscribeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(publisherLabel.snp.bottom).offset(18.5)
            make.width.equalTo(97.0)
            make.height.equalTo(34.0)
        }
        
        tagsView.snp.makeConstraints { make in
            make.top.equalTo(subscribeButton.snp.bottom).offset(18.0)
            make.leading.equalToSuperview().inset(17.5) // this causes constraint errors and I'm not sure why
            make.trailing.equalToSuperview().inset(17.5)
            make.height.equalTo(70.0)
        }
        
        viewSeparator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(1.0)
            make.width.equalTo(tagsView.snp.width)
            make.bottom.equalTo(tagsView.snp.top)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSeries(series: Series) {
        let titleX = 2 * padding + imageHeight
        titleLabel.text = series.title
        UILabel.adjustHeightToFit(label: titleLabel, numberOfLines: 3)
        publisherLabel.text = series.author
        UILabel.adjustHeightToFit(label: publisherLabel, numberOfLines: 1)
        
        // Share button not in current design
        shareButton.frame = CGRect(x: frame.width - padding - smallButtonSideLength, y: 0, width: smallButtonSideLength, height: smallButtonSideLength)
        
        shareButton.center.y = subscribeButton.center.y
        
        subscribeButtonChangeState(isSelected: series.isSubscribed)
        if let url = series.largeArtworkImageURL{
            imageView.setImageAsynchronously(url: url, completion: nil)
            backgroundImageView.setImageAsynchronously(url: url, completion: nil)
        } else {
            imageView.image = #imageLiteral(resourceName: "sample_series_artwork")
            backgroundImageView.image = #imageLiteral(resourceName: "sample_series_artwork")
        }
        if series.tags.count > 0 {
            // Create tags (Need no tags design)
            // TODO: redo this
            /*
            var remainingWidth = frame.width - 2 * padding
            let moreTags = FillButton(type: .tag)
            moreTags.setTitle("+\(series.tags.count)", for: .normal)
            moreTags.sizeToFit()
            remainingWidth = remainingWidth - (moreTags.frame.width + 2 * tagButtonInnerXPadding + tagButtonOuterXPadding)
            var numAdded = 0
            var offset: CGFloat = 0
            for index in 0 ..< series.tags.count {
                let tag = series.tags[index]
                let tagButton = FillButton(type: .tag)
                tagButton.tag = index
                tagButton.setTitle(tag.name, for: .normal)
                tagButton.sizeToFit()
                let width = tagButton.frame.width + 2 * tagButtonInnerXPadding
                if width < remainingWidth {
                    // Add tag
                    tagsView.addSubview(tagButton)
                    tagButton.tag = index
                    tagButton.addTarget(self, action: #selector(tagButtonPressed(button:)), for: .touchUpInside)
                        tagButton.snp.makeConstraints({ make in
                            make.width.equalTo(width)
                            make.height.equalTo(tagButtonHeight)
                            make.centerY.equalToSuperview()
                            make.leading.equalTo(offset)
                        })
                    
                    offset = offset + width + tagButtonOuterXPadding
                    remainingWidth = remainingWidth - (width + tagButtonOuterXPadding)
                    numAdded += 1
                }
            }
            moreTagsIndex = numAdded
            if numAdded != series.tags.count {
                moreTags.setTitle("+\(series.tags.count-numAdded)", for: .normal)
                moreTags.isEnabled = false
                moreTags.sizeToFit()
                moreTags.addTarget(self, action: #selector(self.tagButtonPressed(button:)), for: .touchUpInside)
                tagsView.addSubview(moreTags)

                moreTags.snp.makeConstraints({ make in
                    make.width.equalTo(moreTags.frame.width + 2 * tagButtonInnerXPadding)
                    make.height.equalTo(tagButtonHeight)
                    make.centerY.equalToSuperview()
                    make.leading.equalTo(offset)
                })
            } */
            
            // set moreTags first
//            let moreTags = FillButton(type: .tag)
//            tagsView.addSubview(moreTags)
//            moreTags.setTitle("+\(series.tags.count)", for: .normal)
//            moreTags.sizeToFit()
//            moreTags.snp.makeConstraints({ make in
//                make.leading.equalToSuperview()
//                make.centerY.equalToSuperview()
//            })
            var tagsNotDisplayed = 0
            var tagsArray = [FillButton]()
            for i in 0 ..< series.tags.count {
                let newButton = FillButton(type: .tag)
                newButton.sizeToFit()
                
                if newButton.frame.width > 150 { // tag is too long
                    tagsNotDisplayed += 1
                } else {
                    newButton.setTitle(series.tags[i].name, for: .normal)
                    newButton.tag = i
                    newButton.addTarget(self, action: #selector(tagButtonPressed(button:)), for: .touchUpInside)
                    newButton.isHidden = true
                    tagsView.addSubview(newButton)
                    tagsArray.append(newButton)
                }
            }
            
            // TODO: figure out how to get width
            if tagsArray.count > 0 {
                tagsArray[0].snp.makeConstraints({ make in
                    make.leading.equalToSuperview()
                    make.centerY.equalToSuperview()
                    let currWidth = tagsArray[0].frame.width + 24
                    make.width.equalTo(currWidth)
                })
                tagsArray[0].isHidden = false 
                tagsArray[0].sizeToFit()
                for i in 1 ..< tagsArray.count - 1 {
                    tagsArray[i].snp.makeConstraints({ make in
                        make.leading.equalTo(tagsArray[i-1].snp.trailing).offset(6)
                        make.centerY.equalToSuperview()
                        let currWidth = tagsArray[i].frame.width + 24
                        make.width.equalTo(currWidth)
                    })
                    tagsArray[i].isHidden = false
                }
            }
            
            if tagsNotDisplayed > 0 { // add tags if there's room
                
            } else {

            }
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
