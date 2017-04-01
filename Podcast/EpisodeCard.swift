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
    
    //initializer with all attributes
    init(episodeID: String, episodeTitle: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, episodeLength: String, audioURL: URL?, numberOfRecommendations: Int, tags: [Tag], seriesTitle: String, seriesID: String, isBookmarked: Bool, isRecommended: Bool) {
        
        let episode = Episode(id: episodeID, title: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, seriesID: seriesID, largeArtworkImageURL: nil, audioURL: audioURL, duration: episodeLength, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked)
        self.episode = episode
        super.init()
    }
    
    
   init(json: JSON) {
        let episodeID = json["id"].stringValue
        let seriesID = json["seriesId"].stringValue
        let episodeTitle = json["episodeTitle"].stringValue
        let dateString = json["date"].stringValue
        let descriptionText = json["summary"].stringValue
        let isRecommended = json["isRecommended"].boolValue
        let isBookmarked = json["isBookmarked"].boolValue
        let numberOfRecommendations = json["nRecommendations"].intValue
        let seriesTitle = json["seriesTitle"].stringValue
        let episodeLength = json["duration"].stringValue
        let tags = json["tags"].arrayValue.map({ (tag: JSON) in Tag(name: tag.stringValue)})
        let dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        let smallArtworkImageURL = URL(string: json["imageUrlSm"].stringValue)
        let audioURL = URL(string: json["audioUrl"].stringValue)
        let episode = Episode(id: episodeID, title: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, seriesID: seriesID, largeArtworkImageURL: nil, audioURL: audioURL, duration: episodeLength, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked)
        self.episode = episode
    }
}
