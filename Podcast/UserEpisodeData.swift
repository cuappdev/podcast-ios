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

    private var blurbs: [String: String] // key: episodeID + userID, value: blurbs

    private override init() {
        blurbs = [:]
    }

    func key(for user: User, and episode: Episode) -> String {
        return episode.id + user.id
    }

    func update(with blurb: String?, for user: User, and episode: Episode) {
        if let includedBlurb = blurb {
            blurbs[key(for: user, and: episode)] = includedBlurb
        } else {
            _ = removeBlurb(for: user, and: episode)
        }
    }

    func getBlurb(for user: User, and episode: Episode) -> String? {
        return blurbs[key(for: user, and: episode)]
    }

    // return true if removal was successful
    func removeBlurb(for user: User, and episode: Episode) -> Bool {
        return blurbs.removeValue(forKey: key(for: user, and: episode)) == nil
    }

    /// utility functions for current user
    func getBlurbForCurrentUser(and episode: Episode) -> String? {
        return getBlurb(for: System.currentUser!, and: episode)
    }

    func updateBlurbForCurrentUser(with blurb: String?, and episode: Episode) {
        update(with: blurb, for: System.currentUser!, and: episode)
    }
}
