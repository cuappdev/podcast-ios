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

@interface ITunesNamespace : NSManagedObject

@property (nullable, nonatomic, copy) NSString *author;

@property (nullable, nonatomic, copy) NSString *block;

@property (nullable, nonatomic, copy) NSArray<ITunesCategory *> *categories;

@property (nullable, nonatomic, copy) NSURL *image;

@property (nonatomic) NSNumber *duration;

@property (nonatomic, assign) BOOL explicit;

@property (nonatomic, assign) BOOL isClosedCaptioned;

@property (nonatomic) NSNumber *order;

@property (nullable, nonatomic, copy) NSString *complete;

@property (nullable, nonatomic, copy) NSString *theNewFeedUrl;

@property (nullable, nonatomic, copy) ITunesOwner *owner;

@property (nullable, nonatomic, copy) NSString *subtitle;

@property (nullable, nonatomic, copy) NSString *summary;

@property (nullable, nonatomic, copy) NSString *keywords;

@property (nonatomic) PodcastType type;

@property (nonatomic) EpisodeType episodeType;

@property (nonatomic) NSNumber *season;

@property (nonatomic) NSNumber *episode;

+ (PodcastType)initPodcastTypeWithRawValue:(NSString *)rawValue;
+ (EpisodeType)initEpisodeTypeWithRawValue:(NSString *)rawValue;

@end
