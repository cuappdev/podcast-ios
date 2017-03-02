//
//  RecommendedCard.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

//when users followers recommend episodes
class RecommendedCard: EpisodeCard {
    
    var namesOfRecommenders: [String] = []
    var imageURLsOfRecommenders: [URL] = []
    var imagesOfRecommenders: [UIImage] = []
    var numberOfRecommenders = 0 //number of people in followers who have recommended this episode
    
    //initializer all atributes
    init(episodeID: Int, episodeTitle: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", smallArtworkImageURL: URL, episodeLength: Double = 0.0, numberOfRecommendations: Int = 0, tags: [Tag] = [], seriesTitle: String = "", seriesID: Int = 0, isBookmarked: Bool = false, isRecommended: Bool = false, namesOfRecommenders: [String] = [], imageURLsOfRecommenders: [URL] = [], numberOfRecommenders: Int = 0) {
        
        self.namesOfRecommenders = namesOfRecommenders
        self.imageURLsOfRecommenders = imageURLsOfRecommenders
        self.numberOfRecommenders = numberOfRecommenders
        
        super.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, episodeLength: episodeLength, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended)
    }
    
    //initializer without smallArtworkImageURL options
    init(episodeID: Int, episodeTitle: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", episodeLength: Double = 0.0, numberOfRecommendations: Int = 0, tags: [Tag] = [], seriesTitle: String = "", seriesID: Int = 0, isBookmarked: Bool = false, isRecommended: Bool = false, namesOfRecommenders: [String] = [], imageURLsOfRecommenders: [URL] = [], numberOfRecommenders: Int = 0) {
        
        self.namesOfRecommenders = namesOfRecommenders
        self.imageURLsOfRecommenders = imageURLsOfRecommenders
        self.numberOfRecommenders = numberOfRecommenders
        
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
        let namesOfRecommenders = json["recommender_names"].arrayValue.map({ (name: JSON) in name.stringValue })
        let imageURLsOfRecommenders = json["recommender_image_urls"].arrayValue.map({ (url: JSON) in URL(string: url.stringValue)!})
        let numberOfRecommenders = json["n_recommenders"].int ?? 0
        let dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        
        self.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, episodeLength: episodeLength, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended, namesOfRecommenders: namesOfRecommenders, imageURLsOfRecommenders: imageURLsOfRecommenders, numberOfRecommenders: numberOfRecommenders)
    }
    
    
}
