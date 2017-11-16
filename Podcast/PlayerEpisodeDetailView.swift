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
    let descriptionTextViewTopOffset: CGFloat = 3.5
    let descriptionTextViewShowMoreTopOffset: CGFloat = 19
    let recommendButtonSpacing: CGFloat = 22.5
    let bottomSpacing: CGFloat = 28.5
    let episodeTitleShowMoreSpacing: CGFloat = 12
    let dateLabelShowMoreTopOffset: CGFloat = 5.5
    let seeMoreButtonWidth: CGFloat = 100
    let seeMoreButtonHeight: CGFloat = 10
    
    let episodeTitleSpeed: CGFloat = 8
    let episodeTitleTrailingBuffer: CGFloat = 10
    let episodeTitleAnimationDelay: CGFloat = 2

    weak var delegate: PlayerEpisodeDetailDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
                
        episodeArtworkImageView = ImageView(frame: CGRect(x: 0, y: 0, width: artworkLargeDimension.width, height: artworkLargeDimension.height))
        addSubview(episodeArtworkImageView)
                
        episodeTitleLabel = MarqueeLabel(frame: .zero)
        episodeTitleLabel.font = ._16RegularFont()
        episodeTitleLabel.textColor = .charcoalGrey
        episodeTitleLabel.numberOfLines = 1
        episodeTitleLabel.lineBreakMode = .byTruncatingTail
        episodeTitleLabel.speed = .duration(episodeTitleSpeed)
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
        addSubview(dateLabel)
        
        descriptionTextView = UITextView(frame: .zero)
        descriptionTextView.isEditable = false
        descriptionTextView.font = ._14RegularFont()
        descriptionTextView.textColor = .charcoalGrey
        descriptionTextView.showsVerticalScrollIndicator = false
        descriptionTextView.backgroundColor = .clear
        addSubview(descriptionTextView)
        
        seeMoreButton = Button()
        seeMoreButton.frame = CGRect(x: 0, y: 0, width: seeMoreButtonWidth, height: seeMoreButtonHeight)
        seeMoreButton.setTitleColor(.sea, for: .normal)
        seeMoreButton.titleLabel?.font = ._14RegularFont()
        seeMoreButton.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
        addSubview(seeMoreButton)

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewDragged(_:)))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }
    
    func updateUIForEpisode(episode: Episode) {
        episodeArtworkImageView.setImageAsynchronouslyWithDefaultImage(url: episode.largeArtworkImageURL)
        episodeTitleLabel.text = episode.title
        dateLabel.text = episode.dateTimeSeriesString()
        let mutableString = NSMutableAttributedString(attributedString: episode.attributedDescription)
        mutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.charcoalGrey, range: NSMakeRange(0, mutableString.length))
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 4
        mutableString.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSMakeRange((0), mutableString.length))
        mutableString.addAttribute(NSAttributedStringKey.font, value: UIFont._14RegularFont(), range: NSMakeRange(0, mutableString.length))
        descriptionTextView.attributedText = mutableString
        expandedArtwork = true
        episodeTitleLabel.holdScrolling = false
        layoutUI()
    }
    
    func layoutUI() {
        if expandedArtwork {
            episodeArtworkImageView.snp.remakeConstraints({ make in
                make.top.equalToSuperview().offset(artworkY)
                make.width.equalToSuperview().multipliedBy(artworkLargeWidthMultiplier)
                make.height.equalTo(episodeArtworkImageView.snp.width)
                make.centerX.equalToSuperview()
            })
            
            episodeTitleLabel.snp.remakeConstraints({ make in
                make.top.equalTo(episodeArtworkImageView.snp.bottom).offset(episodeTitleTopOffset)
                make.leading.trailing.equalToSuperview().inset(marginSpacing)
            })
            
            dateLabel.snp.remakeConstraints({ make in
                make.leading.trailing.equalToSuperview().inset(marginSpacing)
                make.top.equalTo(episodeTitleLabel.snp.bottom)
                make.height.equalTo(dateLabelHeight)
            })
            
            descriptionTextView.snp.remakeConstraints({ make in
                make.top.equalTo(dateLabel.snp.bottom).offset(descriptionTextViewTopOffset)
                make.leading.trailing.equalToSuperview().inset(marginSpacing-6) // not sure why this inset is different
                make.bottom.equalToSuperview().inset(seeMoreButtonHeight)
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
                make.height.equalTo(episodeTitleLabelHeight)
            })
            
            dateLabel.snp.remakeConstraints({ make in
                make.top.equalTo(episodeTitleLabel.snp.bottom).offset(dateLabelShowMoreTopOffset)
                make.leading.equalTo(episodeArtworkImageView.snp.trailing).offset(episodeTitleShowMoreSpacing)
                make.trailing.equalToSuperview().inset(trailingSpacing)
                make.height.equalTo(dateLabelHeight)
            })
        }
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != seeMoreButton
    }

}
