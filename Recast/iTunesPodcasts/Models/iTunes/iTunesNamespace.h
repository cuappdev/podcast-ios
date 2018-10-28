//
//  iTunesNamespace.h
//  Recast
//
//  Created by Mindy Lou on 10/21/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ITunesCategory;
@class ITunesOwner;

typedef NS_ENUM(NSInteger, PodcastType) {
    episodic,
    serial
};

typedef NS_ENUM(NSInteger, EpisodeType) {
    full,
    trailer,
    bonus
};

/// iTunes Podcasting Tags are de facto standard for podcast syndication. For more
/// information see https://help.apple.com/itc/podcasts_connect/#/itcb54353390
@interface ITunesNamespace : NSManagedObject

/// The content you specify in the <itunes:author> tag appears in the Artist
/// column on the iTunes Store. If the tag is not present, the iTunes Store
/// uses the contents of the <author> tag. If <itunes:author> is not present
/// at the RSS feed level, the iTunes Store uses the contents of the
/// <managingEditor> tag.
@property (nullable, nonatomic, copy) NSString *author;

/// Specifying the <itunes:block> tag with a Yes value in:
///
/// - A <channel> tag (podcast), prevents the entire podcast from appearing on
/// the iTunes Store podcast directory
///
/// - An <item> tag (episode), prevents that episode from appearing on the
/// iTunes Store podcast directory
///
/// For example, you might want to block a specific episode if you know that
/// its content would otherwise cause the entire podcast to be removed from
/// the iTunes Store. Specifying any value other than Yes has no effect.
@property (nullable, nonatomic, copy) NSString *block;

/// Users can browse podcast subject categories in the iTunes Store by choosing
/// a category from the Podcasts pop-up menu in the navigation bar. Use the
/// <itunes:category> tag to specify the browsing category for your podcast.
///
/// You can also define a subcategory if one is available within your category.
/// Although you can specify more than one category and subcategory in your
/// feed, the iTunes Store only recognizes the first category and subcategory.
/// For a complete list of categories and subcategories, see Podcasts Connect
/// categories.
///
/// Note: When specifying categories and subcategories, be sure to properly
/// escape ampersands:
///
/// Single category:
/// <itunes:category text="Music" />
///
/// Category with ampersand:
/// <itunes:category text="TV &amp; Film" />
///
/// Category with subcategory:
/// <itunes:category text="Society &amp; Culture">
/// <itunes:category text="History" />
/// </itunes:category>
///
/// Multiple categories:
/// <itunes:category text="Society &amp; Culture">
/// <itunes:category text="History" />
/// </itunes:category>
/// <itunes:category text="Technology">
/// <itunes:category text="Gadgets" />
/// </itunes:category>
@property (nullable, nonatomic, copy) NSArray<ITunesCategory *> *categories;

/// Specify your podcast artwork using the <a href> attribute in the
/// <itunes:image> tag. If you do not specify the <itunes:image> tag, the
/// iTunes Store uses the content specified in the RSS feed image tag and Apple
/// does not consider your podcast for feature placement on the iTunes Store or
/// Podcasts.
///
/// Depending on their device, subscribers see your podcast artwork in varying
/// sizes. Therefore, make sure your design is effective at both its original
/// size and at thumbnail size. Apple recommends including a title, brand, or
/// source name as part of your podcast artwork. For examples of podcast
/// artwork, see the Top Podcasts. To avoid technical issues when you update
/// your podcast artwork, be sure to:
///
/// Change the artwork file name and URL at the same time
/// Verify the web server hosting your artwork allows HTTP head requests
/// The <itunes:image> tag is also supported at the <item> (episode) level.
/// For best results, Apple recommends embedding the same artwork within the
/// metadata for that episode's media file prior to uploading to your host
/// server; using Garageband or another content-creation tool to edit your
/// media file if needed.
///
/// Note: Artwork must be a minimum size of 1400 x 1400 pixels and a maximum
/// size of 3000 x 3000 pixels, in JPEG or PNG format, 72 dpi, with appropriate
/// file extensions (.jpg, .png), and in the RGB colorspace. These requirements
/// are different from the standard RSS image tag specifications.
@property (nullable, nonatomic, copy) NSURL *image;

/// The content you specify in the <itunes:duration> tag appears in the Time
/// column in the List View on the iTunes Store.
///
/// Specify one of the following formats for the <itunes:duration> tag value:
///
/// HH:MM:SS
/// H:MM:SS
/// MM:SS
/// M:SS
///
/// Where H = hours, M = minutes, and S = seconds.
///
/// If you specify a single number as a value (without colons), the iTunes
/// Store displays the value as seconds. If you specify one colon, the iTunes
/// Store displays the number to the left as minutes and the number to the
/// right as seconds. If you specify more then two colons, the iTunes Store
/// ignores the numbers farthest to the right.
@property (nonatomic) NSNumber *duration;

