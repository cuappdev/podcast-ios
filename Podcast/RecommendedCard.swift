//
//  RecommendedCard.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

//when users followers recommend episodes
class RecommendedCard: EpisodeCard {
    
    var namesOfRecommenders: [String] = []
    var imagesOfRecommenders: [UIImage] = []
    var numberOfRecommenders = 0 //number of people in followers who have recommended this episode
    
    init(episodeID: Int, episodeTitle: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", smallArtworkImageURL: URL , time: Double = 0.0, numberOfRecommendations: Int = 0, tags: [Tag] = [], seriesTitle: String = "", seriesID: Int = 0, isBookmarked: Bool = false, isRecommended: Bool = false, namesOfRecommenders: [String] = [], imagesOfRecommenders: [UIImage] = [], numberOfRecommenders: Int = 0) {
        
        self.namesOfRecommenders = namesOfRecommenders
        self.imagesOfRecommenders = imagesOfRecommenders
        self.numberOfRecommenders = numberOfRecommenders
        
        super.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, episodeLength: time, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended)
    }
    
    
    
}
