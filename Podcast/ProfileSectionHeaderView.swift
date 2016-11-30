//
//  ProfileSectionHeaderView.swift
//  Podcast
//
//  Created by Drew Dunne on 11/16/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

let profileSectionHeaderViewHeight: CGFloat = 37

class ProfileSectionHeaderView: UIView {
    
    var sectionTitle: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.podcastWhite
        
        sectionTitle = UILabel(frame: CGRect(x: 30, y: 9, width: frame.width-60, height: 19))
        sectionTitle.text = ""
        sectionTitle.textColor = .podcastBlack
        sectionTitle.textAlignment = .left
        sectionTitle.numberOfLines = 1
        sectionTitle.font = .boldSystemFont(ofSize: 16)
        addSubview(sectionTitle)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
