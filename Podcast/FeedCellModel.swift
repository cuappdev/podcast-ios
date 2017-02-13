//
//  FeedCellModel.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit 

class FeedCellModel: NSObject {
    
    var episodeID: Int
    var title: String = ""
    var dateCreated: Date!
    var time: Double!
    var descriptionText: String!
    var smallArtworkImageURL: URL?
    var smallArtworkImage: UIImage!
    var nRecommended: Int
    var tags: [String]
    var userName: String = ""
    var userID: Int?
    var seriesID: Int?
    var seriesName: String!
    var contextDescription: String!
    var contextImages: [UIImage]!
    
    init(episodeID: Int, title: String = "", dateCreated: Date = Date(), descriptionText: String = "Not avaliable", smallArtworkImage: UIImage = #imageLiteral(resourceName: "filler_image"), time: Double = 0.0, nRecommended: Int = 0, tags: [String] = [], seriesName: String = "", contextDescription: String = "", contextImages: [UIImage] = []) {

        self.episodeID = episodeID
        self.title = title
        self.dateCreated = dateCreated
        self.descriptionText = descriptionText
        self.smallArtworkImage = smallArtworkImage
        self.tags = tags
        self.time = time
        self.nRecommended = nRecommended
        self.seriesName = seriesName
        self.contextDescription = contextDescription
        self.contextImages = contextImages
    }
}
