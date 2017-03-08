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
    init(episodeID: Int, episodeTitle: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, episodeLength: Double, audioURL: URL?, numberOfRecommendations: Int, tags: [Tag], seriesTitle: String, isBookmarked: Bool, isRecommended: Bool) {
        
        let episode = Episode(id: episodeID, title: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, series: nil, largeArtworkImageURL: nil, audioURL: audioURL, duration: episodeLength, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked)
        self.episode = episode
        super.init()
    }
    
    
   init(json: JSON) {
        let episodeID = json["episode_id"].intValue
        let episodeTitle = json["episode_title"].stringValue
        let dateString = json["date"].stringValue
        let descriptionText = json["description"].stringValue
        let isRecommended = json["is_recommended"].boolValue
        let isBookmarked = json["is_bookmarked"].boolValue
        let numberOfRecommendations = json["n_recommendations"].intValue
        let seriesTitle = json["series_title"].stringValue
        let episodeLength = json["episode_length"].doubleValue
        let tags = json["tags"].arrayValue.map({ (tag: JSON) in Tag(name: tag.stringValue)})
        let dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        let smallArtworkImageURL = URL(string: json["small_image_url"].stringValue)
        let audioURL = URL(string: json["audio_url"].stringValue)
        let episode = Episode(id: episodeID, title: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, series: nil, largeArtworkImageURL: nil, audioURL: audioURL, duration: episodeLength, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked)
        self.episode = episode
    }
}
