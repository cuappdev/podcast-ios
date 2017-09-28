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
    var title: String
    var largeArtworkImageURL: URL?
    var smallArtworkImageURL: URL?
    var isSubscribed: Bool
    
    override convenience init(){
        self.init(seriesId: "", userId: "", seriesTitle: "", smallArtworkImageURL: nil, largeArtworkImageURL: nil, isSubscribed: false)
    }
    
    //init with all atributes
    init(seriesId: String, userId: String, seriesTitle: String, smallArtworkImageURL: URL?, largeArtworkImageURL: URL?, isSubscribed: Bool) {
        self.seriesId = seriesId
        self.title = seriesTitle
        self.userId = userId
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        self.isSubscribed = isSubscribed
        super.init()
    }
    
    
    convenience init(json: JSON) {
        let userId = json["user_id"].stringValue
        let seriesId = json["series_id"].stringValue
        let seriesTitle = json["series_title"].stringValue
        let smallArtworkURL = URL(string: json["image_url_sm"].stringValue)
        let largeArtworkURL = URL(string: json["image_url_lg"].stringValue)
        
        self.init(seriesId: seriesId, userId: userId, seriesTitle: seriesTitle, smallArtworkImageURL: smallArtworkURL, largeArtworkImageURL: largeArtworkURL, isSubscribed: true)
      
    }
    
}
