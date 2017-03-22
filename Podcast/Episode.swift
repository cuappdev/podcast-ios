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
    var audioURL: URL?
    var duration: Double
    var tags: [Tag]
    var numberOfRecommendations: Int
    var isBookmarked: Bool
    var isRecommended: Bool
    
    //dummy data initializer - will remove in future when we have real data  
    override convenience init() {
        self.init(id: 0, title: "", dateCreated: Date(), descriptionText: "", smallArtworkImageURL:nil, series: nil, largeArtworkImageURL: nil, audioURL: nil, duration: 0.0, seriesTitle: "", tags: [], numberOfRecommendations: 0, isRecommended: false, isBookmarked: false)
    }
    
    //all attribute initializer
    init(id: Int, title: String, dateCreated: Date, descriptionText: String, smallArtworkImageURL: URL?, series: Series?, largeArtworkImageURL: URL?, audioURL: URL?, duration: Double, seriesTitle: String, tags: [Tag], numberOfRecommendations: Int, isRecommended: Bool, isBookmarked: Bool) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.descriptionText = descriptionText
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        if audioURL == nil { //TAKE THIS OUT LATER ONLY FOR PLAYER STATIC DATA
            self.audioURL = URL(string: "https://play.podtrac.com/npr-510298/npr.mc.tritondigital.com/NPR_510298/media/anon.npr-mp3/npr/ted/2017/02/20170215_ted_tedpod.mp3?orgId=1&d=3241&p=510298&story=515438384&t=podcast&e=515438384&ft=pod&f=510298")
        } else {
            self.audioURL = audioURL
        }
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
        let audioURL = URL(string: json["audioURL"].stringValue)
        let dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        let smallArtworkURL = URL(string: json["small_image_url"].stringValue)
        let largeArtworkURL = URL(string: json["large_image_url"].stringValue)
        
        self.init(id: id, title: title, dateCreated: dateCreated, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, series: nil, largeArtworkImageURL: largeArtworkURL, audioURL: audioURL, duration: duration, seriesTitle: seriesTitle, tags: tags, numberOfRecommendations: numberOfRecommendations, isRecommended: isRecommended, isBookmarked: isBookmarked)
     }
 
}
