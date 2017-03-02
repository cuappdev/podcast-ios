//
//  TagCard.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

//suggestion card based off tags user has liked
class TagCard: EpisodeCard {
    
    var tag: Tag!
    
    //init with all atributes
    init(episodeID: Int, episodeTitle: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", smallArtworkImageURL: URL, episodeLength: Double = 0.0, numberOfRecommendations: Int = 0, tags: [Tag] = [], seriesTitle: String = "", isBookmarked: Bool = false, isRecommended: Bool = false, tag: Tag = Tag(name: "")) {
        
        self.tag = tag
        super.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, episodeLength: episodeLength, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended)
    }
    
    //init without smallArtworkImageURL optional
    init(episodeID: Int, episodeTitle: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", episodeLength: Double = 0.0, numberOfRecommendations: Int = 0, tags: [Tag] = [], seriesTitle: String = "", isBookmarked: Bool = false, isRecommended: Bool = false, tag: Tag = Tag(name: "")) {
        
        self.tag = tag
        super.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, episodeLength: episodeLength, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended)
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
        let tag = Tag(name: json["tag"].string ?? "")
        
        let dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        
        if let smallArtworkURL = URL(string: json["small_image_url"].stringValue) {
            self.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, episodeLength: episodeLength, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended, tag: tag)
        } else {
            self.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, episodeLength: episodeLength, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended, tag: tag)
        }
    }
}
