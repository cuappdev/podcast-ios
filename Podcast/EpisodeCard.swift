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
    var episodeTitle: String
    var dateCreated: Date
    var episodeLength: Double
    var descriptionText: String
    var smallArtworkImageURL: URL?
    var numberOfRecommendations: Int //number total out of user base that has recommended episode
    var tags: [Tag]
    var seriesTitle: String
    var isBookmarked: Bool
    var isRecommended: Bool
    
    //initializer with all attributes
    init(episodeID: Int, episodeTitle: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, episodeLength: Double, numberOfRecommendations: Int, tags: [Tag], seriesTitle: String, isBookmarked: Bool, isRecommended: Bool) {
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
    
    
   init(json: JSON) {
        self.episodeID = json["episode_id"].intValue
        self.episodeTitle = json["episode_title"].stringValue
        let dateString = json["date"].stringValue
        self.descriptionText = json["description"].stringValue
        self.isRecommended = json["is_recommended"].boolValue
        self.isBookmarked = json["is_bookmarked"].boolValue
        self.numberOfRecommendations = json["n_recommendations"].intValue
        self.seriesTitle = json["series_title"].stringValue
        self.episodeLength = json["episode_length"].doubleValue
        self.tags = json["tags"].arrayValue.map({ (tag: JSON) in Tag(name: tag.stringValue)})
        self.dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        self.smallArtworkImageURL = URL(string: json["small_image_url"].stringValue)
    }
}
