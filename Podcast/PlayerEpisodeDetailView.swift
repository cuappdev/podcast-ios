//
//  EpisodeDetailView.swift
//  Podcast
//
//  Created by Mark Bryan on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class PlayerEpisodeDetailView: UIView {
    
    var expandedArtwork: Bool
    
    var episodeArtworkImageView: UIImageView!
    var episodeTitleLabel: UILabel!
    var dateLabel: UILabel!
    var descriptionTextView: UITextView!
    var seeMoreButton: UIButton!
    
    let marginSpacing: CGFloat = 18
    let artworkY: CGFloat = 18
    
    let artworkLargeDimension: CGSize = CGSize(width: 300, height: 300)
    let artworkSmallDimension: CGSize = CGSize(width: 60, height: 60)
    
    let episodeTitleYSpacing: CGFloat = 32.5
    let dateLabelYSpacing: CGFloat = 12
    let descriptionTextViewSpacing: CGFloat = 12
    let recommendButtonSpacing: CGFloat = 22.5
    let bottomSpacing: CGFloat = 28.5
    
    override init(frame: CGRect) {
        expandedArtwork = true
        super.init(frame: frame)
        backgroundColor = UIColor.colorFromCode(0xf4f4f7)
        
        episodeArtworkImageView = UIImageView(frame: .zero)
        addSubview(episodeArtworkImageView)
        
        episodeTitleLabel = UILabel(frame: .zero)
        episodeTitleLabel.font = UIFont.systemFont(ofSize: 16)
        episodeTitleLabel.textColor = UIColor.colorFromCode(0x30303c)
        episodeTitleLabel.numberOfLines = 1
        episodeTitleLabel.lineBreakMode = .byTruncatingTail
        addSubview(episodeTitleLabel)
        
        dateLabel = UILabel(frame: .zero)
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = UIColor.colorFromCode(0x959ba5)
        addSubview(dateLabel)
        
        descriptionTextView = UITextView(frame: .zero)
        descriptionTextView.isEditable = false
        descriptionTextView.isSelectable = false
        descriptionTextView.backgroundColor = .clear
        addSubview(descriptionTextView)
        
        seeMoreButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 14))
        seeMoreButton.setTitleColor(UIColor.colorFromCode(0x3ea098), for: .normal)
        seeMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        seeMoreButton.addTarget(self, action: #selector(showMoreTapped), for: .touchUpInside)
        addSubview(seeMoreButton)
    }
    
    func updateUIForEpisode(episode: Episode) {
        episodeArtworkImageView.image = #imageLiteral(resourceName: "filler_image")
        if let url = episode.largeArtworkImageURL {
            if let data = try? Data(contentsOf: url) {
                episodeArtworkImageView.image = UIImage(data: data)
            }
        }
        episodeTitleLabel.text = episode.title
        dateLabel.text = episode.dateTimeSeriesString()
        let mutableString = NSMutableAttributedString(attributedString: episode.attributedDescriptionString())
        mutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.colorFromCode(0x64676c), range: NSMakeRange(0, mutableString.length))
        mutableString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: NSMakeRange(0, mutableString.length))
        descriptionTextView.attributedText = mutableString
        expandedArtwork = true
        layoutUI()
    }
    
    func layoutUI() {
        if expandedArtwork {
            episodeArtworkImageView.frame.size = artworkLargeDimension
            episodeArtworkImageView.frame.origin = CGPoint(x: (frame.size.width - artworkLargeDimension.width)/2, y: artworkY)
            episodeTitleLabel.frame = CGRect(x: marginSpacing, y: episodeArtworkImageView.frame.maxY + episodeTitleYSpacing, width: frame.size.width - 2 * marginSpacing, height: 16)
            dateLabel.frame.origin = CGPoint(x: marginSpacing, y: episodeTitleLabel.frame.maxY + dateLabelYSpacing)
        } else {
            episodeArtworkImageView.frame.size = artworkSmallDimension
            episodeArtworkImageView.frame.origin = CGPoint(x: 18, y: artworkY)
            episodeTitleLabel.frame = CGRect(x: episodeArtworkImageView.frame.maxX + marginSpacing, y: 31, width: frame.size.width - 2 * marginSpacing, height: 16)
            dateLabel.frame.origin = CGPoint(x: episodeArtworkImageView.frame.maxX + marginSpacing, y: episodeTitleLabel.frame.maxY + dateLabelYSpacing)
        }
        
        dateLabel.frame.size = CGSize(width: frame.width - marginSpacing - dateLabel.frame.origin.x, height: 14.5)
        descriptionTextView.frame.origin = CGPoint(x: marginSpacing, y: dateLabel.frame.maxY + descriptionTextViewSpacing)
        descriptionTextView.frame.size = CGSize(width: frame.size.width - 2 * marginSpacing, height: frame.height - descriptionTextView.frame.origin.y - 10)
        descriptionTextView.isScrollEnabled = !expandedArtwork
        
        seeMoreButton.frame.origin = CGPoint(x: descriptionTextView.frame.maxX - seeMoreButton.frame.width, y: descriptionTextView.frame.maxY - seeMoreButton.frame.height)
        seeMoreButton.setTitle(expandedArtwork ? "Show More" : "Show Less", for: .normal)
    }
    
    func recommendTapped() {
        // TODO: implement recommend button
    }
    
    func showMoreTapped() {
        print("showMoreTapped")
        expandedArtwork = !expandedArtwork
        UIView.animate(withDuration: 0.5) {
            self.layoutUI()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
