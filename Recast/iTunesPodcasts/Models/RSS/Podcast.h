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

@protocol PartialPodcast;
@class TextInput;

@interface Podcast : NSManagedObject

@property (nonatomic) NSNumber *collectionId;

@property (nullable, nonatomic, copy) NSURL *feedUrl;

@property (nonatomic, copy) NSString *artistName;

@property (nonatomic, copy) NSString *collectionName;

@property (nullable, nonatomic, copy) NSURL *artworkUrl30;

@property (nullable, nonatomic, copy) NSURL *artworkUrl60;

@property (nullable, nonatomic, copy) NSURL *artworkUrl100;

@property (nullable, nonatomic, copy) NSURL *artworkUrl600;

@property (nonatomic, copy) NSString *collectionExplicitness;

@property (nonatomic, copy) NSString *primaryGenreName;

@property (nonatomic, copy) NSArray<NSString *> *genreIds;

@property (nonatomic, copy) NSArray<NSString *> *genres;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *link;

@property (nonatomic, copy) NSString *descriptionText;

@property (nullable, nonatomic, copy) NSString *language;

@property (nullable, nonatomic, copy) NSString *copyright;

@property (nullable, nonatomic, copy) NSString *managingEditor;

@property (nullable, nonatomic, copy) NSString *webMaster;

@property (nullable, nonatomic, copy) NSDate *pubDate;

@property (nullable, nonatomic, copy) NSDate *lastBuildDate;

@property (nullable, nonatomic, copy) NSArray<NSString *> *categories;

@property (nullable, nonatomic, copy) NSString *generator;

@property (nullable, nonatomic, copy) NSString *docs;

@property (nullable, nonatomic, copy) Cloud *cloud;

@property (nullable, nonatomic, copy) NSString *rating;

@property (nonatomic) NSNumber *ttl;

@property (nullable, nonatomic, copy) NSURL *image;

@property (nullable, nonatomic, copy) NSArray<Episode *> *items;

@property (nullable, nonatomic, copy) ITunesNamespace *iTunes;

@property (nullable, nonatomic, copy) NSArray<NSNumber *> *rawSkipDays;

@property (nullable, nonatomic, copy) TextInput *textInput;

@property (nullable, nonatomic, copy) NSArray<NSNumber *> *skipHours;

- (void)combineWithPodcast:(id<PartialPodcast>)partialPodcast;

+ (SkipDay)skipDayFromString:(NSString *)string;

@end

