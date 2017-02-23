//
//  EpisodeDetailView.swift
//  Podcast
//
//  Created by Mark Bryan on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class EpisodeDetailView: UIView {
    
    var episodeArtworkImageView: UIImageView!
    var seriesTitleLabel: UILabel!
    var episodeTitleLabel: UILabel!
    var dateLabel: UILabel!
    var descriptionLabel: UILabel!
    var recommendButton: UIButton!
    
    let LeftMargin: CGFloat = 24
    let ArtworkDimension: CGFloat = 45.5
    let EpisodeTitleYInset: CGFloat = 81.5
    let DateLabelYSpacing: CGFloat = 12
    let DescriptionLabelSpacing: CGFloat = 24
    let RecommendButtonSpacing: CGFloat = 22.5
    let BottomSpacing: CGFloat = 28.5
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        episodeArtworkImageView = UIImageView(frame: .zero)
        episodeArtworkImageView.frame.origin = CGPoint(x: LeftMargin, y: LeftMargin)
        episodeArtworkImageView.frame.size = CGSize(width: ArtworkDimension, height: ArtworkDimension)
        addSubview(episodeArtworkImageView)
        
        seriesTitleLabel = UILabel(frame: .zero)
        seriesTitleLabel.font = UIFont.systemFont(ofSize: 16)
        seriesTitleLabel.textColor = UIColor.colorFromCode(0x4aaea9)
        addSubview(seriesTitleLabel)
        
        episodeTitleLabel = UILabel(frame: .zero)
        episodeTitleLabel.font = UIFont.systemFont(ofSize: 24)
        episodeTitleLabel.lineBreakMode = .byWordWrapping
        episodeTitleLabel.numberOfLines = 0
        addSubview(episodeTitleLabel)
        
        dateLabel = UILabel(frame: .zero)
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        addSubview(dateLabel)
        
        descriptionLabel = UILabel(frame: .zero)
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.colorFromCode(0xa8a8b4)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        addSubview(descriptionLabel)
        
        recommendButton = UIButton(frame: .zero)
        recommendButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        recommendButton.setTitleColor(UIColor.colorFromCode(0xa8a8b4), for: .normal)
        recommendButton.setTitle("Recommend", for: .normal)
        recommendButton.sizeToFit()
        recommendButton.frame.origin.x = LeftMargin
        recommendButton.addTarget(self, action: #selector(recommendTapped), for: .touchUpInside)
        addSubview(recommendButton)
        
        updateUI()
    }
    
    func updateUI() {
        episodeArtworkImageView.image = #imageLiteral(resourceName: "sample_series_artwork")
        
        seriesTitleLabel.frame = CGRect(x: 81.5, y: 24, width: frame.size.width - 81.5 - 12, height: 45.5)
        seriesTitleLabel.text = "Wait Wait...Don't Tell Me!"
        
        episodeTitleLabel.frame = CGRect(x: LeftMargin, y: EpisodeTitleYInset, width: frame.size.width - 2 * LeftMargin, height: 85.5)
        episodeTitleLabel.text = "E194: Election Freakout Purchases and other Prepper Questions"
        episodeTitleLabel.sizeToFit()
        
        dateLabel.text = "November 7, 2016"
        dateLabel.frame.origin = CGPoint(x: LeftMargin, y: episodeTitleLabel.frame.maxY + DateLabelYSpacing)
        dateLabel.sizeToFit()
        
        descriptionLabel.frame.origin = CGPoint(x: LeftMargin, y: dateLabel.frame.maxY + DescriptionLabelSpacing)
        descriptionLabel.frame.size = CGSize(width: frame.size.width - 2 * LeftMargin, height: 0)
        descriptionLabel.text = "In this episode, your listener questions will be answered. We’ll discuss hiding your peppers, self-defense options for those with poor eyesight, short barrel rifle questions, and probably one of the hardest questions any of you have every asked me"
        descriptionLabel.sizeToFit()
        
        recommendButton.frame.origin.y = descriptionLabel.frame.maxY + RecommendButtonSpacing
        
        self.frame.size.height = recommendButton.frame.maxY + BottomSpacing
    }
    
    func recommendTapped() {
        // TODO: implement recommend button
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
