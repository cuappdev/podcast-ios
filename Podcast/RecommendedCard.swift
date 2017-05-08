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
    init(episodeID: String, episodeTitle: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, episodeLength: String, audioURL: URL?, numberOfRecommendations: Int, tags: [Tag], seriesTitle: String, seriesID: String, isBookmarked: Bool, isRecommended: Bool, namesOfRecommenders: [String], imageURLsOfRecommenders: [URL], numberOfRecommenders: Int, updatedAt: Date) {
        
        self.namesOfRecommenders = namesOfRecommenders
        self.imageURLsOfRecommenders = imageURLsOfRecommenders
        self.numberOfRecommenders = numberOfRecommenders
        
        super.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, episodeLength: episodeLength, audioURL: audioURL,numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, seriesID: seriesID, isBookmarked: isBookmarked, isRecommended: isRecommended, updatedAt: updatedAt)
    }
    
    
    override init(json: JSON) {
        //Flag will change once we get an array of recommenders
        let firstName = json["recommender"]["firstName"].stringValue
        let lastName = json["recommender"]["lastName"].stringValue
        let fullName = firstName + " " + lastName
        let imageUrl = URL(string: json["recommender"]["imageUrl"].stringValue)
        self.imageURLsOfRecommenders = [imageUrl]
        self.namesOfRecommenders = [fullName]
        self.numberOfRecommenders = 1
        super.init(json: json["episode"])
        let dateString = json["updatedAt"].stringValue
        self.updatedAt = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
    }
}
