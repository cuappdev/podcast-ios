//
//  ProfileMiniHeader.swift
//  Podcast
//
//  Created by Drew Dunne on 11/3/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

// Only use along with ProfileHeaderView

import UIKit

class ProfileMiniHeader: UIView {
    
    let statusBarHeight:CGFloat = 20
    
    private var topBar: UIView!
    
    var profileBG: UIView!
    var profileArea: UIView!
    var usernameLabel: UILabel!
    var nameLabel: UILabel!
    var profileImage: UIImageView!
    var followButton: UIButton!
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            profileImage.image = user.image
            nameLabel.text = user.name
            usernameLabel.text = "@"+user.username
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        topBar = UIView(frame: CGRect(x:0, y:0, width: frame.size.width, height: statusBarHeight))
        topBar.backgroundColor = UIColor.podcastWhite
        
        profileArea = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: frame.size.width, height: PHVConstants.miniHeight-statusBarHeight))
        profileArea.backgroundColor = UIColor.clear;
        profileArea.alpha = 1
        
        profileImage = UIImageView(frame: .zero)
        profileImage.layer.masksToBounds = true
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.podcastWhite.cgColor
        profileImage.alpha = 0
        profileArea.addSubview(profileImage)
        
        nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightSemibold)
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.podcastWhite
        nameLabel.text = "@"
        nameLabel.numberOfLines = 1
        nameLabel.alpha = 0
        profileArea.addSubview(nameLabel)
        
        usernameLabel = UILabel(frame: CGRect.zero)
        usernameLabel.font = UIFont.systemFont(ofSize: 16)
        usernameLabel.textAlignment = .left
        usernameLabel.textColor = UIColor.podcastWhite
        usernameLabel.text = "@"
        usernameLabel.numberOfLines = 1
        usernameLabel.alpha = 0
        profileArea.addSubview(usernameLabel)
        
        setTopOpacity(0)
        
        self.layer.shadowOffset = CGSize(width: 0, height: 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.0;
        
        self.addSubview(topBar)
        self.addSubview(profileArea)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        // Width for bottom bar buttons
        let proImgWidth:CGFloat = 41
        let padding: CGFloat = 12
        let labelHeight: CGFloat = 19
        let labelWidth: CGFloat = self.frame.size.width-4*padding
        let labelSpacing: CGFloat = 3
        let labelX = 3*padding+proImgWidth
        profileArea.frame = CGRect(x: 0, y: statusBarHeight, width: self.frame.size.width, height: PHVConstants.miniHeight-statusBarHeight)
        profileImage.frame = CGRect(x: 2*padding, y: padding, width: proImgWidth, height: proImgWidth)
        profileImage.layer.cornerRadius = proImgWidth/2.0
        nameLabel.frame = CGRect(x: labelX, y: padding, width: labelWidth, height: labelHeight)
        usernameLabel.frame = CGRect(x: labelX, y: padding+labelHeight+labelSpacing, width: labelWidth, height: labelHeight)
    }
    
    func setTopOpacity(_ opacity: CGFloat) {
        
        self.profileArea.backgroundColor = opacity == 1 ? UIColor.podcastGrayDark : UIColor.clear
        UIView.animate(withDuration: 0.1, animations: {
            self.usernameLabel.alpha = opacity
            self.nameLabel.alpha = opacity
            self.profileImage.alpha = opacity
            self.layer.shadowOpacity = opacity == 0 ? 0 : 0.35;
        })
        
        
    }

}
