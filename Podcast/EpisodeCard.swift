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
    
    var episode: Episode
    var updatedAt: Date
    
    //initializer with all attributes
    init(episodeID: String, episodeTitle: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, episodeLength: String, audioURL: URL?, numberOfRecommendations: Int, tags: [Tag], seriesTitle: String, seriesID: String, isBookmarked: Bool, isRecommended: Bool, updatedAt: Date) {
        
        let episode = Episode(id: episodeID, title: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, seriesID: seriesID, largeArtworkImageURL: nil, audioURL: audioURL, duration: episodeLength, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked)
        self.episode = episode
        self.updatedAt = updatedAt
        super.init()
    }
    
    
   init(json: JSON) {
        let episodeID = json["id"].stringValue
        let seriesID = json["series_id"].stringValue
        let episodeTitle = json["title"].stringValue
        let dateString = json["pub_date"].stringValue
        let descriptionText = json["summary"].stringValue
        let isRecommended = json["is_recommended"].boolValue
        let isBookmarked = json["is_bookmarked"].boolValue
        let numberOfRecommendations = json["number_recommenders"].intValue
        let seriesTitle = json["series_title"].stringValue
        let episodeLength = json["duration"].stringValue
        let tags = json["tags"].arrayValue.map({ (tag: JSON) in Tag(name: tag.stringValue)})
        let dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        let smallArtworkImageURL = URL(string: json["image_url_sm"].stringValue)
        let largeArtworkImageURL = URL(string: json["image_url_lg"].stringValue)
        let audioURL = URL(string: json["audio_url"].stringValue)
        let episode = Episode(id: episodeID, title: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, seriesID: seriesID, largeArtworkImageURL: largeArtworkImageURL, audioURL: audioURL, duration: episodeLength, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked)
        self.episode = episode
        let updatedString = json["updated_at"].stringValue
        self.updatedAt = DateFormatter.parsingDateFormatter.date(from: updatedString) ?? Date()
    }
    
    override var hash: Int {
        return episode.id.hashValue
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? EpisodeCard {
            return object.episode.id == self.episode.id
        } else {
            return false
        }
    }
}
