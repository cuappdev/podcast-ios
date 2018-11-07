//
//  RSSFeed + mapCharacters.swift
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

import Foundation

// swiftlint:disable cyclomatic_complexity
// swiftlint:disable function_body_length
extension Podcast {

    /// Maps the characters in the specified string to the `Podcast` model.
    ///
    /// - Parameters:
    ///   - string: The string to map to the model.
    ///   - path: The path of feed's element.
    func map(_ string: String, for path: RSSPath) {
        switch path {
        case .rssChannelTitle:
            setValue(self.title?.appending(string) ?? string, for: .title)
        case .rssChannelLink:
            setValue(self.link?.appending(string) ?? string, for: .link)
        case .rssChannelDescription:
            setValue(self.descriptionText?.appending(string) ?? string, for: .descriptionText)
        case .rssChannelLanguage:
            setValue(self.language?.appending(string) ?? string, for: .language)
        case .rssChannelCopyright:
            setValue(self.copyright?.appending(string) ?? string, for: .copyright)
        case .rssChannelManagingEditor:
            setValue(self.managingEditor?.appending(string), for: .managingEditor)
        case .rssChannelWebMaster:
            setValue(self.webMaster?.appending(string) ?? string, for: .webMaster)
        case .rssChannelPubDate:
            setValue(string.toPermissiveDate()! as NSDate, for: .pubDate)
        case .rssChannelLastBuildDate:
            setValue(string.toPermissiveDate()! as NSDate, for: .lastBuildDate)
        case .rssChannelCategory:
            setValue(self.categories?.append(string), for: .categories)
        case .rssChannelGenerator:
            setValue(self.generator?.appending(string) ?? string, for: .generator)
        case .rssChannelDocs:
            setValue(self.docs?.appending(string) ?? string, for: .docs)
        case .rssChannelRating:
            setValue(self.rating?.appending(string) ?? string, for: .rating)
        case .rssChannelTTL:
            setValue(Int64(string), for: .ttl)
        case .rssChannelImageURL:
            setValue(NSURL(string: string), for: .image)
        case .rssChannelTextInputTitle:
            self.textInput?.setValue(self.textInput?.title?.appending(string) ?? string, for: .title)
        case .rssChannelTextInputDescription:
            self.textInput?.setValue(self.textInput?.descriptionText?.appending(string) ?? string, for: .descriptionText)
        case .rssChannelTextInputName:
            self.textInput?.setValue(self.textInput?.name?.appending(string) ?? string, for: .name)
        case .rssChannelTextInputLink:
            self.textInput?.setValue(self.textInput?.link?.appending(string) ?? string, for: .link)
        case .rssChannelSkipHoursHour:
            guard let hour = Int64(string), 0...23 ~= hour else { return }
            var skipHours = self.skipHours
            skipHours?.append(hour)
            setValue(skipHours ?? [], for: .skipHours)
        case .rssChannelSkipDaysDay:
            self.rawSkipDays?.append(string)
        case .rssChannelItemTitle:
            let items = self.items?.array as? [Episode]
            items?.last?.setValue(items?.last?.title?.appending(string) ?? string, for: .title)
        case .rssChannelItemLink:
            let items = self.items?.array as? [Episode]
            items?.last?.setValue(items?.last?.link?.appending(string) ?? string, for: .link)
        case .rssChannelItemDescription:
            let items = self.items?.array as? [Episode]
            items?.last?.setValue(items?.last?.descriptionText?.appending(string) ?? string, for: .descriptionText)
        case .rssChannelItemAuthor:
            let items = self.items?.array as? [Episode]
            items?.last?.setValue(items?.last?.author?.appending(string) ?? string, for: .author)
        case .rssChannelItemCategory:
            let items = self.items?.array as? [Episode]
            var categories = items?.last?.categories
            categories?.append(string)
            items?.last?.setValue(categories, for: .categories)
        case .rssChannelItemComments:
            let items = self.items?.array as? [Episode]
            items?.last?.setValue(items?.last?.comments?.appending(string) ?? string, for: .comments)
        case .rssChannelItemGUID:
            let items = self.items?.array as? [Episode]
            items?.last?.setValue(string, for: .guid)
        case .rssChannelItemPubDate:
            let items = self.items?.array as? [Episode]
            items?.last?.setValue(string.toPermissiveDate() as NSDate? ?? NSDate(), for: .pubDate)
        case .rssChannelItemSource:
             let items = self.items?.array as? [Episode]
            items?.last?.source?.setValue(items?.last?.source?.value?.appending(string) ?? string, for: .value)
        case .rssChannelItemContentEncoded:
            let items = self.items?.array as? [Episode]
            items?.last?.setValue(string, for: .content)
        case .rssChannelItunesAuthor:
            self.iTunes?.setValue(self.iTunes?.author?.appending(string) ?? string, for: .author)
        case .rssChannelItunesBlock:
            self.iTunes?.setValue(self.iTunes?.block?.appending(string) ?? string, for: .block)
        case .rssChannelItunesExplicit:
            self.iTunes?.setValue(string.toBool() || string.lowercased() == "explicit", for: .explicit)
        case .rssChannelItunesComplete:
            self.iTunes?.setValue(self.iTunes?.complete?.appending(string) ?? string, for: .complete)
        case .rssChannelItunesNewFeedURL:
            self.iTunes?.setValue(self.iTunes?.newFeedUrl?.appending(string) ?? string, for: .newFeedUrl)
        case .rssChannelItunesOwnerName:
            self.iTunes?.owner?.setValue(self.iTunes?.owner?.name?.appending(string) ?? string, for: .name)
        case .rssChannelItunesOwnerEmail:
            self.iTunes?.owner?.setValue(self.iTunes?.owner?.email?.appending(string) ?? string, for: .email)
        case .rssChannelItunesSubtitle:
            self.iTunes?.setValue(self.iTunes?.subtitle?.appending(string) ?? string, for: .subtitle)
        case .rssChannelItunesSummary:
            self.iTunes?.setValue(self.iTunes?.summary?.appending(string) ?? string, for: .summary)
        case .rssChannelItunesKeywords:
            self.iTunes?.setValue(self.iTunes?.keywords?.appending(string) ?? string, for: .keywords)
        case .rssChannelItunesType:
            self.iTunes?.setValue(string, for: .podcastType)
        case .rssChannelItemItunesAuthor:
            let items = self.items?.array as? [Episode]
            items?.last?.iTunes?.setValue(items?.last?.iTunes?.author?.appending(string) ?? string, for: .author)
        case .rssChannelItemItunesBlock:
            let items = self.items?.array as? [Episode]
            items?.last?.iTunes?.setValue(items?.last?.iTunes?.block?.appending(string) ?? string, for: .block)
        case .rssChannelItemItunesDuration:
            let items = self.items?.array as? [Episode]
            items?.last?.iTunes?.setValue(string.toDuration() ?? 0, for: .duration)
        case .rssChannelItemItunesExplicit:
            self.iTunes?.setValue(string.toBool() || string.lowercased() == "explicit", for: .explicit)
        case .rssChannelItemItunesIsClosedCaptioned:
            let items = self.items?.array as? [Episode]
            items?.last?.iTunes?.setValue(string.lowercased() == "yes", for: .isClosedCaptioned)
        case .rssChannelItemItunesSubtitle:
            let items = self.items?.array as? [Episode]
            items?.last?.iTunes?.setValue(items?.last?.iTunes?.subtitle?.appending(string) ?? string, for: .subtitle)
        case .rssChannelItemItunesSummary:
            let items = self.items?.array as? [Episode]
            items?.last?.iTunes?.setValue(items?.last?.iTunes?.summary?.appending(string) ?? string, for: .summary)
        case .rssChannelItemItunesKeywords:
            let items = self.items?.array as? [Episode]
            items?.last?.iTunes?.setValue(items?.last?.iTunes?.keywords?.appending(string) ?? string, for: .keywords)
        case .rssChannelItemItunesEpisodeType:
            let items = self.items?.array as? [Episode]
            items?.last?.iTunes?.setValue(string, for: .episodeType)
        case .rssChannelItemItunesSeason:
            let items = self.items?.array as? [Episode]
            items?.last?.iTunes?.setValue(Int64(string), for: .season)
        case .rssChannelItemItunesEpisode:
            let items = self.items?.array as? [Episode]
            items?.last?.iTunes?.setValue(Int64(string), for: .episodeNumber)
        default: break
        }
    }
}
