//
//  SearchEpisode.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

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
    
    init(id: Int, title: String = "", seriesTitle: String = "", dateCreated: Date = Date(), smallArtworkImageURL: URL) {
        self.id = id
        self.title = title
        self.seriesTitle = seriesTitle
        self.dateCreated = dateCreated
        self.smallArtworkImageURL = smallArtworkImageURL
        super.init()
    }
    
    /*
     convenience init(_json: JSON) {
     //TODO: make these consistent with backend
     
     //self.init( ... )
     }
     */
}
