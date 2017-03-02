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
    
    //initializer with all attributes
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
    
    //initializer without smallArtworkImageURL optional
    init(episodeID: Int, episodeTitle: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", episodeLength: Double = 0.0, numberOfRecommendations: Int = 0, tags: [Tag] = [], seriesTitle: String = "", isBookmarked: Bool = false, isRecommended: Bool = false) {
        self.episodeID = episodeID
        self.episodeTitle = episodeTitle
        self.dateCreated = dateCreated
        self.descriptionText = descriptionText
        self.tags = tags
        self.episodeLength = episodeLength
        self.numberOfRecommendations = numberOfRecommendations
        self.seriesTitle = seriesTitle
        self.isRecommended = isRecommended
        self.isBookmarked = isBookmarked
        super.init()
    }
    
    
    convenience init(json: JSON) {
        let episodeID = json["episode_id"].int ?? 0
        let episodeTitle = json["episode_title"].string ?? ""
        let dateString = json["date"].string ?? ""
        let descriptionText = json["description"].string ?? ""
        let isRecommended = json["is_recommended"].bool ?? false
        let isBookmarked = json["is_bookmarked"].bool ?? false
        let numberOfRecommendations = json["n_recommendations"].int ?? 0
        let seriesTitle = json["series_title"].string ?? ""
        let episodeLength = json["episode_length"].double ?? 0.0
        let tags = json["tags"].arrayValue.map({ (tag: JSON) in Tag(name: tag.stringValue) })
        
        let dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        
        if let smallArtworkURL = URL(string: json["small_image_url"].stringValue) {
            self.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, episodeLength: episodeLength, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended)
        } else {
            self.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, episodeLength: episodeLength, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended)
        }
    }
}
