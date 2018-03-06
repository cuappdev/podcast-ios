//
//  NullProfileTableViewCell.swift
//  Podcast
//
//  Created by Jack Thompson on 3/4/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NullProfileTableViewCell: UITableViewCell {

    let addIconSize = 16
    
    //current user null profile
    var addIcon: UIImageView!
    
    //other user null profile
    var nullLabel: UILabel!
    let labelHeight:CGFloat = 21
    let labelOffset:CGFloat = 20
    
    static var heightForCurrentUser: CGFloat = 100
    static var heightForUser: CGFloat = 24
    
    init(user: User) {
        super.init(style: .default, reuseIdentifier: nil)
        
        self.selectionStyle = .none
        
        if System.currentUser == user {
            backgroundColor = .lightGrey
            
            addIcon = UIImageView()
            addIcon.image = #imageLiteral(resourceName: "add_icon")
            addSubview(addIcon)
            
            addIcon.snp.makeConstraints { (make) in
                make.center.equalToSuperview()
                make.width.height.equalTo(addIconSize)
            }
        }
        else {
            backgroundColor = .clear
            
            nullLabel = UILabel()
            nullLabel.text = "\(user.firstName) has not recasted any episodes yet."
            nullLabel.font = ._14RegularFont()
            nullLabel.textColor = .slateGrey
            nullLabel.textAlignment = .left
            addSubview(nullLabel)
            
            nullLabel.snp.makeConstraints { (make) in
                make.leading.equalToSuperview().offset(labelOffset)
                make.top.equalToSuperview()
                make.height.equalTo(labelHeight)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
