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
    var seriesTitle: String = ""
    var dateCreated: Date!
    var descriptionText: String!
    var smallArtworkImageURL: URL?
    var largeArtworkImageURL: URL?
    var smallArtworkImage: UIImage?
    var largeArtworkImage: UIImage?
    var mp3URL : URL?
    var duration: Double = 0
    var tags : [Tag] = []
    var numberOfRecommendations = 0
    var isBookmarked = false
    var isRecommended = false
    var isPlaying = false
    
    init(id: Int) {
        self.id = id 
    }
    
    init(id: Int, title: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", smallArtworkImageURL: URL, largeArtworkImageURL: URL, mp3URL : String = "", duration: Double = 0, seriesTitle: String = "", tags: [Tag] = [], numberOfRecommendations: Int = 0, isRecommended: Bool = false, isBookmarked: Bool = false, isPlaying:Bool = false) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.descriptionText = descriptionText
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        self.mp3URL = URL(string: mp3URL)
        self.isRecommended = isRecommended
        self.isBookmarked = isBookmarked
        self.isPlaying = isPlaying
        self.numberOfRecommendations = numberOfRecommendations
        self.seriesTitle = seriesTitle
        self.duration = duration
        self.tags = tags
        super.init()
    }
    
    /*
     convenience init(_json: JSON) {
     //TODO: make these consistent with backend
     
     //self.init( ... )
     }
     */
}
