//
//  Series.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class Series: NSObject {
    
    var id: Int
    var title: String = ""
    var episodes: [Episode] = []
    var author: String = ""
    var descriptionText: String = ""
    var smallArtworkImageURL: URL?
    var largeArtworkImageURL: URL?
    var smallArtworkImage: UIImage?
    var largeArtworkImage: UIImage?
    var tags: [Tag] = []
    var numberOfSubscribers: Int = 0
    var isSubscribed = false
    
    init(id: Int) {
        self.id = id
    }
    
    init(id: Int, title: String = "", author: String = "", descriptionText: String = "", smallArtworkImageURL: URL, largeArtworkImageURL: URL, tags: [Tag] = [], numberOfSubscribers: Int = 0, isSubscribed: Bool = false) {
    
        self.id = id
        self.title = title
        self.author = author
        self.descriptionText = descriptionText
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        self.numberOfSubscribers = numberOfSubscribers
        self.isSubscribed = isSubscribed
        self.tags = tags
        super.init()
    }
    
    /*
     convenience init(_json: JSON) {
     //TODO: make these consistent with backend
     
     //self.init( ... )
     }
     */
    
    
    func fetchEpisodes() {
        episodes = [] 
    }
}
