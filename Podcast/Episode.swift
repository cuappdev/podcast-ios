//
//  Episode.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class Episode: NSObject {
    
    var id: Int
    var title: String = ""
    var series: Series?
    var dateCreated: NSDate?
    var smallArtworkImageURL: NSURL?
    var largeArtworkImageURL: NSURL?
    var smallArtworkImage: UIImage?
    var largeArtworkImage: UIImage?
    
    init(id: Int) {
        self.id = id
    }
}
