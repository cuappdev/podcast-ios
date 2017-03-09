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
    
}

class CardTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 305
    
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
    var recommendedLabelHeight: CGFloat = 18
    var podcastImageX: CGFloat = 17.5
    var podcastImageY: CGFloat = 17
    var podcastImageSize: CGFloat = 60
    var bookmarkButtonX: CGFloat = 304
    var bookmarkButtonHeight: CGFloat = 18
    var bookmarkButtonWidth: CGFloat = 12
    var recommendedButtonWidth: CGFloat = 16
    var recommendedButtonHeight: CGFloat = 16
    var recommendedButtonX: CGFloat = 233
    var buttonPadding: CGFloat = 10
    var lineSeperatorX: CGFloat = 18
    var lineSeperatorHeight: CGFloat = 1
    var playButtonX: CGFloat = 19.5
    var playButtonWidth: CGFloat = 11
    var playButtonHeight: CGFloat = 13.5
    var moreButtonX: CGFloat = 342
    var moreButtonHeight: CGFloat = 3
    var moreButtonWidth: CGFloat = 15
    var contextLabelX: CGFloat = 17
    var contextLabelHeight: CGFloat = 30
    var contextLabelRightX: CGFloat = 43
    var contextImagesSize: CGFloat = 28
    var feedControlButtonX: CGFloat = 345
    var feedControlButtonHieght: CGFloat = 7.5
    var feedControlButtonWidth: CGFloat = 13
    var tagButtonsViewY: CGFloat = 160.5
    var contextViewHeight: CGFloat = 52
    var bottomViewHeight: CGFloat = 48
    var mainViewHeight: CGFloat = 195
    
    ///
    /// Mark: Variables
    ///
    var heightConstraint: NSLayoutConstraint!
    var episodeNameLabel: UILabel!
    var dateTimeLabel: UILabel!
    var descriptionLabel: UILabel!
    var recommendedLabel: UILabel!
    var recommendedButton: UIButton!
    var bookmarkButton: UIButton!
    var moreInfoButton: UIButton!
    var seperator: UIView!
    var podcastImageView: UIImageView!
    var lineSeperator: UIView!
    var topLineSeperator: UIView!
    var moreButton: UIButton!
    var playButton: UIButton!
    var playLabel: UILabel!
    var contextLabel: UILabel!
    var contextImages: [UIImageView] = []
    var contextView: UIView! //view for upper context bar of feed cell
    var mainView: UIView! //main view
    var bottomView: UIView! //bottom bar view with buttons
    var feedControlButton: UIButton!
    var tagButtonsView: TagButtonsView!
    
    var cardID: Int?
    
    weak var delegate: CardTableViewCellDelegate?
    
    
    ///
    ///Mark: Init
    ///
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        height += contextViewHeight
        frame.size.height = height
        
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
        
        bottomView = UIView(frame: CGRect.zero)
        bottomView.backgroundColor = .podcastWhite
        contentView.addSubview(bottomView)
        
        seperator = UIView(frame: CGRect.zero)
        seperator.backgroundColor = .clear
        contentView.addSubview(seperator)
        
        lineSeperator = UIView(frame: CGRect.zero)
        lineSeperator.backgroundColor = .podcastGray
        mainView.addSubview(lineSeperator)
        
        topLineSeperator = UIView(frame: CGRect.zero)
        topLineSeperator.backgroundColor = .podcastGray
        mainView.addSubview(topLineSeperator)
        
        episodeNameLabel = UILabel(frame: CGRect.zero)
        dateTimeLabel = UILabel(frame: CGRect.zero)
        descriptionLabel = UILabel(frame: CGRect.zero)
        recommendedLabel = UILabel(frame: CGRect.zero)
        playLabel = UILabel(frame: CGRect.zero)
        
        
        let labels = [episodeNameLabel, dateTimeLabel, descriptionLabel, recommendedLabel, playLabel]
        for label in labels {
            label!.textAlignment = .left
            label!.lineBreakMode = .byWordWrapping
            label!.font = UIFont.systemFont(ofSize: 14.0)
        }
        
        mainView.addSubview(episodeNameLabel)
        mainView.addSubview(dateTimeLabel)
        mainView.addSubview(descriptionLabel)
        bottomView.addSubview(recommendedLabel)
        bottomView.addSubview(playLabel)

        episodeNameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        episodeNameLabel.textColor = .podcastBlack
        
        tagButtonsView = TagButtonsView(frame: CGRect.zero)
        mainView.addSubview(tagButtonsView)
        
        dateTimeLabel.font = UIFont.systemFont(ofSize: 12.0)
        dateTimeLabel.textColor = .podcastGrayDark
        
        descriptionLabel.textColor = .podcastBlack
        descriptionLabel.numberOfLines = 3
        
        recommendedLabel.font = UIFont.systemFont(ofSize: 12.0)
        recommendedLabel.textColor = .podcastGrayDark
        
        playLabel.textColor = .podcastBlueLight
        playLabel.font = UIFont.systemFont(ofSize: 12.0)
        playLabel.text = "Play"
        
        podcastImageView = UIImageView(frame: CGRect.zero)
        mainView.addSubview(podcastImageView)
        
        bookmarkButton = UIButton(frame: CGRect.zero)
        bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_feed_icon_unselected"), for: UIControlState())
        bookmarkButton.addTarget(self, action: #selector(didPressBookmarkButton), for: .touchUpInside)
        bottomView.addSubview(bookmarkButton)
        
        recommendedButton = UIButton(frame: CGRect.zero)

        recommendedButton.setImage(#imageLiteral(resourceName: "heart_icon"), for: UIControlState())
        recommendedButton.addTarget(self, action: #selector(didPressRecommendedButton), for: .touchUpInside)
        bottomView.addSubview(recommendedButton)
        
        moreButton = UIButton(frame: CGRect.zero)
        moreButton.setImage(#imageLiteral(resourceName: "more_icon"), for: UIControlState())
        moreButton.addTarget(self, action: #selector(didPressMoreButton), for: .touchUpInside)
        bottomView.addSubview(moreButton)
        
        playButton = UIButton(frame: CGRect.zero)
        playButton.setImage(#imageLiteral(resourceName: "play_feed_icon"), for: UIControlState())
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
        bottomView.addSubview(playButton)
        
        feedControlButton = UIButton(frame: CGRect.zero)
        feedControlButton.setImage(#imageLiteral(resourceName: "feed_control_icon"), for: UIControlState())
        feedControlButton.addTarget(self, action: #selector(didPressFeedControlButton), for: .touchUpInside)
        contextView.addSubview(feedControlButton)
        
        heightConstraint = NSLayoutConstraint(item: contentView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: height)
        contentView.addConstraint(heightConstraint!)
        NSLayoutConstraint.activate([heightConstraint])
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
        playButton.setImage(#imageLiteral(resourceName: "play_feed_icon"), for: .normal)
        playLabel.text = "Play"
        recommendedButton.setImage(#imageLiteral(resourceName: "heart_icon"), for: .normal)
        bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_feed_icon_unselected"), for: .normal)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !contextView.isDescendant(of: contentView) {
            contentView.addSubview(contextView)
        }
        contextView.frame = CGRect(x: 0, y: 0, width: frame.width, height: contextViewHeight)
            
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
        
        
        mainView.frame = CGRect(x: 0, y: contextViewHeight, width: frame.width, height: mainViewHeight)
        bottomView.frame = CGRect(x: 0, y: contextViewHeight + mainViewHeight, width: frame.width, height: bottomViewHeight)
        
        episodeNameLabel.frame = CGRect(x: episodeNameLabelX, y: episodeNameLabelY, width: frame.width - episodeNameLabelRightX - episodeNameLabelX, height: episodeNameLabelHeight)
        dateTimeLabel.frame = CGRect(x: dateTimeLabelX, y: dateTimeLabelY, width: frame.width, height: dateTimeLabelHeight)
        descriptionLabel.frame = CGRect(x: descriptionLabelX, y: descriptionLabelY, width: frame.width - descriptionLabelRightX - descriptionLabelX, height: descriptionLabelHeight)
        podcastImageView.frame = CGRect(x: podcastImageX, y: podcastImageY, width: podcastImageSize, height: podcastImageSize)
        
        recommendedLabel.sizeToFit()
        bookmarkButton.frame = CGRect(x: bookmarkButtonX, y: 0, width: bookmarkButtonWidth, height: bookmarkButtonHeight)
        recommendedButton.frame = CGRect(x: recommendedButtonX, y: 0, width: recommendedButtonWidth, height: recommendedButtonHeight)
        recommendedButton.center.y = bottomViewHeight / 2
        bookmarkButton.center.y = bottomViewHeight / 2
        playButton.frame = CGRect(x: playButtonX, y: 0, width: playButtonWidth, height: playButtonHeight)
        moreButton.frame = CGRect(x: moreButtonX, y: 0, width: moreButtonWidth, height: moreButtonHeight)
        playButton.center.y = bottomViewHeight / 2
        moreButton.center.y = bottomViewHeight / 2
        recommendedLabel.center.y = bottomViewHeight / 2
        recommendedLabel.frame.origin.x = recommendedButton.frame.origin.x + buttonPadding + recommendedButton.frame.width
        playLabel.frame = CGRect(x: playButtonX + playButtonWidth + buttonPadding, y: 0, width: 0, height: 0)
        playLabel.sizeToFit()
        playLabel.center.y = bottomViewHeight / 2
        
        feedControlButton.frame = CGRect(x: feedControlButtonX, y: 0, width: feedControlButtonWidth, height: feedControlButtonHieght)
        feedControlButton.center.y = contextViewHeight / 2

        lineSeperator.frame = CGRect(x: lineSeperatorX, y: mainViewHeight - 1, width: frame.width - 2 * lineSeperatorX, height: lineSeperatorHeight)
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
        if isBookmarked {
            bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_feed_icon_selected"), for: .normal)

        } else {
            bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_feed_icon_unselected"), for: .normal)
        }
    }
    
    func didPressRecommendedButton() {
        delegate?.cardTableViewCellDidPressRecommendButton(cardTableViewCell: self)
    }
    
    func setRecommendedButtonToState(isRecommended: Bool) {
        if isRecommended {
            recommendedButton.setImage(#imageLiteral(resourceName: "heart_icon_selected"), for: .normal)
        } else {
            recommendedButton.setImage(#imageLiteral(resourceName: "heart_icon"), for: .normal)
        }
    }
    
    func didPressPlayButton() {
        delegate?.cardTableViewCellDidPressPlayPauseButton(cardTableViewCell: self)
    }
    
    func setPlayButtonToState(isPlaying: Bool) {
        if isPlaying {
            playButton.setImage(#imageLiteral(resourceName: "play_feed_icon_selected"), for: .normal)
            playLabel.text = "Now Playing"
            playLabel.sizeToFit()
        } else {
            playButton.setImage(#imageLiteral(resourceName: "play_feed_icon"), for: .normal)
            playLabel.text = "Play"
        }
    }
    
    func didPressMoreButton() {
        delegate?.cardTableViewCellDidPressMoreActionsButton(cardTableViewCell: self)
    }
    
    
    func didPressFeedControlButton() {
        
    }
    
    func didPressTagButton(button: UIButton) {
        
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateTimeLabel.text = dateFormatter.string(from: episodeCard.episode.dateCreated as Date)
        dateTimeLabel.text = dateTimeLabel.text! + " • " + String(episodeCard.episode.duration) + " min"
        if episodeCard.episode.seriesTitle != "" {
            dateTimeLabel.text = dateTimeLabel.text! + " • " + episodeCard.episode.seriesTitle
        }
        descriptionLabel.text = episodeCard.episode.descriptionText
        recommendedLabel.text = String(episodeCard.episode.numberOfRecommendations)
        if let url = episodeCard.episode.smallArtworkImageURL {
            if let data = try? Data(contentsOf: url) {
                podcastImageView.image = UIImage(data: data)
            }
        } else {
            podcastImageView.image = #imageLiteral(resourceName: "filler_image")
        }
        
        if episodeCard.episode.isBookmarked == true {
            bookmarkButton.setImage(#imageLiteral(resourceName: "bookmark_feed_icon_selected"), for: .normal)
        }
        if episodeCard.episode.isRecommended == true {
            recommendedButton.setImage(#imageLiteral(resourceName: "heart_icon_selected"), for: .normal)
        }
        /*if episodeCard.isPlaying == true {
            playButton.setImage(#imageLiteral(resourceName: "play_feed_icon_selected"), for: .normal)
            playLabel.text = "Now Playing"
        }
        */
        cardID = episodeCard.episode.id
    }
    
    func setRecommendedCard(card: RecommendedCard) {
        if card.namesOfRecommenders != [] {
            contextLabel.text = ""
            for i in 0..<card.namesOfRecommenders.count {
                contextLabel.text = contextLabel.text! + card.namesOfRecommenders[i] + ", "
            }
            if card.numberOfRecommenders > 3 {
                contextLabel.text = contextLabel.text! + "and " + String(card.numberOfRecommenders - 3) + " others recommended this podcast"
            } else {
                contextLabel.text = contextLabel.text! + " recommended this podcast"
            }
        }
        for i in 0..<card.imageURLsOfRecommenders.count {
            if contextImages.count < card.imageURLsOfRecommenders.count {
                contextImages.append(UIImageView(frame: CGRect.zero))
                let imageView = contextImages[i]
                
                if let url = card.imageURLsOfRecommenders[i] {
                    if let data = try? Data(contentsOf: url) {
                        imageView.image = UIImage(data: data)
                    }
                } else {
                    imageView.image = #imageLiteral(resourceName: "filler_image")
                }
                imageView.layer.borderWidth = 2
                imageView.layer.borderColor = UIColor.podcastWhiteDark.cgColor
                imageView.layer.cornerRadius = contextImagesSize / 2
                imageView.clipsToBounds = true
                contextView.addSubview(imageView)
            }
        }
    }
    
    
    func setReleaseCard(card: ReleaseCard) {
        if card.episode.seriesTitle != "" {
            contextLabel.text = card.episode.seriesTitle + " released a new episode"
        }
        contextImages = [UIImageView(frame: CGRect.zero)]
        if let url = card.seriesImageURL {
            if let data = try? Data(contentsOf: url) {
                contextImages[0].image = UIImage(data: data)
            }
        } else {
            contextImages[0].image = #imageLiteral(resourceName: "sample_series_artwork")
        }
        contextView.addSubview(contextImages[0])
    }
    
    
    func setTagCard(card: TagCard) {
        if card.tag.name != "" {
            contextLabel.text = "Because you like " + card.tag.name
        }
    }

}




