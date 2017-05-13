//
//  EpisodeDetailView.swift
//  Podcast
//
//  Created by Mark Bryan on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class PlayerEpisodeDetailView: UIView {
    
    var expandedArtwork: Bool = true
    
    var episodeArtworkImageView: ImageView!
    var episodeTitleLabel: UILabel!
    var dateLabel: UILabel!
    var descriptionTextView: UITextView!
    var seeMoreButton: UIButton!
    
    let marginSpacing: CGFloat = 18
    let artworkY: CGFloat = 10
    
    let artworkLargeDimension: CGSize = CGSize(width: 300, height: 300)
    let artworkSmallDimension: CGSize = CGSize(width: 60, height: 60)
    
    let episodeTitleYInset: CGFloat = 13
    let episodeTitleLabelHeight: CGFloat = 16
    let dateLabelYSpacing: CGFloat = 8
    let dateLabelHeight: CGFloat = 14
    let descriptionTextViewSpacing: CGFloat = 8
    let recommendButtonSpacing: CGFloat = 22.5
    let bottomSpacing: CGFloat = 28.5
    
    let seeMoreButtonWidth: CGFloat = 100
    let seeMoreButtonHeight: CGFloat = 25
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .podcastPlayerGray
        
        episodeArtworkImageView = ImageView(frame: CGRect(x: 0, y: 0, width: artworkLargeDimension.width, height: artworkLargeDimension.height))
        addSubview(episodeArtworkImageView)
        
        episodeTitleLabel = UILabel(frame: .zero)
        episodeTitleLabel.font = UIFont.systemFont(ofSize: 16)
        episodeTitleLabel.textColor = .charcolGray
        episodeTitleLabel.numberOfLines = 1
        episodeTitleLabel.lineBreakMode = .byTruncatingTail
        addSubview(episodeTitleLabel)
        
        dateLabel = UILabel(frame: .zero)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .podcastDetailGray
        addSubview(dateLabel)
        
        descriptionTextView = UITextView(frame: .zero)
        descriptionTextView.isEditable = false
        descriptionTextView.backgroundColor = .clear
        addSubview(descriptionTextView)
        
        seeMoreButton = UIButton(frame: CGRect(x: 0, y: 0, width: seeMoreButtonWidth, height: seeMoreButtonHeight))
        seeMoreButton.setTitleColor(.podcastPlayerTeal, for: .normal)
        seeMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        seeMoreButton.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
        addSubview(seeMoreButton)
    }
    
    func updateUIForEpisode(episode: Episode) {
        if let url = episode.largeArtworkImageURL {
            episodeArtworkImageView.setImageAsynchronously(url: url, completion: nil)
        }
        episodeTitleLabel.text = episode.title
        dateLabel.text = episode.dateTimeSeriesString()
        let mutableString = NSMutableAttributedString(attributedString: episode.attributedDescriptionString())
        mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.podcastPlayerDescriptionGray, range: NSMakeRange(0, mutableString.length))
        mutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, mutableString.length))
        descriptionTextView.attributedText = mutableString
        expandedArtwork = true
        layoutUI()
    }
    
    func layoutUI() {
        if expandedArtwork {
            episodeArtworkImageView.frame.size = artworkLargeDimension
            episodeArtworkImageView.frame.origin = CGPoint(x: (frame.size.width - artworkLargeDimension.width)/2, y: artworkY)
            episodeTitleLabel.frame.origin = CGPoint(x: marginSpacing, y: episodeArtworkImageView.frame.maxY + episodeTitleYInset)
            episodeTitleLabel.frame.size = CGSize(width: frame.size.width - marginSpacing - episodeTitleLabel.frame.origin.x, height: episodeTitleLabelHeight)
            dateLabel.frame.origin = CGPoint(x: marginSpacing, y: episodeTitleLabel.frame.maxY + dateLabelYSpacing)
        } else {
            episodeArtworkImageView.frame.size = artworkSmallDimension
            episodeArtworkImageView.frame.origin = CGPoint(x: marginSpacing, y: artworkY)
            episodeTitleLabel.frame.origin = CGPoint(x: episodeArtworkImageView.frame.maxX + marginSpacing, y: episodeArtworkImageView.frame.origin.y + episodeTitleYInset)
            episodeTitleLabel.frame.size = CGSize(width: frame.size.width - marginSpacing - episodeTitleLabel.frame.origin.x, height: episodeTitleLabelHeight)
            dateLabel.frame.origin = CGPoint(x: episodeArtworkImageView.frame.maxX + marginSpacing, y: episodeTitleLabel.frame.maxY + dateLabelYSpacing)
        }
        
        dateLabel.frame.size = CGSize(width: frame.width - marginSpacing - dateLabel.frame.origin.x, height: dateLabelHeight)
        descriptionTextView.frame.origin = CGPoint(x: marginSpacing, y: dateLabel.frame.maxY + descriptionTextViewSpacing)
        descriptionTextView.frame.size = CGSize(width: frame.size.width - 2 * marginSpacing, height: frame.height - descriptionTextView.frame.origin.y - seeMoreButton.frame.height)
        descriptionTextView.isScrollEnabled = !expandedArtwork
        
        seeMoreButton.frame.origin = CGPoint(x: descriptionTextView.frame.maxX - seeMoreButton.frame.width, y: descriptionTextView.frame.maxY)
        seeMoreButton.setTitle(expandedArtwork ? "Show More" : "Show Less", for: .normal)
    }
    
    func showMoreTapped() {
        expandedArtwork = !expandedArtwork
        UIView.animate(withDuration: 0.5) {
            self.layoutUI()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
