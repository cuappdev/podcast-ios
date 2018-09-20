//
//  RSSPath.swift
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

/// Describes the individual path for each XML DOM element of an RSS feed
/// 
/// See http://web.resource.org/rss/1.0/modules/content/
enum RSSPath: String {
    
    case rss                                                    = "/rss"
    case rssChannel                                             = "/rss/channel"
    case rssChannelTitle                                        = "/rss/channel/title"
    case rssChannelLink                                         = "/rss/channel/link"
    case rssChannelDescription                                  = "/rss/channel/description"
    case rssChannelLanguage                                     = "/rss/channel/language"
    case rssChannelCopyright                                    = "/rss/channel/copyright"
    case rssChannelManagingEditor                               = "/rss/channel/managingEditor"
    case rssChannelWebMaster                                    = "/rss/channel/webMaster"
    case rssChannelPubDate                                      = "/rss/channel/pubDate"
    case rssChannelLastBuildDate                                = "/rss/channel/lastBuildDate"
    case rssChannelCategory                                     = "/rss/channel/category"
    case rssChannelGenerator                                    = "/rss/channel/generator"
    case rssChannelDocs                                         = "/rss/channel/docs"
    case rssChannelCloud                                        = "/rss/channel/cloud"
    case rssChannelRating                                       = "/rss/channel/rating"
    case rssChannelTTL                                          = "/rss/channel/ttl"
    case rssChannelImage                                        = "/rss/channel/image"
    case rssChannelImageURL                                     = "/rss/channel/image/url"
    case rssChannelImageTitle                                   = "/rss/channel/image/title"
    case rssChannelImageLink                                    = "/rss/channel/image/link"
    case rssChannelImageWidth                                   = "/rss/channel/image/width"
    case rssChannelImageHeight                                  = "/rss/channel/image/height"
    case rssChannelImageDescription                             = "/rss/channel/image/description"
    case rssChannelTextInput                                    = "/rss/channel/textInput"
    case rssChannelTextInputTitle                               = "/rss/channel/textInput/title"
    case rssChannelTextInputDescription                         = "/rss/channel/textInput/description"
    case rssChannelTextInputName                                = "/rss/channel/textInput/name"
    case rssChannelTextInputLink                                = "/rss/channel/textInput/link"
    case rssChannelSkipHours                                    = "/rss/channel/skipHours"
    case rssChannelSkipHoursHour                                = "/rss/channel/skipHours/hour"
    case rssChannelSkipDays                                     = "/rss/channel/skipDays"
    case rssChannelSkipDaysDay                                  = "/rss/channel/skipDays/day"
    case rssChannelItem                                         = "/rss/channel/item"
    case rssChannelItemTitle                                    = "/rss/channel/item/title"
    case rssChannelItemLink                                     = "/rss/channel/item/link"
    case rssChannelItemDescription                              = "/rss/channel/item/description"
    case rssChannelItemAuthor                                   = "/rss/channel/item/author"
    case rssChannelItemCategory                                 = "/rss/channel/item/category"
    case rssChannelItemComments                                 = "/rss/channel/item/comments"
    case rssChannelItemEnclosure                                = "/rss/channel/item/enclosure"
    case rssChannelItemGUID                                     = "/rss/channel/item/guid"
    case rssChannelItemPubDate                                  = "/rss/channel/item/pubDate"
    case rssChannelItemSource                                   = "/rss/channel/item/source"
    
    // Content
    
    case rssChannelItemContentEncoded                           = "/rss/channel/item/content:encoded"
    
    // iTunes Podcasting Tags
    
    case rssChannelItunesAuthor                                 = "/rss/channel/itunes:author"
    case rssChannelItunesBlock                                  = "/rss/channel/itunes:block"
    case rssChannelItunesCategory                               = "/rss/channel/itunes:category"
    case rssChannelItunesSubcategory                            = "/rss/channel/itunes:category/itunes:category"
    case rssChannelItunesImage                                  = "/rss/channel/itunes:image"
    case rssChannelItunesExplicit                               = "/rss/channel/itunes:explicit"
    case rssChannelItunesComplete                               = "/rss/channel/itunes:complete"
    case rssChannelItunesNewFeedURL                             = "/rss/channel/itunes:new-feed-url"
    case rssChannelItunesOwner                                  = "/rss/channel/itunes:owner"
    case rssChannelItunesOwnerEmail                             = "/rss/channel/itunes:owner/itunes:email"
    case rssChannelItunesOwnerName                              = "/rss/channel/itunes:owner/itunes:name"
    case rssChannelItunesSubtitle                               = "/rss/channel/itunes:subtitle"
    case rssChannelItunesSummary                                = "/rss/channel/itunes:summary"
    case rssChannelItunesKeywords                               = "/rss/channel/itunes:keywords"
    case rssChannelItunesType                                   = "/rss/channel/itunes:type"
    
    case rssChannelItemItunesAuthor                             = "/rss/channel/item/itunes:author"
    case rssChannelItemItunesBlock                              = "/rss/channel/item/itunes:block"
    case rssChannelItemItunesImage                              = "/rss/channel/item/itunes:image"
    case rssChannelItemItunesDuration                           = "/rss/channel/item/itunes:duration"
    case rssChannelItemItunesExplicit                           = "/rss/channel/item/itunes:explicit"
    case rssChannelItemItunesIsClosedCaptioned                  = "/rss/channel/item/itunes:isClosedCaptioned"
    case rssChannelItemItunesOrder                              = "/rss/channel/item/itunes:order"
    case rssChannelItemItunesSubtitle                           = "/rss/channel/item/itunes:subtitle"
    case rssChannelItemItunesSummary                            = "/rss/channel/item/itunes:summary"
    case rssChannelItemItunesKeywords                           = "/rss/channel/item/itunes:keywords"
    case rssChannelItemItunesEpisodeType                        = "/rss/channel/item/itunes:episodeType"
    case rssChannelItemItunesSeason                             = "/rss/channel/item/itunes:season"
    case rssChannelItemItunesEpisode                            = "/rss/channel/item/itunes:episode"
    
}
