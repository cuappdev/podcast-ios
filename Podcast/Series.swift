//
//  Series.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class Series: NSObject {
    
    var title: String = ""
    var episodes: [Episode] = []
    var publisher: User?
    var coverImage: UIImage?
    var nSubscribers: Int = 0
    
    override init() {
        super.init()
    }
    
}
