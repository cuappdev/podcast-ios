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
            let episode = Episode(context: AppDelegate.appDelegate.dataController.managedObjectContext)
            var items = self.items?.array
            items?.append(episode)
            setValue(NSOrderedSet(array: items ?? []), for: .items)

        case .rssChannelImage:
            break

        case .rssChannelSkipDays:

            if  self.rawSkipDays == nil {
                setValue([String](), for: .rawSkipDays)
            }

        case .rssChannelSkipHours:

            if  self.skipHours == nil {
                setValue([Int64](), for: .skipHours)
            }

        case .rssChannelTextInput:

            if  self.textInput == nil {
                let textInput = TextInput(context: AppDelegate.appDelegate.dataController.managedObjectContext)
                setValue(textInput, for: .textInput)
            }

        case .rssChannelCategory:

            if  self.categories == nil {
                setValue([String](), for: .categories)
            }

        case .rssChannelItemCategory:
            let items = self.items?.array as? [Episode]
            if  items?.last?.categories == nil {
                items?.last?.setValue([String](), for: .categories)
            }

        case .rssChannelItemEnclosure:
            let items = self.items?.array as? [Episode]
            if  items?.last?.enclosure == nil {
                let enclosure = Enclosure(from: attributes)
                items?.last?.setValue(enclosure, for: .enclosure)
            }

        case .rssChannelItemGUID:
            break

        case .rssChannelItemSource:
            let items = self.items?.array as? [Episode]
            if  items?.last?.source == nil {
                let itemSource = ItemSource(attributes: attributes)
                items?.last?.setValue(itemSource, for: .source)
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
                self.iTunes = ITunesNamespace(context: AppDelegate.appDelegate.dataController.managedObjectContext)
            }

            switch path {

            case .rssChannelItunesCategory:

                if  self.iTunes?.categories == nil {
                    self.iTunes?.setValue([ITunesCategory](), for: .categories)
                }

                var categories = self.iTunes?.categories
                categories?.append(ITunesCategory(attributes: attributes))
                self.iTunes?.setValue(categories, for: .categories)

            case .rssChannelItunesSubcategory:

                self.iTunes?.categories?.last?.setValue(attributes["text"], for: .subcategory)

            case .rssChannelItunesImage:

                self.iTunes?.setValue(NSURL(string: attributes["href"] ?? ""), for: .image)

            case .rssChannelItunesOwner:

                if  self.iTunes?.owner == nil {
                    self.iTunes?.owner = ITunesOwner(context: AppDelegate.appDelegate.dataController.managedObjectContext)
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
            let items = self.items?.array as? [Episode]
            if  items?.last?.iTunes == nil {
                items?.last?.iTunes = ITunesNamespace(context: AppDelegate.appDelegate.dataController.managedObjectContext)
            }

            switch path {

            case .rssChannelItemItunesImage:
                let items = self.items?.array as? [Episode]
                items?.last?.iTunes?.setValue(NSURL(string: attributes["href"] ?? ""), for: .image)

            default:
                break

            }

        default:
            break

        }
    }
}
