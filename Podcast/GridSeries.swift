//
//  SubscriptionSeries.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/31/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class GridSeries: NSObject {
    
    var seriesId: String
    var userId: String
    var seriesTitle: String
    var largeArtworkImageURL: URL?
    var smallArtworkImageURL: URL?
    var isSubscribed: Bool
    var lastUpdated: Date
    
    override convenience init(){
        self.init(seriesId: "", userId: "", seriesTitle: "", smallArtworkImageURL: nil, largeArtworkImageURL: nil, isSubscribed: false, lastUpdated: Date())
    }
    
    //init with all atributes
    init(seriesId: String, userId: String, seriesTitle: String, smallArtworkImageURL: URL?, largeArtworkImageURL: URL?, isSubscribed: Bool, lastUpdated: Date) {
        self.seriesId = seriesId
        self.seriesTitle = seriesTitle
        self.userId = userId
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        self.isSubscribed = isSubscribed
        self.lastUpdated = lastUpdated
        super.init()
    }
    
    
    convenience init(json: JSON) {
        let userId = json["userId"].stringValue
        let seriesId = json["seriesId"].stringValue
        let seriesTitle = json["seriesTitle"].stringValue
        let smallArtworkURL = URL(string: json["imageUrlSm"].stringValue)
        let largeArtworkURL = URL(string: json["imageUrlLg"].stringValue)
        let lastUpdatedString = json["lastUpdated"].stringValue
        let lastUpdated = DateFormatter.parsingDateFormatter.date(from: lastUpdatedString) ?? Date()
        
        self.init(seriesId: seriesId, userId: userId, seriesTitle: seriesTitle, smallArtworkImageURL: smallArtworkURL, largeArtworkImageURL: largeArtworkURL, isSubscribed: true, lastUpdated: lastUpdated)
      
    }
    
}
