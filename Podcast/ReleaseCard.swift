//
//  ReleaseCard.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

//when a series releases an episode 
class ReleaseCard: EpisodeCard {
    
    var seriesID = 0
    var seriesImageURL: URL?
    var seriesImage: UIImage?
    
    init(episodeID: Int, episodeTitle: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", smallArtworkImageURL: URL, time: Double = 0.0, numberOfRecommendations: Int = 0, tags: [Tag] = [], seriesTitle: String = "", seriesID: Int = 0, isBookmarked: Bool = false, isRecommended: Bool = false, seriesImageURL: URL) {
        
        self.seriesID = seriesID
        self.seriesImageURL = seriesImageURL
        super.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, episodeLength: time, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended)
    }
    
    
    
}
