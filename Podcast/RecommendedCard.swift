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
    
    var namesOfRecommenders: [String]
    var imageURLsOfRecommenders: [URL?]
    var numberOfRecommenders: Int //number of people in followers who have recommended this episode
    
    //initializer all atributes
    init(episodeID: Int, episodeTitle: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, episodeLength: Double, audioURL: URL?, numberOfRecommendations: Int, tags: [Tag], seriesTitle: String, seriesID: Int, isBookmarked: Bool, isRecommended: Bool, namesOfRecommenders: [String], imageURLsOfRecommenders: [URL], numberOfRecommenders: Int) {
        
        self.namesOfRecommenders = namesOfRecommenders
        self.imageURLsOfRecommenders = imageURLsOfRecommenders
        self.numberOfRecommenders = numberOfRecommenders
        
        super.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, episodeLength: episodeLength, audioURL: audioURL,numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended)
    }
    
    
    override init(json: JSON) {
        self.namesOfRecommenders = json["recommender_names"].arrayValue.map({ (name: JSON) in name.stringValue })
        self.imageURLsOfRecommenders = json["recommender_image_urls"].arrayValue.map({ (url: JSON) in URL(string: url.stringValue)})
        self.numberOfRecommenders = json["n_recommenders"].intValue
        
        super.init(json: json)
    }
}
