//
//  EpisodeDetailView.swift
//  Podcast
//
//  Created by Mark Bryan on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import MarqueeLabel

protocol PlayerEpisodeDetailDelegate: class {
    func playerEpisodeDetailViewDidDrag(sender: UIPanGestureRecognizer)
    func playerEpisodeDetailViewDidTapArtwork()
}

class PlayerEpisodeDetailView: UIView, UIGestureRecognizerDelegate {
    
    var expandedArtwork: Bool = true
    
    var episodeArtworkImageView: ImageView!
    var episodeTitleLabel: MarqueeLabel!
    var dateLabel: UILabel!
    var descriptionTextView: UITextView!
    var seeMoreButton: UIButton!
    
    let marginSpacing: CGFloat = 24
    let trailingSpacing: CGFloat = 18
    let artworkY: CGFloat = 10
    
    let artworkLargeDimension: CGSize = CGSize(width: 250, height: 250)
    let artworkSmallDimension: CGSize = CGSize(width: 48, height: 48)
    let artworkLargeWidthMultiplier: CGFloat = 0.7
    let artworkSmallWidthMultiplier: CGFloat = 0.12
    
    let episodeTitleLabelHeight: CGFloat = 24
    let episodeTitleTopOffset: CGFloat = 25
    let dateLabelYSpacing: CGFloat = 8
    let dateLabelHeight: CGFloat = 18
    let descriptionTextViewTopOffset: CGFloat = 10
    let descriptionTextViewShowMoreTopOffset: CGFloat = 19
    let descriptionTextViewMarginSpacing: CGFloat = 18
    let recommendButtonSpacing: CGFloat = 22.5
    let bottomSpacing: CGFloat = 28.5
    let episodeTitleShowMoreSpacing: CGFloat = 12
    let dateLabelShowMoreTopOffset: CGFloat = 5.5
    let seeMoreButtonWidth: CGFloat = 100
    let seeMoreButtonHeight: CGFloat = 20
    
    let episodeTitleSpeed: CGFloat = 60
    let episodeTitleTrailingBuffer: CGFloat = 10
    let episodeTitleAnimationDelay: CGFloat = 2

    weak var delegate: PlayerEpisodeDetailDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
                
