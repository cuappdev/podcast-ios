//
//  ReleaseCard.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

//when a series releases an episode 
class ReleaseCard: EpisodeCard {
    
    var seriesID = 0
    var seriesImageURL: URL?
    var seriesImage: UIImage?
    
    //init with all atributes
    init(episodeID: Int, episodeTitle: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", smallArtworkImageURL: URL, episodeLength: Double = 0.0, numberOfRecommendations: Int = 0, tags: [Tag] = [], seriesTitle: String = "", seriesID: Int = 0, isBookmarked: Bool = false, isRecommended: Bool = false, seriesImageURL: URL) {
        
        self.seriesID = seriesID
        self.seriesImageURL = seriesImageURL
        super.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, episodeLength: episodeLength, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended)
    }
    
    //init without smallArtworkImageURL and seriesImageURL optionals
    init(episodeID: Int, episodeTitle: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", episodeLength: Double = 0.0, numberOfRecommendations: Int = 0, tags: [Tag] = [], seriesTitle: String = "", seriesID: Int = 0, isBookmarked: Bool = false, isRecommended: Bool = false) {
        
        self.seriesID = seriesID
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
        let seriesID = json["series_id"].int ?? 0
        let episodeLength = json["episode_length"].double ?? 0.0
        let tags = json["tags"].arrayValue.map({ (tag: JSON) in Tag(name: tag.stringValue) })
        
        let dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        
        if let smallArtworkURL = URL(string: json["small_image_url"].stringValue), let seriesImageURL =  URL(string: json["series_image_url"].stringValue) {
            self.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, episodeLength: episodeLength, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, seriesID: seriesID, isBookmarked: isBookmarked, isRecommended: isRecommended, seriesImageURL: seriesImageURL)
        } else {
            self.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, episodeLength: episodeLength, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, seriesID: seriesID, isBookmarked: isBookmarked, isRecommended: isRecommended)
        }
    }
}
