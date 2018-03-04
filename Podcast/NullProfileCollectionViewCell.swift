//
//  NullProfileInternalCollectionViewCell.swift
//  Podcast
//
//  Created by Jack Thompson on 2/28/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

enum NullCellType {
    case series
    case subscriptions
    
    var nullMessage: String {
        switch self {
        case .series:
            return " has not subscribed to any series yet."
        case .subscriptions:
            return " has not recommended any episodes yet."
        }
    }
}

import UIKit
import SnapKit

class NullProfileInternalCollectionViewCell: UICollectionViewCell {
    //combine with external profile null cell
    //conditinoally define height for if current user or not
    let addIconSize = 16
    
    //current user null profile
    var addIcon: UIImageView!
    
    //other user null profile
    var nullLabel: UILabel!
    var nullCellType: NullCellType!
    var cellHeight: CGFloat = 108
    
    let labelHeight = 21
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func setUp(type: NullCellType, user: User) {
        if System.currentUser == user {
            cellHeight = 24
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
            cellHeight = 100
            backgroundColor = .clear
            
            nullLabel = UILabel()
            nullLabel.text = user.firstName + type.nullMessage
            nullLabel.font = ._14RegularFont()
            nullLabel.textColor = .slateGrey
            nullLabel.textAlignment = .left
            addSubview(nullLabel)
            
            nullLabel.snp.makeConstraints { (make) in
                make.leading.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(labelHeight)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
