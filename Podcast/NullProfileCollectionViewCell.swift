//
//  NullProfileCollectionViewCell.swift
//  Podcast
//
//  Created by Jack Thompson on 2/28/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NullProfileCollectionViewCell: UICollectionViewCell {
    
    let addIconSize = 16
    
    var addIcon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        addIcon.image = #imageLiteral(resourceName: "add_icon")
        addSubview(addIcon)
        
        addIcon.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(addIconSize)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
