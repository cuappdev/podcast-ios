//
//  Episode.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class Episode: NSObject {
    
    var id: Int
    var title: String = ""
    var series: Series?
    var dateCreated: Date!
    var descriptionText: String!
    var smallArtworkImageURL: URL?
    var largeArtworkImageURL: URL?
    var smallArtworkImage: UIImage!
    var largeArtworkImage: UIImage!
    
    
    init(id: Int, title: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", smallArtworkImage: UIImage = #imageLiteral(resourceName: "fillerImage"), largeArtworkImage: UIImage = #imageLiteral(resourceName: "fillerImage")) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.descriptionText = descriptionText
        self.smallArtworkImage = smallArtworkImage
        self.largeArtworkImage = largeArtworkImage
    }
}
