//
//  TagCard.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/22/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

//suggestion card based off tags user has liked
class TagCard: EpisodeCard {
    
    var tag: Tag
    
    //init with all atributes
    init(episodeID: Int, episodeTitle: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, episodeLength: Double, audioURL: URL?, numberOfRecommendations: Int, tags: [Tag], seriesTitle: String, isBookmarked: Bool, isRecommended: Bool, tag: Tag) {
        
        self.tag = tag
        super.init(episodeID: episodeID, episodeTitle: episodeTitle, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkImageURL, episodeLength: episodeLength, audioURL: audioURL, numberOfRecommendations: numberOfRecommendations, tags: tags, seriesTitle: seriesTitle, isBookmarked: isBookmarked, isRecommended: isRecommended)
    }
    
    override init(json: JSON) {
        self.tag = Tag(name: json["tag"].stringValue)
        super.init(json: json)
    }
}
