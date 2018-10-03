//
//  DummyPodcastSeries.swift
//  Recast
//
//  Created by Jaewon Sim on 9/29/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation
import UIKit

struct DummyPodcastSeries {
    let image: UIImage
    let podcastTitle: String
    let episodeTitle: String
    let date: String
    let duration: Int
    let timeLeft: Int
    let isNew: Bool

    init(
        image: UIImage,
        podcastTitle: String,
        episodeTitle: String,
        date: String,
        duration: Int,
        timeLeft: Int,
        isNew: Bool) {
        self.image = image
        self.podcastTitle = podcastTitle
        self.episodeTitle = episodeTitle
        self.date = date
        self.duration = duration
        self.timeLeft = timeLeft
        self.isNew = isNew
    }

    init(image: UIImage, podcastTitle: String, episodeTitle: String, date: String, duration: Int, timeLeft: Int) {
        self.image = image
        self.podcastTitle = podcastTitle
        self.episodeTitle = episodeTitle
        self.date = date
        self.duration = duration
        self.timeLeft = timeLeft
        self.isNew = false
    }
}
