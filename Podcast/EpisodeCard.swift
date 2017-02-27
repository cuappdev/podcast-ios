//
//  EpisodeCard.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class EpisodeCard: Card {
    
    var episodeID: Int
    var episodeTitle = ""
    var dateCreated: Date = Date()
    var episodeLength: Double = 0.0
    var descriptionText = ""
    var smallArtworkImageURL: URL?
    var smallArtworkImage: UIImage?
    var numberOfRecommendations = 0 //number total out of user base that has recommended episode
    var tags: [Tag] = []
    var seriesTitle = ""
    var isBookmarked = false
    var isRecommended = false
    var isPlaying = false
    
    init(episodeID: Int, episodeTitle: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", smallArtworkImageURL: URL, episodeLength: Double = 0.0, numberOfRecommendations: Int = 0, tags: [Tag] = [], seriesTitle: String = "", isBookmarked: Bool = false, isRecommended: Bool = false) {
        self.episodeID = episodeID
        self.episodeTitle = episodeTitle
        self.dateCreated = dateCreated
        self.descriptionText = descriptionText
        self.smallArtworkImageURL = smallArtworkImageURL
        self.tags = tags
        self.episodeLength = episodeLength
        self.numberOfRecommendations = numberOfRecommendations
        self.seriesTitle = seriesTitle
        self.isRecommended = isRecommended
        self.isBookmarked = isBookmarked
        super.init()
    }
    
    
    /*
    convenience init(_json: JSON) {
        //TODO: make these consistent with backend
        
        //self.init( ... )
    }
     */
}
