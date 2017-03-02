//
//  Episode.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class Episode: NSObject {
    
    var id: Int
    var title: String = ""
    var series: Series?
    var seriesTitle: String = ""
    var dateCreated: Date!
    var descriptionText: String!
    var smallArtworkImageURL: URL?
    var largeArtworkImageURL: URL?
    var smallArtworkImage: UIImage?
    var largeArtworkImage: UIImage?
    var mp3URL : URL?
    var duration: Double = 0
    var tags : [Tag] = []
    var numberOfRecommendations = 0
    var isBookmarked = false
    var isRecommended = false
    var isPlaying = false
    
    init(id: Int) {
        self.id = id 
    }
    
    //all atribute initializer
    init(id: Int, title: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", smallArtworkImageURL: URL, largeArtworkImageURL: URL, mp3URL : String = "", duration: Double = 0, seriesTitle: String = "", tags: [Tag] = [], numberOfRecommendations: Int = 0, isRecommended: Bool = false, isBookmarked: Bool = false, isPlaying:Bool = false) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.descriptionText = descriptionText
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        self.mp3URL = URL(string: mp3URL)
        self.isRecommended = isRecommended
        self.isBookmarked = isBookmarked
        self.isPlaying = isPlaying
        self.numberOfRecommendations = numberOfRecommendations
        self.seriesTitle = seriesTitle
        self.duration = duration
        self.tags = tags

        super.init()
    }
    
    //initializer without small/largeArtworkURL optionals
    init(id: Int, title: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", mp3URL : String = "", duration: Double = 0, seriesTitle: String = "", tags: [Tag] = [], numberOfRecommendations: Int = 0, isRecommended: Bool = false, isBookmarked: Bool = false, isPlaying:Bool = false) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.descriptionText = descriptionText
        self.mp3URL = URL(string: mp3URL)
        self.isRecommended = isRecommended
        self.isBookmarked = isBookmarked
        self.isPlaying = isPlaying
        self.numberOfRecommendations = numberOfRecommendations
        self.seriesTitle = seriesTitle
        self.duration = duration
        self.tags = tags
        
        super.init()
    }
    
    
     convenience init(json: JSON) {
        let id = json["id"].int ?? 0
        let title = json["title"].string ?? ""
        let dateString = json["date"].string ?? ""
        let descriptionText = json["description"].string ?? ""
        let mp3URL = json["mp3URL"].string ?? ""
        let isRecommended = json["is_recommended"].bool ?? false
        let isBookmarked = json["is_bookmarked"].bool ?? false
        let numberOfRecommendations = json["n_recommendations"].int ?? 0
        let seriesTitle = json["series_title"].string ?? ""
        let duration = json["duration"].double ?? 0.0
        let tags = json["tags"].arrayValue.map({ (tag: JSON) in Tag(name: tag.stringValue) }) 
        
        let dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        
        if let smallArtworkURL = URL(string: json["small_image_url"].stringValue), let largeArtworkURL = URL(string: json["large_image_url"].stringValue) {
            self.init(id: id, title: title, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, largeArtworkImageURL: largeArtworkURL, mp3URL: mp3URL, duration: duration, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked)
        } else {
            self.init(id: id, title: title, dateCreated: dateCreated, descriptionText: descriptionText, mp3URL: mp3URL, duration: duration, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked)
        }
     }
 
}
