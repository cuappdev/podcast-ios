//
//  Comment.swift
//  Podcast
//
//  Created by Mark Bryan on 4/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class Comment {
    var episodeId: String
    var creator: String
    var text: String
    var creationDate: String
    var time: String
    
    init(episodeId: String, creator: String, text: String, creationDate: String, time: String) {
        self.episodeId = episodeId
        self.creator = creator
        self.text = text
        self.creationDate = creationDate
        self.time = time
    }
}
