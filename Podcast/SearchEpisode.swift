//
//  SearchEpisode.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchEpisode: NSObject {
    
    var id: Int
    var title: String
    var seriesTitle: String
    var dateCreated: Date
    var smallArtworkImageURL: URL?
    
    
    //init with all atributes
    init(id: Int, title: String, seriesTitle: String, dateCreated: Date, smallArtworkImageURL: URL?) {
        self.id = id
        self.title = title
        self.seriesTitle = seriesTitle
        self.dateCreated = dateCreated
        self.smallArtworkImageURL = smallArtworkImageURL
        super.init()
    }
    
    convenience init(json: JSON) {
        let id = json["id"].intValue
        let title = json["title"].stringValue
        let dateString = json["pub_date"].stringValue
        let seriesTitle = json["series_title"].stringValue
        
        let dateCreated = DateFormatter.restAPIDateFormatter.date(from: dateString) ?? Date()
        let smallArtworkURL = URL(string: json["image_url_sm"].stringValue)
        self.init(id: id, title: title, seriesTitle: seriesTitle, dateCreated: dateCreated, smallArtworkImageURL: smallArtworkURL)
    }
}
