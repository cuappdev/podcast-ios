//
//  FeedTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//


import UIKit
import SnapKit

protocol CardTableViewCellDelegate: EpisodeTableViewCellDelegate {
    func cardTableViewCelldidPressFeedControlButton(cell: CardTableViewCell)
}

class CardTableViewCell: EpisodeTableViewCell {
    
    static let cardTableViewCellHeight: CGFloat = 305
    
    ///
    /// Mark: View Constants
    ///
    override public var podcastImageY: CGFloat { get { return 69 }  set {} }
    
    var cardID: String?
    
    ///
    /// Mark: Variables
    ///
    var cardTableViewCellContextView: CardTableViewCellContextView!
    
    weak var cardTableViewCellDelegate: CardTableViewCellDelegate?
    
    ///
    ///Mark: Init
    ///
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cardTableViewCellContextView = CardTableViewCellContextView(frame: CGRect.zero)
        cardTableViewCellContextView.feedControlButton.addTarget(self, action: #selector(didPressFeedControlButton), for: .touchUpInside)
        addSubview(cardTableViewCellContextView)
        
        cardTableViewCellContextView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(CardTableViewCellContextView.contextViewHeight)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardTableViewCellContextView.prepareForReuse()
    }
    
    ///
    ///MARK - setup card 
    ///
    
    func setupWithCard(card: Card) {
        
        guard let episodeCard = card as? EpisodeCard else { return }
        cardTableViewCellContextView.setupWithCard(episodeCard: episodeCard)
        
        episodeNameLabel.text = episodeCard.episode.title
        
        tagButtonsView.setupTagButtons(tags: episodeCard.episode.tags)
        
        for tagButton in tagButtonsView.tagButtons {
            tagButton.addTarget(self, action: #selector(didPressTagButton(button:)), for: .touchUpInside)
        }
        
        dateTimeLabel.text = episodeCard.episode.dateTimeSeriesString()
        UILabel.adjustHeightToFit(label: dateTimeLabel)
        descriptionLabel.attributedText = episodeCard.episode.attributedDescriptionString()
        episodeUtilityButtonBarView.recommendedButton.setTitle(episodeCard.episode.numberOfRecommendations.shortString(), for: .normal)
        podcastImage.image = #imageLiteral(resourceName: "nullSeries")
        podcastImage.sizeToFit()
        if let url = episodeCard.episode.smallArtworkImageURL {
            podcastImage.setImageAsynchronously(url: url, completion: nil)
        }
        
        episodeUtilityButtonBarView.bookmarkButton.isSelected = episodeCard.episode.isBookmarked
        episodeUtilityButtonBarView.recommendedButton.isSelected = episodeCard.episode.isRecommended
        cardID = episodeCard.episode.id
    }
    ///
    /// Mark: Delegate Methods
    ///
    
    func didPressFeedControlButton() {
        cardTableViewCellDelegate?.cardTableViewCelldidPressFeedControlButton(cell: self)
    }
}




