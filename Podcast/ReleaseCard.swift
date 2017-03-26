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
    
    var seriesID: Int
    var seriesImageURL: URL?
    
    //init with all atributes
    init(episodeID: Int, episodeTitle: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, episodeLength: String, audioURL: URL?, numberOfRecommendations: Int, tags: [Tag], seriesTitle: String, seriesID: Int, isBookmarked: Bool, isRecommended: Bool, seriesImageURL: URL?) {
        
        self.seriesID = seriesID
        self.seriesImageURL = seriesImageURL
        super.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, episodeLength: episodeLength, audioURL: audioURL, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended)
    }
    

    override init(json: JSON) {
        self.seriesID = json["seriesId"].intValue
        self.seriesImageURL =  URL(string: json["imageUrl"].stringValue)
        super.init(json: json)
    }
}
