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

final class Podcast: NSObject, PartialPodcast {
    
    // MARK: iTunes Search fields
    
    var collectionId: Int!
    var feedUrl: URL!
    var artistName: String!
    // collectionName should match the title property
    var collectionName: String!
    var artworkUrl30: URL?
    var artworkUrl60: URL?
    var artworkUrl100: URL?
    var collectionExplicitness: String!
    var primaryGenreName: String!
    var artworkUrl600: URL?
    var genreIds: [String]!
    var genres: [String]!
    
    // MARK: RSS feed information
    
    // title, link, channelDescription tags are required by RSS
    var title: String!
    var link: String!
    // RSS: description, don't want to override NSObject's description property
    var channelDescription: String!
    
    // These are optional RSS tags
    var copyright: String?
    var language: String?
    var pubDate: String?
    var lastBuildDate: String?
    var image: URL?
    
    // These are iTunes specific optional RSS tags
    var itunesType: String?
    var itunesSummary: String?
    var itunesSubtitle: String?
    var itunesAuthor: String?
    // Blocks channel from iTunes
    var itunesBlock: Bool?
    var itunesCategories: [String]?
    // itunesComplete: complete if no new episodes will be released
    var itunesComplete: Bool?
    var itunesExplicit: String?
    // itunesNewFeedUrl: For changing feed location
    var itunesNewFeedUrl: URL?
    var itunesOwnerName: String?
    var itunesOwnerEmail: String?
    // itunesImage is the large image Apple uses to make the
    // above artworkUrls
    var itunesImage: String?
    var itunesKeywords: String?
    
    var items: [Episode] = []
    
    init(partial: PartialPodcast) {
        super.init()
        // TODO: copy info over
        // Question: is it possible to cast into this?
    }
}

final class Episode: NSObject {
    
    // MARK: RSS feed information
    
    var title: String!
    var link: String!
    // itemDescription is RSS description tag
    var itemDescription: String!
    var author: String!
    var categories: [String]!
    // URL for a comments page
    var comments: URL!
    var enclosure: Enclosure!
    // Global unique identifier, often the url
    var guid: String!
    var pubDate: Date!
    // url of RSS feed item comes from
    var source: URL!
    
    // MARK: iTunes specific tags
    
    var itunesAuthor: String?
    // Blocks channel from iTunes
    var itunesBlock: Bool?
    
    /**
     itunesDuration: The episode duration in hours, minutes, and seconds.
     
     Specify one of the following formats for the <itunes:duration> tag value:
     HH:MM:SS
     H:MM:SS
     MM:SS
     M:SS
     Where H = hours, M = minutes, and S = seconds.
     
     If you specify a single number as a value (without colons),
        Apple Podcasts displays the value as seconds. If you specify
        one colon, Apple Podcasts displays the number to the left as
        minutes and the number to the right as seconds. If you
        specify more then two colons, Apple Podcasts ignores the
        numbers farthest to the right.
    */
    var itunesDuration: String?
    // Number episode in total list
    var itunesEpisode: Int?
    // itunesEpisodeType: either full, trailer, or bonus
    var itunesEpisodeType: EpisodeType?
    var itunesExplicit: Bool?
    // Episode artwork, not the same as podcast artwork
    var itunesImage: URL?
    // true if video is embedded with CC
    var itunesClosedCaptioned: Bool?
    
    enum EpisodeType: String {
        case full = "full"
        case trailer = "trailer"
        case bonus = "bonus"
    }
    
    enum Enclosure {
        // FROM APPLE: type. The type attribute provides the correct category
        // for the type of file you are using. The type values for the
        // supported file formats are: audio/x-m4a, audio/mpeg, video/quicktime,
        // video/mp4, video/x-m4v, and application/pdf.
        
        // url is asset url, length is size in bytes
        case audio(url: URL, length: Int)
        case video(url: URL, length: Int)
        case pdf(url: URL, length: Int)
    }
}

class PodcastFeedParser: NSObject {
    var result: Podcast?
    var partial: PartialPodcast!
    
    init(podcast: PartialPodcast) {
        super.init()
        partial = podcast
    }
    
    private func parse(items: [RSSFeedItem]?) -> [Episode] {
        guard let items = items else { return [] }
        // TODO: Implement this
        return []
    }
    
    func parse(shouldParseItems: Bool) {
        let parser = FeedParser(URL: partial.feedUrl)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            // arg result is the RSSFeed parsed result, we now need to extract that into
            // a full Podcast model
            if let feed = result.rssFeed, result.isSuccess {
                var podcast = Podcast(partial: self.partial)
                
                guard let title = feed.title,
                    let link = feed.link,
                    let description = feed.description else {
                        // TODO: better error handle
                        return
                }
                podcast.title = title
                podcast.link = link
                podcast.channelDescription = description
                
                podcast.copyright = feed.copyright
                podcast.language = feed.language
                podcast.pubDate = "" // TODO: feed.pubDate into Date
                podcast.lastBuildDate = "" // TODO: feed.lastBuildDate into Date
                podcast.image = URL(string: feed.image?.url ?? "")
                
                // TODO: find itunes type, serial or episodic
//                podcast.itunesType = feed.iTunes?.iTunesOrder
                podcast.itunesSummary = feed.iTunes?.iTunesSummary
                podcast.itunesSubtitle = feed.iTunes?.iTunesSubtitle
                podcast.itunesAuthor = feed.iTunes?.iTunesAuthor
                podcast.itunesBlock = feed.iTunes?.iTunesBlock == "Yes" // TODO: add the other options
                var categories: [String] = []
                feed.iTunes?.iTunesCategories?.forEach { body in
                    if let category = body.attributes?.text {
                        categories.append(category)
                    }
                    if let subCategory = body.subcategory?.attributes?.text {
                        categories.append(subCategory)
                    }
                }
                podcast.itunesCategories = categories
//                podcast.itunesComplete = feed.iTunes?.iTunesComplete == "Yes" // TODO: add the other options
//                podcast.itunesExplicit = feed.iTunes?.iTunesExplicit == "Yes" // TODO: add the other options
                podcast.itunesNewFeedUrl = URL(string: feed.iTunes?.iTunesNewFeedURL ?? "")
                podcast.itunesOwnerName = feed.iTunes?.iTunesOwner?.name
                podcast.itunesOwnerEmail = feed.iTunes?.iTunesOwner?.email
                podcast.itunesImage = feed.iTunes?.iTunesImage?.attributes?.href
                podcast.itunesKeywords = feed.iTunes?.iTunesKeywords
                
                if shouldParseItems {
                    podcast.items = self.parse(items: feed.items)
                }
                
                DispatchQueue.main.async {
                    // ..and update the UI
                }
            }
        }
    }
}


