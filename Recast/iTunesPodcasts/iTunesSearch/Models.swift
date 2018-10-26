//
//  FeedParser.swift
//  Recast
//
//  Created by Drew Dunne on 9/15/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation
import Draft

@objc protocol PartialPodcast {
    // PartialPodcast contains all model info we definitely want
    // and will be there because it will come from the iTunes
    // search API
    var collectionId: NSNumber! { get }
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

class SearchResults {
    let resultCount: Int!
    let results: [SearchResult]!

    init(resultCount: Int, results: [SearchResult]) {
        self.resultCount = resultCount
        self.results = results
    }
}

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
}

class SearchResult: PartialPodcast {
    var wrapperType: String!
    var kind: String!
    var collectionId: NSNumber!
    var trackId: Int?
    let artistName: String!
    let collectionName: String!
    let trackName: String!
    let collectionCensoredName: String!
    let trackCensoredName: String!
    let collectionViewUrl: URL!
    let feedUrl: URL!
    let trackViewUrl: URL!
    let artworkUrl30: URL?
    let artworkUrl60: URL?
    let artworkUrl100: URL?
    let collectionPrice: Double!
    let trackPrice: Double!
    let trackRentalPrice: Double!
    let collectionHdPrice: Double!
    let trackHdPrice: Double!
    let trackHdRentalPrice: Double!
    let releaseDate: Date!
    let collectionExplicitness: String!
    let trackExplicitness: String!
    let trackCount: Int!
    let country: String!
    let currency: String!
    let primaryGenreName: String!
    let contentAdvisoryRating: String?
    let artworkUrl600: URL?
    let genreIds: [String]!
    let genres: [String]!

    init(json: JSON) {
        wrapperType = json["wrapperType"].string!
        kind = json["kind"].string!
        collectionId = NSNumber(value: json["collectionId"].int!)
        trackId = json["collectionId"].int
        artistName = json["artistName"].string!
        collectionName = json["collectionName"].string!
        trackName = json["trackName"].string!
        collectionCensoredName = json["collectionCensoredName"].string!
        trackCensoredName = json["trackCensoredName"].string!
        collectionViewUrl = URL(string: json["collectionViewUrl"].string!)!
        feedUrl = URL(string: json["feedUrl"].string!)!
        trackViewUrl = URL(string: json["trackViewUrl"].string!)!
        artworkUrl30 = URL(string: json["artworkUrl30"].string ?? "")
        artworkUrl60 = URL(string: json["artworkUrl60"].string ?? "")
        artworkUrl100 = URL(string: json["artworkUrl100"].string ?? "")
        artworkUrl600 = URL(string: json["artworkUrl600"].string ?? "")
        collectionPrice = json["collectionPrice"].double!
        trackPrice = json["trackPrice"].double!
        trackRentalPrice = json["trackRentalPrice"].double!
        collectionHdPrice = json["collectionHdPrice"].double!
        trackHdPrice = json["trackHdPrice"].double!
        trackHdRentalPrice = json["trackHdRentalPrice"].double!
        let df = ISO8601DateFormatter()
        releaseDate = df.date(from: json["releaseDate"].string!)!
        collectionExplicitness = json["collectionExplicitness"].string!
        trackExplicitness = json["trackExplicitness"].string!
        trackCount = json["trackCount"].int!
        country = json["country"].string!
        currency = json["currency"].string!
        primaryGenreName = json["primaryGenreName"].string!
        contentAdvisoryRating = json["contentAdvisoryRating"].string
        genreIds = (json["genreIds"].array ?? []).map{ id in id.string! }
        genres = (json["genres"].array ?? []).map{ id in id.string! }
    }
}