/// The <itunes:explicit> tag indicates whether your podcast contains explicit
/// material. You can specify the following values:
///
/// Yes | Explicit | True. If you specify yes, explicit, or true, indicating
/// the presence of explicit content, the iTunes Store displays an Explicit
/// parental advisory graphic for your podcast.
/// Clean | No | False. If you specify clean, no, or false, indicating that
/// none of your podcast episodes contain explicit language or adult content,
/// the iTunes Store displays a Clean parental advisory graphic for your
/// podcast.
///
/// Note: Podcasts containing explicit material are not available in some
/// iTunes Store territories.
@property (nonatomic, assign) BOOL explicit;

/// Specifying the <itunes:isClosedCaptioned> tag with a Yes value indicates
/// that the video podcast episode is embedded with closed captioning and the
/// iTunes Store should display a closed-caption icon next to the corresponding
/// episode. This tag is only supported at the <item> level (episode).
///
/// Note: If you specify a value other than Yes, no closed-caption indicator
/// appears.
@property (nonatomic, assign) BOOL isClosedCaptioned;

/// Use the <itunes:order> tag to specify the number value in which you would
/// like the episode to appear and override the default ordering of episodes
/// on the iTunes Store.
///
/// For example, if you want an <item> to appear as the first episode of your
/// podcast, specify the <itunes:order> tag with 1. If conflicting order
/// values are present in multiple episodes, the iTunes Store uses <pubDate>.
@property (nonatomic) NSNumber *order;

/// Specifying the <itunes:complete> tag with a Yes value indicates that a
/// podcast is complete and you will not post any more episodes in the future.
/// This tag is only supported at the <channel> level (podcast).
///
/// Note: If you specify a value other than Yes, nothing happens.
@property (nullable, nonatomic, copy) NSString *complete;

/// Use the <itunes:new-feed-url> tag to manually change the URL where your
/// podcast is located. This tag is only supported at a <channel>level
/// (podcast).
///
/// <itunes:new-feed-url>http://newlocation.com/example.rss</itunes:new-feed-url>
/// Note: You should maintain your old feed until you have migrated your e
/// xisting subscribers. For more information, see Update your RSS feed URL.
@property (nullable, nonatomic, copy) NSString *theNewFeedUrl;

/// Use the <itunes:owner> tag to specify contact information for the podcast
/// owner. Include the email address of the owner in a nested <itunes:email>
/// tag and the name of the owner in a nested <itunes:name> tag.
///
/// The <itunes:owner> tag information is for administrative communication
/// about the podcast and is not displayed on the iTunes Store.
@property (nullable, nonatomic, copy) ITunesOwner *owner;

/// The content you specify in the <itunes:subtitle> tag appears in the
/// Description column on the iTunes Store. For best results, choose a subtitle
/// that is only a few words long.
@property (nullable, nonatomic, copy) NSString *subtitle;

/// The content you specify in the <itunes:summary> tag appears on the iTunes
/// Store page for your podcast. You can specify up to 4000 characters. The
/// information also appears in a separate window if a users clicks the
/// Information icon (Information icon) in the Description column. If you do
/// not specify a <itunes:summary> tag, the iTunes Store uses the information
/// in the <description> tag.
@property (nullable, nonatomic, copy) NSString *summary;

/// Note: The keywords tag is deprecated by Apple and no longer documented in
/// the official list of tags. However many podcasts still use the tags and it
/// may be of use for developers building directory or search functionality so
/// it is included.
///
/// <itunes:keywords>
/// This tag allows users to search on text keywords.
/// Limited to 255 characters or less, plain text, no HTML, words must be
/// separated by spaces.
/// This tag is applicable to the Item element only.
@property (nullable, nonatomic, copy) NSString *keywords;

/// Use the <itunes:type> tag to indicate how you intend for episodes to be
/// presented. You can specify the following values:
///
/// episodic | serial. If you specify episodic it means you intend for
/// episodes to be presented newest-to-oldest. This is the default behavior
/// in the iTunes Store if the tag is excluded. If you specify serial it
/// means you intend for episodes to be presented oldest-to-newest.
@property (nonatomic) PodcastType type;

/// Use the <itunes:episodeType> tag to indicate what type of show item the
/// entry is. You can specify the following values:
///
/// full | trailer | bonus. If you specify full, it means this is the full
/// content of a show. Trailer means this is a preview of the show. Bonus
/// means it is extra content for a show.
@property (nonatomic) EpisodeType episodeType;

/// Use the <itunes:season> tag to indicate which season the item is part of.
///
/// Note: The iTunes Store & Apple Podcasts does not show the season number
/// until a feed contains at least two seasons.
@property (nonatomic) NSNumber *season;

/// Use the <itunes:episode> tag in conjunction with the <itunes:season> tag
/// to indicate the order an episode should be presented within a season.
@property (nonatomic) NSNumber *episode;

+ (PodcastType)initPodcastTypeWithRawValue:(NSString *)rawValue;
+ (EpisodeType)initEpisodeTypeWithRawValue:(NSString *)rawValue;

@end
