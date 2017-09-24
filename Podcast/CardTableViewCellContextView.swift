//
//  CardTableViewCellContextView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/18/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

class CardTableViewCellContextView: UIView {
    
    static var contextViewHeight: CGFloat = 52
    
    var lineSeperatorHeight: CGFloat = 1
    var contextMarginX: CGFloat = 17
    var contextLabelRightX: CGFloat = 20
    var contextImagesSize: CGFloat = 28
    var feedControlButtonRightX: CGFloat = 20
    var feedControlButtonHieght: CGFloat = 7.5
    var feedControlButtonWidth: CGFloat = 13
    var contextViewHeight: CGFloat = CardTableViewCellContextView.contextViewHeight
    var marginSpacing: CGFloat = 10
    ///
    /// Mark: Variables
    ///
    var topLineSeperator: UIView!
    var contextLabel: UILabel!
    var contextImages: UIStackView!
    var feedControlButton: FeedControlButton!
   
    ///
    ///Mark: Init
    ///
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .podcastWhite
        
        contextLabel = UILabel(frame: CGRect.zero)
        contextLabel.textAlignment = .left
        contextLabel.lineBreakMode = .byWordWrapping
        contextLabel.font = UIFont.systemFont(ofSize: 12.0)
        contextLabel.numberOfLines = 2
        addSubview(contextLabel)

        feedControlButton = FeedControlButton(frame: .zero)
        addSubview(feedControlButton)
        
        topLineSeperator = UIView(frame: CGRect.zero)
        topLineSeperator.backgroundColor = .podcastWhiteDark
        addSubview(topLineSeperator)
        
        contextImages = UIStackView()
        contextImages.spacing = -1 * contextImagesSize
        addSubview(contextImages)
        
        contextImages.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(contextMarginX)
            make.height.equalTo(contextImagesSize)
            make.centerY.equalToSuperview()
        }
        
        contextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(contextImages.snp.trailing).offset(marginSpacing)
            make.trailing.equalToSuperview().inset(contextLabelRightX)
        }
        
        feedControlButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(feedControlButtonWidth)
            make.height.equalTo(feedControlButtonHieght)
            make.trailing.equalTo(feedControlButtonRightX)
        }
        
        topLineSeperator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(lineSeperatorHeight)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        for view in contextImages.subviews {
            view.removeFromSuperview()
        }
    }
    
    func setupWithCard(episodeCard: EpisodeCard) {
        if let recommendCard = episodeCard as? RecommendedCard {
            setRecommendedCard(card: recommendCard)
        } else if let releaseCard = episodeCard as? ReleaseCard {
            setReleaseCard(card: releaseCard)
        } else if let tagCard = episodeCard as? TagCard {
            setTagCard(card: tagCard)
        }
    }
    
    internal func setRecommendedCard(card: RecommendedCard) {
        if card.namesOfRecommenders != [] {
            contextLabel.text = ""
            for i in 0..<card.namesOfRecommenders.count {
                contextLabel.text = contextLabel.text! + card.namesOfRecommenders[i]
                if i != card.namesOfRecommenders.count - 1 {
                    contextLabel.text = contextLabel.text! + ", "
                }
            }
            if card.numberOfRecommenders > 3 {
                contextLabel.text = contextLabel.text! + ", and " + String(card.numberOfRecommenders - 3) + " others recommended this podcast"
            } else {
                contextLabel.text = contextLabel.text! + " recommended this podcast"
            }
        }
        
        for url in card.imageURLsOfRecommenders {
            let imageView = ImageView(frame: CGRect(x: 0, y: 0, width: contextImagesSize, height: contextImagesSize))
            contextImages.addArrangedSubview(imageView)
            layoutContextImageView(imageView: imageView, imageURL: url)
        }
    }
    
    internal func setReleaseCard(card: ReleaseCard) {
        if card.episode.seriesTitle != "" {
            contextLabel.text = card.episode.seriesTitle + " released a new episode"
        }
        let imageView = ImageView(frame: CGRect(x: 0, y: 0, width: contextImagesSize, height: contextImagesSize))
        contextImages.addArrangedSubview(imageView)
        layoutContextImageView(imageView: imageView, imageURL: card.seriesImageURL)
        
    }
    
    
    func setTagCard(card: TagCard) {
        if card.tag.name != "" {
            contextLabel.text = "Because you like " + card.tag.name
        }
    }
    
    internal func layoutContextImageView(imageView: ImageView, imageURL: URL?) {
        imageView.image = #imageLiteral(resourceName: "nullSeries")
        if let url = imageURL {
            imageView.setImageAsynchronously(url: url, completion: nil)
        }
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.podcastWhiteDark.cgColor
        imageView.layer.cornerRadius = contextImagesSize / 2
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(contextImagesSize)
        }
    }
}
