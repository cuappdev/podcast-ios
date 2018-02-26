//
//  LoginPodcastLogoView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 4/26/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//
import UIKit

class LoginPodcastLogoView: UIView {
    
    var podcastLogo: ImageView!
    var podcastTitle: UILabel!
    var podcastDescription: UILabel!
    
    //Constants
    var podcastLogoWidth: CGFloat = 35
    var podcastLogoHeight: CGFloat = 35
    var paddingLogoTitle: CGFloat = 30
    var paddingTitleDescription: CGFloat = 16

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        podcastLogo = ImageView(frame: CGRect(x: 0, y: 0, width: podcastLogoWidth, height: podcastLogoHeight))
        podcastLogo.center.x = center.x
        podcastLogo.center.y = 1/4 * frame.height
        podcastLogo.image = #imageLiteral(resourceName: "logoPlaceholder")
        addSubview(podcastLogo)
        
        podcastTitle = UILabel(frame: CGRect.zero)
        podcastTitle.text = "Castaway"
        podcastTitle.font = ._20SemiboldFont()
        podcastTitle.textColor = .offWhite
        podcastTitle.sizeToFit()
        podcastTitle.center.x = podcastLogo.center.x
        podcastTitle.frame.origin.y = podcastLogo.frame.maxY + paddingLogoTitle
        addSubview(podcastTitle)
        
        podcastDescription = UILabel(frame: CGRect.zero)
        podcastDescription.text = "Not just another podcast app."
        podcastDescription.font = ._16RegularFont()
        podcastDescription.textColor = .offWhite
        podcastDescription.sizeToFit()
        podcastDescription.center.x = podcastTitle.center.x
        podcastDescription.frame.origin.y = podcastTitle.frame.maxY + paddingTitleDescription
        addSubview(podcastDescription)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

