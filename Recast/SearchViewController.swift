//
//  SearchViewController.swift
//  Recast
//
//  Created by Drew Dunne on 9/15/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit
import Draft
import FeedKit

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

struct SearchPodcasts: DecodableDraft {    
    
    typealias ResponseType = SearchResults
    
    let host = "itunes.apple.com"
    let route = "/search"
    let parameters: HTTPParameters
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? {
        return .formatted(DateFormatter.iso8601Full)
    }

}

struct SearchResults: Codable {
    
    let resultCount: Int
    let results: [SearchResult]
    
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
}

class SearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SearchPodcasts(parameters: ["term": "DORK", "media": "podcast", "limit": 1]).run()
            .success { (response: SearchResults) in
                print(response)
                if response.resultCount > 0 {
                    let parser = FeedParser(URL: response.results.first!.feedUrl)
                    let result = parser.parse()
                    if let feed = result.rssFeed, result.isSuccess {
                        print(feed.title!)
                        print(feed.description!)
                        print(feed.link!)
                        print(feed.items?.first?.enclosure?.attributes?.url ?? "")
//                        print(feed.image!)
                        print(feed.items?.first?.iTunes?.iTunesDuration)
                    }
                }
                // TODO: possibly use for regular parser
//                guard response.resultCount > 0,
//                    let parser = XMLParser(contentsOf: response.results.first!.feedUrl)
//                    else { return }
//                let episodeFeedParser = FeedParser()
//                parser.delegate = episodeFeedParser
//                if parser.parse() {
//                    // parsing successful
//                    let podcast = episodeFeedParser.result
//                    print(podcast ?? "")
//                }
            }
            .failure { (error: Error) in
                print(error)
            }
    }
}
