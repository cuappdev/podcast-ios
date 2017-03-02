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
    var title: String = ""
    var seriesTitle: String = ""
    var dateCreated: Date = Date()
    var smallArtworkImageURL: URL?
    var smallArtworkImage: UIImage?
    
    
    init(id: Int) {
        self.id = id
    }
    
    //init with all atributes
    init(id: Int, title: String = "", seriesTitle: String = "", dateCreated: Date = Date(), smallArtworkImageURL: URL) {
        self.id = id
        self.title = title
        self.seriesTitle = seriesTitle
        self.dateCreated = dateCreated
        self.smallArtworkImageURL = smallArtworkImageURL
        super.init()
    }
    
    //init without smallArtworkImageURL
    init(id: Int, title: String = "", seriesTitle: String = "", dateCreated: Date = Date()) {
        self.id = id
        self.title = title
        self.seriesTitle = seriesTitle
        self.dateCreated = dateCreated
        super.init()
    }
    
    convenience init(json: JSON) {
        let id = json["id"].int ?? 0
        let title = json["title"].string ?? ""
        let dateString = json["date"].string ?? ""
        let seriesTitle = json["series_title"].string ?? ""
        
        let dateCreated = DateFormatter.parsingDateFormatter.date(from: dateString) ?? Date()
        
        if let smallArtworkURL = URL(string: json["small_image_url"].stringValue) {
            self.init(id: id, title: title, seriesTitle: seriesTitle, dateCreated: dateCreated, smallArtworkImageURL: smallArtworkURL)
        } else {
            self.init(id: id, title: title, seriesTitle: seriesTitle, dateCreated: dateCreated)
        }
    }
}
