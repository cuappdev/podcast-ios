/*
  FeedTableViewCell.swift
  Podcast

  Created by Natasha Armbrust on 2/12/17.
  Copyright © 2017 Cornell App Development. All rights reserved.


import UIKit
import SnapKit

protocol CardTableViewCellDelegate: EpisodeTableViewCellDelegate {
    func cardTableViewCelldidPressFeedControlButton(cell: CardTableViewCell)
}

class CardTableViewCell: EpisodeTableViewCell {
 
    static let cardTableViewCellHeight: CGFloat = 305
 
//    /
//    / Mark: View Constants
//    /
    override public var podcastImageY: CGFloat { get { return 69 }  set {} }
 
    var cardID: String?
 
//    /
//    / Mark: Variables
//    /
    var cardTableViewCellContextView: CardTableViewCellContextView!
 
    weak var cardTableViewCellDelegate: CardTableViewCellDelegate?
//
//    /
//    /Mark: Init
//    /
//
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
 
    /
    /MARK - setup card
    /
 
    func setupWithCard(card: Card) {
        guard let episodeCard = card as? EpisodeCard else { return }
        cardTableViewCellContextView.setupWithCard(episodeCard: episodeCard)
        setupWithEpisode(episode: episodeCard.episode)
        cardID = episodeCard.episode.id
    }
    /
    / Mark: Delegate Methods
    /
 
    @objc func didPressFeedControlButton() {
        cardTableViewCellDelegate?.cardTableViewCelldidPressFeedControlButton(cell: self)
    }
}

*/


