//
//  NullProfileCollectionViewCell.swift
//  Podcast
//
//  Created by Jack Thompson on 2/28/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NullProfileCollectionViewCell: UICollectionViewCell {
    
    var plusButton: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        plusButton.image = nil //get image asset
        
        plusButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
