//
//  FeedTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//


import UIKit

protocol CardTableViewCellDelegate: class {
    
    func cardTableViewCellDidPressPlayPauseButton(cardTableViewCell: CardTableViewCell)
    func cardTableViewCellDidPressRecommendButton(cardTableViewCell: CardTableViewCell)
    func cardTableViewCellDidPressBookmarkButton(cardTableViewCell: CardTableViewCell)
    func cardTableViewCellDidPressMoreActionsButton(cardTableViewCell: CardTableViewCell)
    func cardTableViewCellDidPressTagButton(cardTableViewCell: CardTableViewCell, index: Int)
}

class CardTableViewCell: UITableViewCell {
    
    static let height: CGFloat = 305
    static let bottomViewHeight: CGFloat = 48
    
    ///
    /// Mark: View Constants
    ///
    var height: CGFloat = 253
    var seperatorHeight: CGFloat = 9
    var episodeNameLabelY: CGFloat = 27
    var episodeNameLabelX: CGFloat = 86.5
    var episodeNameLabelRightX: CGFloat = 21
    var episodeNameLabelHeight: CGFloat = 18
    var dateTimeLabelX: CGFloat = 86.5
    var dateTimeLabelY: CGFloat = 47.5
    var dateTimeLabelHeight: CGFloat = 14.5
    var descriptionLabelX: CGFloat = 17.5
    var descriptionLabelY: CGFloat = 94
    var descriptionLabelHeight: CGFloat = 54
    var descriptionLabelRightX: CGFloat = 11.5
    var podcastImageX: CGFloat = 17.5
    var podcastImageY: CGFloat = 17
    var podcastImageSize: CGFloat = 60
    var lineSeperatorHeight: CGFloat = 1
    var contextLabelX: CGFloat = 17
    var contextLabelHeight: CGFloat = 30
    var contextLabelRightX: CGFloat = 20
    var contextImagesSize: CGFloat = 28
    var feedControlButtonX: CGFloat = 345
    var feedControlButtonHieght: CGFloat = 7.5
    var feedControlButtonWidth: CGFloat = 13
    var tagButtonsViewY: CGFloat = 160.5
    var contextViewHeight: CGFloat = 52
    var bottomViewHeight: CGFloat = CardTableViewCell.bottomViewHeight
    var mainViewHeight: CGFloat = 195
    
    ///
    /// Mark: Variables
    ///
    var episodeNameLabel: UILabel!
    var dateTimeLabel: UILabel!
    var descriptionLabel: UILabel!
    var seperator: UIView!
    var podcastImageView: ImageView!
    var topLineSeperator: UIView!
    var contextLabel: UILabel!
    var contextImages: [ImageView] = []
    var contextView: UIView! //view for upper context bar of feed cell
    var mainView: UIView! //main view
    var bottomView: EpisodeUtilityButtonBarView! //bottom bar view with buttons
    var feedControlButton: FeedControlButton!
    var tagButtonsView: TagButtonsView!
    
    var cardID: String?
    
    weak var delegate: CardTableViewCellDelegate?
    
    
    ///
    ///Mark: Init
    ///
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
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

        mainView = UIView(frame: CGRect.zero)
        mainView.backgroundColor = .podcastWhite
        contentView.addSubview(mainView)
        
        bottomView = EpisodeUtilityButtonBarView(frame: .zero)
        bottomView.hasTopLineSeperator = true 
        contentView.addSubview(bottomView)
        
        seperator = UIView(frame: CGRect.zero)
        seperator.backgroundColor = .clear
        contentView.addSubview(seperator)
        
        topLineSeperator = UIView(frame: CGRect.zero)
        topLineSeperator.backgroundColor = .podcastGray
        mainView.addSubview(topLineSeperator)
        
        episodeNameLabel = UILabel(frame: CGRect.zero)
        dateTimeLabel = UILabel(frame: CGRect.zero)
        descriptionLabel = UILabel(frame: CGRect.zero)
        
        let labels: [UILabel] = [episodeNameLabel, dateTimeLabel, descriptionLabel]
        for label in labels {
            label.textAlignment = .left
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont.systemFont(ofSize: 14.0)
        }
        
        mainView.addSubview(episodeNameLabel)
        mainView.addSubview(dateTimeLabel)
        mainView.addSubview(descriptionLabel)

        episodeNameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        episodeNameLabel.textColor = .podcastBlack
        
        tagButtonsView = TagButtonsView(frame: CGRect.zero)
        mainView.addSubview(tagButtonsView)
        
