//
//  iTunesNamespace.m
//  Recast
//
//  Created by Mindy Lou on 10/21/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iTunesNamespace.h"

@implementation ITunesNamespace

@dynamic author;
@dynamic block;
@dynamic categories;
@dynamic image;
@dynamic duration;
@dynamic explicit;
@dynamic isClosedCaptioned;
@dynamic order;
@dynamic complete;
@dynamic theNewFeedUrl;
@dynamic owner;
@dynamic subtitle;
@dynamic summary;
@dynamic keywords;
@dynamic type;
@dynamic episodeType;
@dynamic season;
@dynamic episode;

+ (PodcastType)initPodcastTypeWithRawValue:(NSString *)rawValue {
    if ([rawValue isEqualToString: @"episodic"]) {
        return episodic;
    } else if ([rawValue isEqualToString:@"serial"]) {
        return serial;
    } else if ([rawValue isEqualToString:@"episodic"]) {
        return episodic;
    }
    return NULL;
}

+ (EpisodeType)initEpisodeTypeWithRawValue:(NSString *)rawValue {
    if ([rawValue isEqualToString:@"full"]) {
        return full;
    } else if ([rawValue isEqualToString:@"trailer"]) {
        return trailer;
    } else if ([rawValue isEqualToString:@"bonus"]) {
        return bonus;
    }
    return NULL;
}

@end
