//
//  BookmarkButton.swift
//  Podcast
//
//  Created by Mark Bryan on 4/27/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class BookmarkButton: Button {

    override init() {
        super.init()
        setImage(#imageLiteral(resourceName: "bookmark_feed_icon_unselected"), for: .normal)
        setImage(#imageLiteral(resourceName: "bookmark_feed_icon_selected"), for: .selected)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
