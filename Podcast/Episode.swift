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
    var title: String
    var series: Series?
    var seriesTitle: String
    var dateCreated: Date
    var descriptionText: String
    var smallArtworkImageURL: URL?
    var largeArtworkImageURL: URL?
    var mp3URL: URL?
    var duration: Double
    var tags: [Tag]
    var numberOfRecommendations: Int
    var isBookmarked: Bool
    var isRecommended: Bool
    
    //dummy data initializer - will remove in future when we have real data  
    override convenience init() {
        self.init(id: 0, title: "", dateCreated: Date(), descriptionText: "", smallArtworkImageURL:nil, series: nil, largeArtworkImageURL: nil, mp3URL: nil, duration: 0.0, seriesTitle: "", tags: [], numberOfRecommendations: 0, isRecommended: false, isBookmarked: false)
    }
    
    //all attribute initializer
    init(id: Int, title: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, series: Series?, largeArtworkImageURL: URL?, mp3URL: URL?, duration: Double, seriesTitle: String, tags: [Tag], numberOfRecommendations: Int, isRecommended: Bool, isBookmarked: Bool) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.descriptionText = descriptionText
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        self.mp3URL = mp3URL
        self.series = series
        self.isRecommended = isRecommended
        self.isBookmarked = isBookmarked
        self.numberOfRecommendations = numberOfRecommendations
        self.seriesTitle = seriesTitle
        self.duration = duration
        self.tags = tags

        super.init()
    }
    
     convenience init(json: JSON) {
        let id = json["id"].intValue
        let title = json["title"].stringValue
        let dateString = json["date"].stringValue
        let descriptionText = json["description"].stringValue
        let isRecommended = json["is_recommended"].boolValue
        let isBookmarked = json["is_bookmarked"].boolValue
        let numberOfRecommendations = json["n_recommendations"].intValue
        let seriesTitle = json["series_title"].stringValue
        let duration = json["duration"].doubleValue
        let tags = json["tags"].arrayValue.map({ (tag: JSON) in Tag(name: tag.stringValue) })
        let mp3URL = URL(string: json["mp3URL"].stringValue)
        let dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        let smallArtworkURL = URL(string: json["small_image_url"].stringValue)
        let largeArtworkURL = URL(string: json["large_image_url"].stringValue)
        
        self.init(id: id, title: title, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, series: nil, largeArtworkImageURL: largeArtworkURL, mp3URL: mp3URL, duration: duration, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked)
     }
 
}
