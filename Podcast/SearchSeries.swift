//
//  SearchSeries.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class SearchSeries: NSObject {
    
    var id: Int
    var title: String = ""
    var smallArtworkImageURL: URL?
    var smallArtworkImage: UIImage?
    var numberOfSubscribers: Int = 0
    var isSubscribed = false
    var author: String = ""
    
    
    init(id: Int) {
        self.id = id
    }
    
    init(id: Int, title: String = "", author: String = "", smallArtworkImageURL: URL, isSubscribed: Bool = false, numberOfSubscribers: Int = 0) {
        self.id = id
        self.title = title
        self.smallArtworkImageURL = smallArtworkImageURL
        self.author = author
        self.isSubscribed = isSubscribed
        self.numberOfSubscribers = numberOfSubscribers
        super.init()
    }
    
    /*
     convenience init(_json: JSON) {
     //TODO: make these consistent with backend
     
     //self.init( ... )
     }
     */
}
