//
//  UserDetailNavigationBar.swift
//  Podcast
//
//  Created by Drew Dunne on 3/8/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class UserDetailNavigationBar: UIView {
    
    static let navBarHeight = 44 + UIApplication.shared.statusBarFrame.height
    
    let padding: CGFloat = 50
    
    let nameLabelBottomY: CGFloat = 22
    let nameLabelHeight: CGFloat = 19
    
    let usernameLabelBottomY: CGFloat = 4
    let usernameLabelHeight: CGFloat = 17
    
    var statusBarBackground: UIView!
    var navBarBackground: UIView!
    var nameLabel: UILabel!
    var usernameLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        statusBarBackground = UIView()
        statusBarBackground.backgroundColor = .sea
        addSubview(statusBarBackground)
        statusBarBackground.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(UIApplication.shared.statusBarFrame.height)
        }
        
        navBarBackground = UIView()
        navBarBackground.backgroundColor = .sea
        navBarBackground.isHidden = true
        addSubview(navBarBackground)
        navBarBackground.snp.makeConstraints { make in
            make.top.equalTo(statusBarBackground.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        nameLabel = UILabel(frame: .zero)
        nameLabel.font = ._16SemiboldFont()
        nameLabel.textAlignment = .center
        nameLabel.textColor = .offWhite
        nameLabel.text = ""
        nameLabel.numberOfLines = 1
        navBarBackground.addSubview(nameLabel)
        
        usernameLabel = UILabel(frame: .zero)
        usernameLabel.font = ._14RegularFont()
        usernameLabel.textAlignment = .center
        usernameLabel.textColor = .offWhite
        usernameLabel.alpha = 0.7
        usernameLabel.text = "@"
        usernameLabel.numberOfLines = 1
        navBarBackground.addSubview(usernameLabel)
        
        nameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(nameLabelHeight)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.bottom.equalToSuperview().inset(nameLabelBottomY)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(usernameLabelHeight)
            make.leading.trailing.equalToSuperview().inset(padding)
            make.bottom.equalToSuperview().inset(usernameLabelBottomY)
        }
        
    }
    
    func configure(for user: User) {
        nameLabel.text = user.fullName()
        usernameLabel.text = "@\(user.username)"
    }
    
    func set(shouldHideNavBar: Bool) {
        navBarBackground.isHidden = shouldHideNavBar
        nameLabel.isHidden = shouldHideNavBar
        usernameLabel.isHidden = shouldHideNavBar
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