        dateTimeLabel.font = UIFont.systemFont(ofSize: 12.0)
        dateTimeLabel.textColor = .podcastGrayDark
        
        descriptionLabel.textColor = .podcastBlack
        descriptionLabel.numberOfLines = 3
        
        podcastImageView = ImageView(frame: CGRect.zero)
        mainView.addSubview(podcastImageView)
        
        feedControlButton = FeedControlButton(frame: .zero)
        
        bottomView.bookmarkButton.addTarget(self, action: #selector(didPressBookmarkButton), for: .touchUpInside)
        bottomView.recommendedButton.addTarget(self, action: #selector(didPressRecommendedButton), for: .touchUpInside)
        bottomView.moreButton.addTarget(self, action: #selector(didPressMoreButton), for: .touchUpInside)
        bottomView.playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
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
        tagButtonsView.prepareForReuse()
        bottomView.prepareForReuse()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !contextView.isDescendant(of: contentView) {
            contentView.addSubview(contextView)
        }
        contextView.frame = CGRect(x: 0, y: 0, width: frame.width, height: contextViewHeight)
        
        mainView.frame = CGRect(x: 0, y: contextViewHeight, width: frame.width, height: mainViewHeight)
        bottomView.frame = CGRect(x: 0, y: contextViewHeight + mainViewHeight, width: frame.width, height: bottomViewHeight)
        episodeNameLabel.frame = CGRect(x: episodeNameLabelX, y: episodeNameLabelY, width: frame.width - episodeNameLabelRightX - episodeNameLabelX, height: episodeNameLabelHeight)
        dateTimeLabel.frame = CGRect(x: dateTimeLabelX, y: dateTimeLabelY, width: frame.width, height: dateTimeLabelHeight)
        descriptionLabel.frame = CGRect(x: descriptionLabelX, y: descriptionLabelY, width: frame.width - descriptionLabelRightX - descriptionLabelX, height: descriptionLabelHeight)
        podcastImageView.frame = CGRect(x: podcastImageX, y: podcastImageY, width: podcastImageSize, height: podcastImageSize)
        
        feedControlButton.frame = CGRect(x: feedControlButtonX, y: 0, width: feedControlButtonWidth, height: feedControlButtonHieght)
        feedControlButton.center.y = contextViewHeight / 2
        
        topLineSeperator.frame = CGRect(x: 0, y: 0, width: frame.width, height: lineSeperatorHeight)
        seperator.frame = CGRect(x: 0, y: frame.height - seperatorHeight, width: frame.width, height: seperatorHeight)
        
        tagButtonsView.frame = CGRect(x: 0, y: tagButtonsViewY, width: frame.width, height: tagButtonsView.tagButtonHeight)
        
    }
    
    ///
    ///Mark - Buttons
    ///
    func didPressBookmarkButton() {
        delegate?.cardTableViewCellDidPressBookmarkButton(cardTableViewCell: self)
    }
    
    func setBookmarkButtonToState(isBookmarked: Bool) {
        bottomView.bookmarkButton.isSelected = isBookmarked
    }
    
    func didPressRecommendedButton() {
        delegate?.cardTableViewCellDidPressRecommendButton(cardTableViewCell: self)
    }
    
    func setRecommendedButtonToState(isRecommended: Bool) {
        bottomView.recommendedButton.isSelected = isRecommended
    }
    
    func didPressPlayButton() {
        delegate?.cardTableViewCellDidPressPlayPauseButton(cardTableViewCell: self)
    }
    
    func setPlayButtonToState(isPlaying: Bool) {
        bottomView.playButton.isSelected = isPlaying
    }
    
    func didPressMoreButton() {
        delegate?.cardTableViewCellDidPressMoreActionsButton(cardTableViewCell: self)
    }
    
    
    func didPressFeedControlButton() {
        
    }
    
    func didPressTagButton(button: UIButton) {
        delegate?.cardTableViewCellDidPressTagButton(cardTableViewCell: self, index: button.tag)
    }
    
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
        descriptionLabel.attributedText = episodeCard.episode.attributedDescriptionString()
        bottomView.recommendedButton.setTitle(episodeCard.episode.numberOfRecommendations.shortString(), for: .normal)
        podcastImageView.image = #imageLiteral(resourceName: "nullSeries")
        podcastImageView.sizeToFit()
        if let url = episodeCard.episode.smallArtworkImageURL {
            podcastImageView.setImageAsynchronously(url: url, completion: nil)
        }
        
        bottomView.bookmarkButton.isSelected = episodeCard.episode.isBookmarked
        bottomView.recommendedButton.isSelected = episodeCard.episode.isRecommended
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




