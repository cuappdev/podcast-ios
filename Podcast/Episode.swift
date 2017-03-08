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
            self.audioURL = URL(string: "http://cf-media.sndcdn.com/stEcTqU4a27v.128.mp3?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiKjovL2NmLW1lZGlhLnNuZGNkbi5jb20vc3RFY1RxVTRhMjd2LjEyOC5tcDMiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE0ODg3NDQzMzJ9fX1dfQ__&Signature=SgM4MzYFr9CDFnX-4f-q6uWdawoVVtEqTCRf5AXPAlF83LXjXNzPVEv9PW2CVFaq-2qFZdabgXHv8Tjsz924k1mnfnu3qwpZjmez4MxnzajH47giPPfmd~F9Kv7WEP4vSLfUukrT4WMslxFFwNH~C7Hpwyrs8aUFU8naTEOH2LLIa6mE4IDa7eErsGkYZ5n-Zenata-kiTQHWYRVeJAzLRm69GX313YhUJQGGeYIE9TW2iYrteQkTmTr5JpJ2pwrbjDUfc1r3rkekpMLBuLBtt6qrB~IuL8nvm5kkDJENXABTBsoT7wHDxaAcWsnlAbL06Z5SIBWAst4rut5jZI0Cg__&Key-Pair-Id=APKAJAGZ7VMH2PFPW6UQ")
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
