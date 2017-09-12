//
//  FeedTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//


import UIKit

protocol CardTableViewCellDelegate: EpisodeTableViewCellDelegate {
    func cardTableViewCelldidPressFeedControlButton(cell: CardTableViewCell)
}

class CardTableViewCell: EpisodeTableViewCell {
    
    static let cardTableViewCellHeight: CGFloat = 305
    
    ///
    /// Mark: View Constants
    ///
    override public var episodeNameLabelY: CGFloat { get { return 69 }  set {} } //doing this cuz Swift sucks
    override public var podcastImageY: CGFloat { get { return 69 }  set {} }
    var lineSeperatorHeight: CGFloat = 1
    var contextLabelX: CGFloat = 17
    var contextLabelHeight: CGFloat = 30
    var contextLabelRightX: CGFloat = 20
    var contextImagesSize: CGFloat = 28
    var feedControlButtonX: CGFloat = 345
    var feedControlButtonHieght: CGFloat = 7.5
    var feedControlButtonWidth: CGFloat = 13
    var contextViewHeight: CGFloat = 52
    
    ///
    /// Mark: Variables
    ///
    var topLineSeperator: UIView!
    var contextLabel: UILabel!
    var contextImages: [ImageView] = []
    var contextView: UIView! //view for upper context bar of feed cell
    var feedControlButton: FeedControlButton!
    
    var cardID: String?
    
    weak var cardTableViewCellDelegate: CardTableViewCellDelegate?
    
    ///
    ///Mark: Init
    ///
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //we don't add context view to content view yet --> add in layout subviews
        contextView = UIView(frame: CGRect.zero)
        contextView.backgroundColor = .podcastWhite
        contextLabel = UILabel(frame: CGRect.zero)
        contextLabel.textAlignment = .left
        contextLabel.lineBreakMode = .byWordWrapping
        contextLabel.font = UIFont.systemFont(ofSize: 12.0)
        contextLabel.numberOfLines = 2
        contextView.addSubview(contextLabel)
        contentView.addSubview(contextView)
        
        topLineSeperator = UIView(frame: CGRect.zero)
        topLineSeperator.backgroundColor = .podcastWhiteDark
        contentView.addSubview(topLineSeperator)
        
        feedControlButton = FeedControlButton(frame: .zero)
        feedControlButton.addTarget(self, action: #selector(didPressFeedControlButton), for: .touchUpInside)

        contextView.addSubview(feedControlButton)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        for imageView in contextImages {
            imageView.removeFromSuperview()
        }

        contextImages = []
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !contextView.isDescendant(of: contentView) {
            contentView.addSubview(contextView)
        }
        contextView.frame = CGRect(x: 0, y: 0, width: frame.width, height: contextViewHeight)
        
        feedControlButton.frame = CGRect(x: feedControlButtonX, y: 0, width: feedControlButtonWidth, height: feedControlButtonHieght)
        feedControlButton.center.y = contextViewHeight / 2
        
        topLineSeperator.frame = CGRect(x: 0, y: contextViewHeight, width: frame.width, height: lineSeperatorHeight)
    }
    
    ///
    ///Mark - Buttons
    ///
    
    ///
    ///MARK - setup card 
    ///
    
    func setupWithCard(card: Card) {
        
        guard let episodeCard = card as? EpisodeCard else { return }
        
        if let recommendCard = episodeCard as? RecommendedCard {
            setRecommendedCard(card: recommendCard)
        } else if let releaseCard = episodeCard as? ReleaseCard {
            setReleaseCard(card: releaseCard)
        } else if let tagCard = episodeCard as? TagCard {
            setTagCard(card: tagCard)
        }
            
        episodeNameLabel.text = episodeCard.episode.title
        
        tagButtonsView.setupTagButtons(tags: episodeCard.episode.tags)
        
        for tagButton in tagButtonsView.tagButtons {
            tagButton.addTarget(self, action: #selector(didPressTagButton(button:)), for: .touchUpInside)
        }
        
        dateTimeLabel.text = episodeCard.episode.dateTimeSeriesString()
        UILabel.adjustHeightToFit(label: dateTimeLabel)
        descriptionLabel.attributedText = episodeCard.episode.attributedDescriptionString()
        utilityButtonBarView.recommendedButton.setTitle(episodeCard.episode.numberOfRecommendations.shortString(), for: .normal)
        podcastImage.image = #imageLiteral(resourceName: "nullSeries")
        podcastImage.sizeToFit()
        if let url = episodeCard.episode.smallArtworkImageURL {
            podcastImage.setImageAsynchronously(url: url, completion: nil)
        }
        
        utilityButtonBarView.bookmarkButton.isSelected = episodeCard.episode.isBookmarked
        utilityButtonBarView.recommendedButton.isSelected = episodeCard.episode.isRecommended
        cardID = episodeCard.episode.id
    }
    
    func setRecommendedCard(card: RecommendedCard) {
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
        
        var contextStartX = contextLabelX
        
        for i in 0..<card.imageURLsOfRecommenders.count {
            contextImages.append(ImageView(frame: CGRect(x: contextStartX, y: 0, width: contextImagesSize, height: contextImagesSize)))
            contextStartX += contextImagesSize / 2
            contextImages[i].center.y = contextViewHeight / 2
            contextImages[i].image = #imageLiteral(resourceName: "nullSeries")
            contextImages[i].layer.borderWidth = 2
            contextImages[i].layer.borderColor = UIColor.podcastWhiteDark.cgColor
            contextImages[i].layer.cornerRadius = contextImagesSize / 2
            contextImages[i].clipsToBounds = true
            contextView.addSubview(contextImages[i])
            contextImages[i].setImageAsynchronously(url: card.imageURLsOfRecommenders[i]!, completion: nil)
            
            if i == contextImages.count - 1{
                contextStartX += contextImagesSize
                
            }
        }
        
        if contextLabel.text != "" {
            contextLabel.frame = CGRect(x: contextStartX, y: 0, width: frame.width - contextLabelRightX - contextStartX, height: contextLabelHeight)
            contextLabel.center.y = contextViewHeight / 2
        }
    }
    
    
    func setReleaseCard(card: ReleaseCard) {
        if card.episode.seriesTitle != "" {
            contextLabel.text = card.episode.seriesTitle + " released a new episode"
        }
        contextImages = [ImageView(frame: CGRect(x: contextLabelX, y: 0, width: contextImagesSize, height: contextImagesSize))]
        contextImages[0].image = #imageLiteral(resourceName: "nullSeries")
        if let url = card.seriesImageURL {
            contextImages[0].setImageAsynchronously(url: url, completion: nil)
        }
        contextView.addSubview(contextImages[0])
    }
    
    
    func setTagCard(card: TagCard) {
        if card.tag.name != "" {
            contextLabel.text = "Because you like " + card.tag.name
        }
    }
    
    func setupContextImages() {
        var contextStartX = contextLabelX
        
        for i in 0..<contextImages.count {
            contextImages[i].frame = CGRect(x: contextStartX, y: 0, width: contextImagesSize, height: contextImagesSize)
            contextStartX += contextImagesSize / 2
            contextImages[i].center.y = contextViewHeight / 2
            if i == contextImages.count - 1{
                contextStartX += contextImagesSize
                
            }
        }
        
        if contextLabel.text != "" {
            contextLabel.frame = CGRect(x: contextStartX, y: 0, width: frame.width - contextLabelRightX - contextStartX, height: contextLabelHeight)
            contextLabel.center.y = contextViewHeight / 2
        }
    }
}




