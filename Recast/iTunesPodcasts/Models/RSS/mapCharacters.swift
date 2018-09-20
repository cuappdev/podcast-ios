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

extension Podcast {
    
    /// Maps the characters in the specified string to the `Podcast` model.
    ///
    /// - Parameters:
    ///   - string: The string to map to the model.
    ///   - path: The path of feed's element.
    func map(_ string: String, for path: RSSPath) {
        
        switch path {
        case .rssChannelTitle:                                      self.title                                                      = self.title?.appending(string) ?? string
        case .rssChannelLink:                                       self.link                                                       = self.link?.appending(string) ?? string
        case .rssChannelDescription:                                self.description                                                = self.description?.appending(string) ?? string
        case .rssChannelLanguage:                                   self.language                                                   = self.language?.appending(string) ?? string
        case .rssChannelCopyright:                                  self.copyright                                                  = self.copyright?.appending(string) ?? string
        case .rssChannelManagingEditor:                             self.managingEditor                                             = self.managingEditor?.appending(string) ?? string
        case .rssChannelWebMaster:                                  self.webMaster                                                  = self.webMaster?.appending(string) ?? string
        case .rssChannelPubDate:                                    self.pubDate                                                    = string.toPermissiveDate()
        case .rssChannelLastBuildDate:                              self.lastBuildDate                                              = string.toPermissiveDate()
//        case .rssChannelCategory:                                   self.categories?.last?.value                                    = self.categories?.last?.value?.appending(string) ?? string
        case .rssChannelCategory:                                   self.categories?
            .append(string)
        case .rssChannelGenerator:                                  self.generator                                                  = self.generator?.appending(string) ?? string
        case .rssChannelDocs:                                       self.docs                                                       = self.docs?.appending(string) ?? string
        case .rssChannelRating:                                     self.rating                                                     = self.rating?.appending(string) ?? string
        case .rssChannelTTL:                                        self.ttl                                                        = Int(string)
        case .rssChannelImageURL:                                   self.image                                                 = URL(string: string)
//        case .rssChannelImageURL:                                   self.image?.url                                                 = self.image?.url?.appending(string) ?? string
//        case .rssChannelImageTitle:                                 self.image?.title                                               = self.image?.title?.appending(string) ?? string
//        case .rssChannelImageLink:                                  self.image?.link                                                = self.image?.link?.appending(string) ?? string
//        case .rssChannelImageWidth:                                 self.image?.width                                               = Int(string)
//        case .rssChannelImageHeight:                                self.image?.height                                              = Int(string)
//        case .rssChannelImageDescription:                           self.image?.description                                         = self.image?.description?.appending(string) ?? string
        case .rssChannelTextInputTitle:                             self.textInput?.title                                           = self.textInput?.title?.appending(string) ?? string
        case .rssChannelTextInputDescription:                       self.textInput?.description                                     = self.textInput?.description?.appending(string) ?? string
        case .rssChannelTextInputName:                              self.textInput?.name                                            = self.textInput?.name?.appending(string) ?? string
        case .rssChannelTextInputLink:                              self.textInput?.link                                            = self.textInput?.link?.appending(string) ?? string
        case .rssChannelSkipHoursHour:
            if let hour = SkipHour(string), 0...23 ~= hour {
                self.skipHours?.append(hour)
            }
        case .rssChannelSkipDaysDay:
            if let day = SkipDay(rawValue: string) {
                self.skipDays?.append(day)
            }
        case .rssChannelItemTitle:                                  self.items.last?.title                                         = self.items.last?.title?.appending(string) ?? string
        case .rssChannelItemLink:                                   self.items.last?.link                                          = self.items.last?.link?.appending(string) ?? string
        case .rssChannelItemDescription:                            self.items.last?.description                                   = self.items.last?.description?.appending(string) ?? string
        case .rssChannelItemAuthor:                                 self.items.last?.author                                        = self.items.last?.author?.appending(string) ?? string
        case .rssChannelItemCategory:
            self.items.last?.categories?.append(string)
        case .rssChannelItemComments:                               self.items.last?.comments                                      = self.items.last?.comments?.appending(string) ?? string
        case .rssChannelItemGUID:                                   self.items.last?.guid                                   = string
        case .rssChannelItemPubDate:                                self.items.last?.pubDate                                       = string.toPermissiveDate()
        case .rssChannelItemSource:                                 self.items.last?.source?.value                                 = self.items.last?.source?.value?.appending(string) ?? string
        case .rssChannelItemContentEncoded:
            self.items.last?.content = string
        case .rssChannelItunesAuthor:                               self.iTunes?.author                                       = self.iTunes?.author?.appending(string) ?? string
        case .rssChannelItunesBlock:                                self.iTunes?.block                                        = self.iTunes?.block?.appending(string) ?? string
        case .rssChannelItunesExplicit:
            self.iTunes?.explicit = string.toBool() || string.lowercased() == "explicit"
        case .rssChannelItunesComplete:                             self.iTunes?.complete                                     = self.iTunes?.complete?.appending(string) ?? string
        case .rssChannelItunesNewFeedURL:                           self.iTunes?.newFeedUrl                                   = self.iTunes?.newFeedUrl?.appending(string) ?? string
        case .rssChannelItunesOwnerName:                            self.iTunes?.owner?.name                                  = self.iTunes?.owner?.name?.appending(string) ?? string
        case .rssChannelItunesOwnerEmail:                           self.iTunes?.owner?.email                                 = self.iTunes?.owner?.email?.appending(string) ?? string
        case .rssChannelItunesSubtitle:                             self.iTunes?.subtitle                                     = self.iTunes?.subtitle?.appending(string) ?? string
        case .rssChannelItunesSummary:                              self.iTunes?.summary                                      = self.iTunes?.summary?.appending(string) ?? string
        case .rssChannelItunesKeywords:                             self.iTunes?.keywords                                     = self.iTunes?.keywords?.appending(string) ?? string
        case .rssChannelItunesType:                                 self.iTunes?.type                                         = ITunesNamespace.PodcastType(rawValue: string)
        case .rssChannelItemItunesAuthor:                           self.items.last?.iTunes?.author                          = self.items.last?.iTunes?.author?.appending(string) ?? string
        case .rssChannelItemItunesBlock:                            self.items.last?.iTunes?.block                           = self.items.last?.iTunes?.block?.appending(string) ?? string
        case .rssChannelItemItunesDuration:                         self.items.last?.iTunes?.duration                        = string.toDuration()
        case .rssChannelItemItunesExplicit:
            self.iTunes?.explicit = string.toBool() || string.lowercased() == "explicit"
        case .rssChannelItemItunesIsClosedCaptioned:                self.items.last?.iTunes?.isClosedCaptioned                     = string.lowercased() == "yes"
        case .rssChannelItemItunesOrder:                            self.items.last?.iTunes?.order                           = Int(string)
        case .rssChannelItemItunesSubtitle:                         self.items.last?.iTunes?.subtitle                        = self.items.last?.iTunes?.subtitle?.appending(string) ?? string
        case .rssChannelItemItunesSummary:                          self.items.last?.iTunes?.summary                         = self.items.last?.iTunes?.summary?.appending(string) ?? string
        case .rssChannelItemItunesKeywords:                         self.items.last?.iTunes?.keywords                        = self.items.last?.iTunes?.keywords?.appending(string) ?? string
        case .rssChannelItemItunesEpisodeType:                      self.items.last?.iTunes?.episodeType                     = ITunesNamespace.EpisodeType(rawValue: string)
        case .rssChannelItemItunesSeason:                           self.items.last?.iTunes?.season                          = Int(string)
        case .rssChannelItemItunesEpisode:                          self.items.last?.iTunes?.episode                         = Int(string)
        default: break
        }
        
    }
    
}
