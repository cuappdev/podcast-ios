//
//  RSSFeed.swift
//
//  Copyright (c) 2016 - 2018 Nuno Manuel Dias
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

// MARK: - Equatable

import Foundation

extension Podcast {

    func combine(with podcast: PartialPodcast) {
        setValue(Int64(truncatingIfNeeded: podcast.collectionId), for: .collectionId)
        setValue(podcast.feedUrl, for: .feedUrl)
        setValue(podcast.collectionName, for: .collectionName)
        setValue(podcast.artworkUrl30, for: .artworkUrl30)
        setValue(podcast.artworkUrl60, for: .artworkUrl60)
        setValue(podcast.artworkUrl100, for: .artworkUrl100)
        setValue(podcast.artworkUrl600, for: .artworkUrl600)
        setValue(podcast.collectionExplicitness, for: .collectionExplicitness)
        setValue(podcast.primaryGenreName, for: .primaryGenreName)
        setValue(podcast.genreIds, for: .genreIds)
        setValue(podcast.genres, for: .genres)
    }

    public static func == (lhs: Podcast, rhs: Podcast) -> Bool {
        return
            lhs.categories == rhs.categories &&
            lhs.copyright == rhs.copyright &&
            lhs.descriptionText == rhs.descriptionText &&
            lhs.docs == rhs.docs &&
            lhs.generator == rhs.generator &&
            lhs.items == rhs.items &&
            lhs.iTunes == rhs.iTunes &&
            lhs.language == rhs.language &&
            lhs.lastBuildDate == rhs.lastBuildDate &&
            lhs.link == rhs.link &&
            lhs.managingEditor == rhs.managingEditor &&
            lhs.pubDate == rhs.pubDate &&
            lhs.rating == rhs.rating &&
            lhs.rawSkipDays == rhs.rawSkipDays &&
            lhs.skipHours == rhs.skipHours &&
            lhs.textInput == rhs.textInput &&
            lhs.title == rhs.title &&
            lhs.ttl == rhs.ttl &&
            lhs.webMaster == rhs.webMaster
    }

}

// MARK: - Loading

extension Podcast {
    class func loadFull(from partial: PartialPodcast,
                        success: @escaping (Podcast) -> Void,
                        failure: @escaping (Error) -> Void) {
        let parser = FeedParser(url: partial.feedUrl)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { result in
            switch result {
            case .rss(let podcast):
                DispatchQueue.main.async {
                    podcast.combine(with: partial)
                    success(podcast)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    failure(error)
                }
            }
        }
    }
}
