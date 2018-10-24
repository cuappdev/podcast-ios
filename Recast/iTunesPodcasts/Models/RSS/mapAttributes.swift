//
//  RSSFeed + mapAttributes.swift
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

    /// Maps the attributes of the specified dictionary for a given `RSSPath`
    /// to the `Podcast` model,
    ///
    /// - Parameters:
    ///   - attributes: The attribute dictionary to map to the model.
    ///   - path: The path of feed's element.
    func map(_ attributes: [String: String], for path: RSSPath) {

        switch path {
        case .rssChannelItem:

            self.items?.append(Episode())

        case .rssChannelImage:
            break

        case .rssChannelSkipDays:

            if  self.rawSkipDays == nil {
                self.rawSkipDays = []
            }

        case .rssChannelSkipHours:

            if  self.skipHours == nil {
                self.skipHours = []
            }

        case .rssChannelTextInput:

            if  self.textInput == nil {
                self.textInput = TextInput()
            }

        case .rssChannelCategory:

            if  self.categories == nil {
                self.categories = []
            }

        case .rssChannelCloud:

            if  self.cloud == nil {
                self.cloud = Cloud(attributes: attributes)
            }

        case .rssChannelItemCategory:

            if  self.items?.last?.categories == nil {
                self.items?.last?.categories = []
            }

        case .rssChannelItemEnclosure:

            if  self.items?.last?.enclosure == nil {
                self.items?.last?.enclosure = Enclosure(from: attributes)
            }

        case .rssChannelItemGUID:
            break

        case .rssChannelItemSource:

            if  self.items?.last?.source == nil {
                self.items?.last?.source = ItemSource(attributes: attributes)
            }

        case .rssChannelItemContentEncoded:
            break

        case
        .rssChannelItunesAuthor,
        .rssChannelItunesBlock,
        .rssChannelItunesCategory,
        .rssChannelItunesSubcategory,
        .rssChannelItunesImage,
        .rssChannelItunesExplicit,
        .rssChannelItunesComplete,
        .rssChannelItunesNewFeedURL,
        .rssChannelItunesOwner,
        .rssChannelItunesOwnerName,
        .rssChannelItunesOwnerEmail,
        .rssChannelItunesSubtitle,
        .rssChannelItunesSummary,
        .rssChannelItunesKeywords,
        .rssChannelItunesType:

            if  self.iTunes == nil {
                self.iTunes = ITunesNamespace()
            }

            switch path {

            case .rssChannelItunesCategory:

                if  self.iTunes?.categories == nil {
                    self.iTunes?.categories = []
                }

                self.iTunes?.categories?.append(ITunesCategory(attributes: attributes))

            case .rssChannelItunesSubcategory:

                self.iTunes?.categories?.last?.subcategory = attributes["text"]

            case .rssChannelItunesImage:

                self.iTunes?.image = URL(string: attributes["href"] ?? "")

            case .rssChannelItunesOwner:

                if  self.iTunes?.owner == nil {
                    self.iTunes?.owner = ITunesOwner()
                }

            default:
                break

            }

        case
        .rssChannelItemItunesAuthor,
        .rssChannelItemItunesBlock,
        .rssChannelItemItunesDuration,
        .rssChannelItemItunesImage,
        .rssChannelItemItunesExplicit,
        .rssChannelItemItunesIsClosedCaptioned,
        .rssChannelItemItunesOrder,
        .rssChannelItemItunesSubtitle,
        .rssChannelItemItunesSummary,
        .rssChannelItemItunesKeywords:

            if  self.items?.last?.iTunes == nil {
                self.items?.last?.iTunes = ITunesNamespace()
            }

            switch path {

            case .rssChannelItemItunesImage:
                self.items?.last?.iTunes?.image = URL(string: attributes["href"] ?? "")

            default:
                break

            }

        default:
            break

        }
    }
}