        episodeArtworkImageView = ImageView(frame: CGRect(x: 0, y: 0, width: artworkLargeDimension.width, height: artworkLargeDimension.height))
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didPressSeriesArtwork))
        episodeArtworkImageView.isUserInteractionEnabled = true
        episodeArtworkImageView.addGestureRecognizer(tapGestureRecognizer)
        episodeArtworkImageView.clipsToBounds = true
        addSubview(episodeArtworkImageView)
                
        episodeTitleLabel = MarqueeLabel(frame: .zero)
        episodeTitleLabel.font = ._16RegularFont()
        episodeTitleLabel.textColor = .charcoalGrey
        episodeTitleLabel.numberOfLines = 1
        episodeTitleLabel.lineBreakMode = .byTruncatingTail
        episodeTitleLabel.speed = .rate(episodeTitleSpeed)
        episodeTitleLabel.trailingBuffer = episodeTitleTrailingBuffer
        episodeTitleLabel.type = .continuous
        episodeTitleLabel.fadeLength = episodeTitleSpeed
        episodeTitleLabel.tapToScroll = false
        episodeTitleLabel.holdScrolling = true
        episodeTitleLabel.animationDelay = episodeTitleAnimationDelay
        addSubview(episodeTitleLabel)
        
        dateLabel = UILabel(frame: .zero)
        dateLabel.font = ._12RegularFont()
        dateLabel.textColor = .slateGrey
        dateLabel.numberOfLines = 5
        dateLabel.lineBreakMode = .byWordWrapping
        addSubview(dateLabel)
        
        descriptionTextView = UITextView(frame: .zero)
        descriptionTextView.isEditable = false
        descriptionTextView.font = ._14RegularFont()
        descriptionTextView.textColor = .charcoalGrey
        descriptionTextView.showsVerticalScrollIndicator = false
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.textContainerInset = UIEdgeInsets.zero
        descriptionTextView.textContainer.lineFragmentPadding = 0
        addSubview(descriptionTextView)
        
        seeMoreButton = Button()
        seeMoreButton.frame = CGRect(x: 0, y: 0, width: seeMoreButtonWidth, height: seeMoreButtonHeight)
        seeMoreButton.setTitleColor(.sea, for: .normal)
        seeMoreButton.titleLabel?.textAlignment = .center
        seeMoreButton.titleLabel?.font = ._14RegularFont()
        seeMoreButton.contentVerticalAlignment = .center
        seeMoreButton.contentHorizontalAlignment = .center
        seeMoreButton.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
        addSubview(seeMoreButton)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewDragged(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // see if the description can fit with the large player view - if so, hide the "See more" button
        let descriptionHeight = descriptionTextView.attributedText.height(withConstrainedWidth: frame.width - 2 * trailingSpacing)
        seeMoreButton.isHidden = (descriptionTextView.frame.minY + descriptionHeight) < seeMoreButton.frame.minY && expandedArtwork
        episodeArtworkImageView.layer.cornerRadius = cornerRadiusPercentage * episodeArtworkImageView.frame.height
    }
    
    func updateUIForEpisode(episode: Episode) {
        episodeArtworkImageView.setImageAsynchronouslyWithDefaultImage(url: episode.largeArtworkImageURL)
        episodeTitleLabel.text = episode.title
        dateLabel.text = episode.dateTimeLabelString
        descriptionTextView.attributedText = episode.attributedDescription.toEpisodeDescriptionStyle()
        expandedArtwork = true
        episodeTitleLabel.holdScrolling = false
        layoutUI()
    }
    
    func layoutUI() {
        if expandedArtwork {
            episodeArtworkImageView.snp.remakeConstraints({ make in
                make.top.equalToSuperview().offset(artworkY).priority(999)
                make.width.equalToSuperview().multipliedBy(artworkLargeWidthMultiplier)
                make.height.equalTo(episodeArtworkImageView.snp.width)
                make.centerX.equalToSuperview()
            })
            
            episodeTitleLabel.snp.remakeConstraints({ make in
                make.top.equalTo(episodeArtworkImageView.snp.bottom).offset(episodeTitleTopOffset)
                make.leading.trailing.equalToSuperview().inset(marginSpacing)
                make.height.equalTo(episodeTitleLabelHeight)
            })
            
            dateLabel.snp.remakeConstraints({ make in
                make.leading.trailing.equalToSuperview().inset(marginSpacing)
                make.top.equalTo(episodeTitleLabel.snp.bottom)
                make.height.equalTo(dateLabelHeight)
            })
        } else {
            episodeArtworkImageView.snp.remakeConstraints({ make in
                make.width.equalToSuperview().multipliedBy(artworkSmallWidthMultiplier)
                make.height.equalTo(episodeArtworkImageView.snp.width)
                make.leading.equalTo(marginSpacing)
                make.top.equalToSuperview().offset(artworkY)
            })
            
            episodeTitleLabel.snp.remakeConstraints({ make in
                make.top.equalTo(episodeArtworkImageView.snp.top)
                make.leading.equalTo(episodeArtworkImageView.snp.trailing).offset(episodeTitleShowMoreSpacing)
                make.trailing.equalToSuperview().inset(trailingSpacing)
            })
            
            dateLabel.snp.remakeConstraints({ make in
                make.top.equalTo(episodeTitleLabel.snp.bottom)
                make.bottom.greaterThanOrEqualTo(episodeArtworkImageView.snp.bottom)
                make.leading.equalTo(episodeArtworkImageView.snp.trailing).offset(episodeTitleShowMoreSpacing)
                make.trailing.equalToSuperview().inset(trailingSpacing)
            })
        }
        descriptionTextView.snp.remakeConstraints({ make in
            make.top.equalTo(dateLabel.snp.bottom).offset(descriptionTextViewTopOffset)
            make.leading.trailing.equalToSuperview().inset(marginSpacing)
            make.bottom.lessThanOrEqualToSuperview().inset(descriptionTextViewShowMoreTopOffset)
        })

        seeMoreButton.snp.remakeConstraints { make in
            make.trailing.equalTo(descriptionTextView.snp.trailing)
            make.height.equalTo(seeMoreButtonHeight)
            make.bottom.equalToSuperview()
        }

        descriptionTextView.isScrollEnabled = !expandedArtwork
        seeMoreButton.setTitle(expandedArtwork ? "Show More" : "Show Less", for: .normal)
        layoutIfNeeded()
    }

    @objc func viewDragged(_ sender: UIPanGestureRecognizer) {
        delegate?.playerEpisodeDetailViewDidDrag(sender: sender)
    }
    
    @objc func showMoreTapped() {
        expandedArtwork = !expandedArtwork
        UIView.animate(withDuration: 0.5) {
            self.layoutUI()
        }
    }
    
    @objc func didPressSeriesArtwork() {
        delegate?.playerEpisodeDetailViewDidTapArtwork()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != seeMoreButton
    }

}
