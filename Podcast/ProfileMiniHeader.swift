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
    
    let height = ProfileHeaderView.miniBarHeight - ProfileHeaderView.statusBarHeight
    let statusBarHeight: CGFloat = ProfileHeaderView.statusBarHeight
    
    let nameLabelY: CGFloat = 7
    let nameLabelHeight: CGFloat = 19
    let usernameLabelY: CGFloat = 27
    let usernameLabelHeight: CGFloat = 17
    let usernameBottomPadding: CGFloat = 4
    let separatorHeight: CGFloat = 2
    let iPhoneXTopOffset: CGFloat = 10
    
    var topOffset:CGFloat = 0
    
    var topBar: UIView!
    
    var profileArea: UIView!
    var usernameLabel: UILabel!
    var nameLabel: UILabel!
    var separator: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        clipsToBounds = true
        
        if UIScreen.main.nativeBounds.height == 2436 { topOffset == iPhoneXTopOffset }
        
        topBar = UIView(frame: CGRect(x:0, y:0, width: frame.width, height: statusBarHeight))
        topBar.backgroundColor = .sea
        
        profileArea = UIView(frame: CGRect(x: 0, y: statusBarHeight, width: frame.width, height: height))
        profileArea.backgroundColor = .sea
        profileArea.alpha = 1
        
        nameLabel = UILabel(frame: CGRect.zero)
        nameLabel.font = ._16SemiboldFont()
        nameLabel.textAlignment = .center
        nameLabel.textColor = .offWhite
        nameLabel.text = "@"
        nameLabel.numberOfLines = 1
        profileArea.addSubview(nameLabel)
        
        usernameLabel = UILabel(frame: CGRect.zero)
        usernameLabel.font = ._14RegularFont()
        usernameLabel.textAlignment = .center
        usernameLabel.textColor = .offWhite
        usernameLabel.alpha = 0.7
        usernameLabel.text = "@"
        usernameLabel.numberOfLines = 1
        profileArea.addSubview(usernameLabel)
        
        separator = UIView(frame: .zero)
        separator.backgroundColor = .offBlack
        separator.alpha = 0.0
        profileArea.addSubview(separator)
        
        setMiniHeaderState(false)
        
        layer.shadowOffset = CGSize(width: 0, height: 10);
        layer.shadowRadius = 10;
        layer.shadowOpacity = 0.0;
        
        addSubview(topBar)
        addSubview(profileArea)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        // Width for bottom bar buttons
        let padding: CGFloat = 12
        let labelWidth: CGFloat = frame.width - 4 * padding
        let labelX = 2 * padding
        profileArea.frame = CGRect(x: 0, y: statusBarHeight, width: frame.width, height: height)
        nameLabel.frame = CGRect(x: 2 * padding, y: nameLabelY + topOffset, width: labelWidth, height: nameLabelHeight)
        usernameLabel.frame = CGRect(x: labelX, y: nameLabel.frame.maxY, width: labelWidth, height: usernameLabelHeight)
        separator.frame = CGRect(x: 0, y: frame.height - separatorHeight, width: frame.width, height: separatorHeight)
    }
    
    func setUser(_ user: User) {
        nameLabel.text = user.fullName()
        usernameLabel.text = "@\(user.username)"
    }
    
    func setMiniHeaderState(_ isShowing: Bool) {
        frame.size = isShowing ? CGSize(width: frame.width, height: ProfileHeaderView.miniBarHeight) : CGSize(width: frame.width, height: statusBarHeight)
    }
    
    func setMiniHeaderShadowState(_ isShowing: Bool) {
        separator.alpha = isShowing ? 1.0 : 0.0
    }

}
