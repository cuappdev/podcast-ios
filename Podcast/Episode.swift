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
    var seriesTitle: String = ""
    var dateCreated: Date!
    var descriptionText: String!
    var smallArtworkImageURL: URL?
    var largeArtworkImageURL: URL?
    var smallArtworkImage: UIImage!
    var largeArtworkImage: UIImage!
    var mp3URL : URL?
    var time: Double = 0
    var tags : [String] = []
    var nRecommended : Int = 0
    var isBookmarked: Bool = false
    var isRecommended: Bool = false
    var isPlaying: Bool! = false
    

    init(id: Int, title: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", smallArtworkImage: UIImage = #imageLiteral(resourceName: "filler_image"), largeArtworkImage: UIImage = #imageLiteral(resourceName: "filler_image"), mp3URL : String = "") {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.descriptionText = descriptionText
        self.smallArtworkImage = smallArtworkImage
        self.largeArtworkImage = largeArtworkImage
        self.mp3URL = URL(string: mp3URL)
    }
}
