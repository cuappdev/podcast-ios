//
//  FeedParser.swift
//  Recast
//
//  Created by Drew Dunne on 9/15/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation
import FeedKit

protocol PartialPodcast {
    // PartialPodcast contains all model info we definitely want
    // and will be there because it will come from the iTunes
    // search API
    var collectionId: Int! { get }
    var feedUrl: URL! { get }
    var artistName: String! { get }
    var collectionName: String! { get }
    var artworkUrl30: URL? { get }
    var artworkUrl60: URL? { get }
    var artworkUrl100: URL? { get }
    var collectionExplicitness: String! { get }
    var primaryGenreName: String! { get }
    var artworkUrl600: URL? { get }
    var genreIds: [String]! { get }
    var genres: [String]! { get }
}

struct SearchResults: Codable {
    let resultCount: Int
    let results: [SearchResult]
}

struct SearchResult : Codable, PartialPodcast {
    let wrapperType: String
    let kind: String
    let collectionId: Int!
    let trackId: Int
    let artistName: String!
    let collectionName: String!
    let trackName: String
    let collectionCensoredName: String
    let trackCensoredName: String
    let collectionViewUrl: URL
    let feedUrl: URL!
    let trackViewUrl: URL
    let artworkUrl30: URL?
    let artworkUrl60: URL?
    let artworkUrl100: URL?
    let collectionPrice: Double
    let trackPrice: Double
    let trackRentalPrice: Double
    let collectionHdPrice: Double
    let trackHdPrice: Double
    let trackHdRentalPrice: Double
    let releaseDate: Date
    let collectionExplicitness: String!
    let trackExplicitness: String
    let trackCount: Int
    let country: String
    let currency: String
    let primaryGenreName: String!
    let contentAdvisoryRating: String
    let artworkUrl600: URL?
    let genreIds: [String]!
    let genres: [String]!
}

