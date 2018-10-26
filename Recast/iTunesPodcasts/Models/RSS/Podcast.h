//
//  Enclosure.h
//  Recast
//
//  Created by Mindy Lou on 10/21/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "Cloud.h"
#import "Episode.h"

typedef NS_ENUM(NSInteger, SkipDay) {
    monday,
    tuesday,
    wednesday,
    thursday,
    friday,
    saturday,
    sunday
};

@protocol PartialPodcast

@property (nonatomic, copy) NSNumber *collectionId;
@property (nonatomic, copy) NSURL *feedUrl;
@property (nonatomic, copy) NSString *artistName;
@property (nonatomic, copy) NSString *collectionName;
@property (nonatomic, nullable, copy) NSURL *artworkUrl30;
@property (nonatomic, nullable, copy) NSURL *artworkUrl60;
@property (nonatomic, nullable, copy) NSURL *artworkUrl100;
@property (nonatomic, copy) NSString *collectionExplicitness;
@property (nonatomic, copy) NSString *primaryGenreName;
@property (nonatomic, nullable, copy) NSURL *artworkUrl600;
@property (nonatomic, copy) NSArray<NSString *> *genreIds;
@property (nonatomic, copy) NSArray<NSString *> *genres;

@end

@class TextInput;

/// Data model for the XML DOM of the RSS 2.0 Specification
/// See http://cyber.law.harvard.edu/rss/rss.html
@interface Podcast : NSManagedObject<PartialPodcast>

// MARK: iTunes Search API Fields

/// The name of the channel. It's how people refer to your service. If
/// you have an HTML website that contains the same information as your
/// RSS file, the title of your channel should be the same as the title
/// of your website.
///
/// Example: GoUpstate.com News Headlines
@property (nonatomic, copy) NSString *title;

/// The URL to the HTML website corresponding to the channel.
///
/// Example: http://www.goupstate.com/
@property (nonatomic, copy) NSString *link;

/// Phrase or sentence describing the channel.
///
/// Example: The latest news from GoUpstate.com, a Spartanburg Herald-Journal
/// Web site.
@property (nonatomic, copy) NSString *descriptionText;

/// The language the channel is written in. This allows aggregators to group
/// all Italian language sites, for example, on a single page. A list of
/// allowable values for this element, as provided by Netscape, is here:
/// http://cyber.law.harvard.edu/rss/languages.html
///
/// You may also use values defined by the W3C:
/// http://www.w3.org/TR/REC-html40/struct/dirlang.html#langcodes
///
/// Example: en-us
@property (nullable, nonatomic, copy) NSString *language;

/// Copyright notice for content in the channel.
///
/// Example: Copyright 2002, Spartanburg Herald-Journal
@property (nullable, nonatomic, copy) NSString *copyright;

/// Email address for person responsible for editorial content.
///
/// Example: geo@herald.com (George Matesky)
@property (nullable, nonatomic, copy) NSString *managingEditor;

/// Email address for person responsible for technical issues relating to
/// channel.
///
/// Example: betty@herald.com (Betty Guernsey)
@property (nullable, nonatomic, copy) NSString *webMaster;

/// The publication date for the content in the channel. For example, the
/// New York Times publishes on a daily basis, the publication date flips
/// once every 24 hours. That's when the pubDate of the channel changes.
/// All date-times in RSS conform to the Date and Time Specification of
/// RFC 822, with the exception that the year may be expressed with two
/// characters or four characters (four preferred).
///
/// Example: Sat, 07 Sep 2002 00:00:01 GMT
@property (nullable, nonatomic, copy) NSDate *pubDate;

/// The last time the content of the channel changed.
///
/// Example: Sat, 07 Sep 2002 09:42:31 GMT
@property (nullable, nonatomic, copy) NSDate *lastBuildDate;

/// Specify one or more categories that the channel belongs to. Follows the
/// same rules as the <item>-level category element.
///
/// Example: Newspapers
@property (nullable, nonatomic, copy) NSArray<NSString *> *categories;

/// A string indicating the program used to generate the channel.
///
/// Example: MightyInHouse Content System v2.3
@property (nullable, nonatomic, copy) NSString *generator;

/// A URL that points to the documentation for the format used in the RSS
/// file. It's probably a pointer to this page. It's for people who might
/// stumble across an RSS file on a Web server 25 years from now and wonder
/// what it is.
///
/// Example: http://blogs.law.harvard.edu/tech/rss
@property (nullable, nonatomic, copy) NSString *docs;

