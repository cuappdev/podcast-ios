//
//  UserFeedElementSupplierView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

class UserFeedElementSupplierView: UIView {
    
    var userSupplierView: SupplierView!
    
    init(users: [User]) {
        super.init(frame: CGRect.zero)
    
        userSupplierView = SupplierView()
        userSupplierView.setupWithUsers(users: users)
        addSubview(userSupplierView)
        
        userSupplierView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

