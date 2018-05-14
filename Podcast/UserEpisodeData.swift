//
//  UserEpisodeData.swift
//  Podcast
//
//  Created by Natasha Armbrust on 5/9/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

// essentially tuples to store our hashmap of blurbs (swift tuples aren't hashable)
struct EpisodeToUser: Hashable {
    let episodeID: String
    let userID: String

    var hashValue: Int {
        return "\(episodeID), \(userID)".hashValue
    }

    static func == (lhs: EpisodeToUser, rhs: EpisodeToUser) -> Bool {
        return lhs.episodeID == rhs.episodeID && lhs.userID == rhs.userID
    }
}

// all info about users to episodes
class UserEpisodeData: NSObject {

    static var shared: UserEpisodeData = UserEpisodeData()

    var blurbs: [EpisodeToUser: String]

    private override init() {
        blurbs = [:]
    }

    func update(with blurb: String?, for episodeToUser: EpisodeToUser) {
        if let includedBlurb = blurb {
            blurbs[episodeToUser] = includedBlurb
        } else {
            _ = removeBlurb(for: episodeToUser)
        }
    }

    func getBlurb(for episodeToUser: EpisodeToUser) -> String? {
        return blurbs[episodeToUser]
    }

    // return true if removal was successful
    func removeBlurb(for episodeToUser: EpisodeToUser) -> Bool {
        return blurbs.removeValue(forKey: episodeToUser) == nil
    }
}