/// Allows processes to register with a cloud to be notified of updates to
/// the channel, implementing a lightweight publish-subscribe protocol for
/// RSS feeds.
///
/// Example: <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="pingMe" protocol="soap"/>
///
/// <cloud> is an optional sub-element of <channel>.
///
/// It specifies a web service that supports the rssCloud interface which can
/// be implemented in HTTP-POST, XML-RPC or SOAP 1.1.
///
/// Its purpose is to allow processes to register with a cloud to be notified
/// of updates to the channel, implementing a lightweight publish-subscribe
/// protocol for RSS feeds.
///
/// <cloud domain="rpc.sys.com" port="80" path="/RPC2" registerProcedure="myCloud.rssPleaseNotify"
/// protocol="xml-rpc" />
///
/// In this example, to request notification on the channel it appears in,
/// you would send an XML-RPC message to rpc.sys.com on port 80, with a path
/// of /RPC2. The procedure to call is myCloud.rssPleaseNotify.
///
/// A full explanation of this element and the rssCloud interface is here:
/// http://cyber.law.harvard.edu/rss/soapMeetsRss.html#rsscloudInterface
@property (nullable, nonatomic, copy) Cloud *cloud;

/// The PICS rating for the channel.
@property (nullable, nonatomic, copy) NSString *rating;

/// ttl stands for time to live. It's a number of minutes that indicates how
/// long a channel can be cached before refreshing from the source.
///
/// Example: 60
///
/// <ttl> is an optional sub-element of <channel>.
///
/// ttl stands for time to live. It's a number of minutes that indicates how
/// long a channel can be cached before refreshing from the source. This makes
/// it possible for RSS sources to be managed by a file-sharing network such
/// as Gnutella.
@property (nonatomic) NSNumber *ttl;

/// Specifies a GIF, JPEG or PNG image that can be displayed with the channel.
///
/// <image> is an optional sub-element of <channel>, which contains three
/// required and three optional sub-elements.
///
/// <url> is the URL of a GIF, JPEG or PNG image that represents the channel.
///
/// <title> describes the image, it's used in the ALT attribute of the HTML
/// <img> tag when the channel is rendered in HTML.
///
/// <link> is the URL of the site, when the channel is rendered, the image
/// is a link to the site. (Note, in practice the image <title> and <link>
/// should have the same value as the channel's <title> and <link>.
///
/// Optional elements include <width> and <height>, numbers, indicating the
/// width and height of the image in pixels. <description> contains text
/// that is included in the TITLE attribute of the link formed around the
/// image in the HTML rendering.
///
/// Maximum value for width is 144, default value is 88.
///
/// Maximum value for height is 400, default value is 31.
/// URL is all that is important so just use that.
@property (nullable, nonatomic, copy) NSURL *image;

/// A channel may contain any number of <item>s. An item may represent a
/// "story" -- much like a story in a newspaper or magazine; if so its
/// description is a synopsis of the story, and the link points to the full
/// story. An item may also be complete in itself, if so, the description
/// contains the text (entity-encoded HTML is allowed; see examples:
/// http://cyber.law.harvard.edu/rss/encodingDescriptions.html), and
/// the link and title may be omitted. All elements of an item are optional,
/// however at least one of title or description must be present.
@property (nullable, nonatomic, copy) NSArray<Episode *> *items;

// MARK: - Namespaces

/// iTunes Podcasting Tags are de facto standard for podcast syndication.
/// See https://help.apple.com/itc/podcasts_connect/#/itcb54353390
@property (nullable, nonatomic, copy) ITunesNamespace *iTunes;

/// A hint for aggregators telling them which days they can skip.
///
/// An XML element that contains up to seven <day> sub-elements whose value
/// is Monday, Tuesday, Wednesday, Thursday, Friday, Saturday or Sunday.
/// Aggregators may not read the channel during days listed in the skipDays
/// element.
@property (nullable, nonatomic, copy) NSArray<NSNumber *> *rawSkipDays;

/// Specifies a text input box that can be displayed with the channel.
///
/// A channel may optionally contain a <textInput> sub-element, which contains
/// four required sub-elements.
///
/// <title> -- The label of the Submit button in the text input area.
///
/// <description> -- Explains the text input area.
///
/// <name> -- The name of the text object in the text input area.
///
/// <link> -- The URL of the CGI script that processes text input requests.
///
/// The purpose of the <textInput> element is something of a mystery. You can
/// use it to specify a search engine box. Or to allow a reader to provide
/// feedback. Most aggregators ignore it.
@property (nullable, nonatomic, copy) TextInput *textInput;

/// A hint for aggregators telling them which hours they can skip.
///
/// An XML element that contains up to 24 <hour> sub-elements whose value is a
/// number between 0 and 23, representing a time in GMT, when aggregators, if they
/// support the feature, may not read the channel on hours listed in the skipHours
/// element.
///
/// The hour beginning at midnight is hour zero.
@property (nullable, nonatomic, copy) NSArray<NSNumber *> *skipHours;

- (void)combineWithPodcast:(id<PartialPodcast>)partialPodcast;

+ (SkipDay)skipDayFromString:(NSString *)string;

@end

