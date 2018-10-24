//
//  Podcast.m
//  Recast
//
//  Created by Mindy Lou on 10/21/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Podcast.h"

@protocol PartialPodcast;

@interface Podcast () <PartialPodcast>

@end

@implementation Podcast

@dynamic collectionId;
@dynamic feedUrl;
@dynamic artistName;
@dynamic collectionName;
@dynamic artworkUrl30;
@dynamic artworkUrl60;
@dynamic artworkUrl100;
@dynamic artworkUrl600;
@dynamic collectionExplicitness;
@dynamic primaryGenreName;
@dynamic genreIds;
@dynamic genres;
@dynamic title;
@dynamic link;
@dynamic descriptionText;
@dynamic language;
@dynamic copyright;
@dynamic managingEditor;
@dynamic webMaster;
@dynamic pubDate;
@dynamic lastBuildDate;
@dynamic categories;
@dynamic generator;
@dynamic docs;
@dynamic cloud;
@dynamic rating;
@dynamic ttl;
@dynamic image;
@dynamic items;
@dynamic iTunes;
@dynamic rawSkipDays;
@dynamic textInput;
@dynamic skipHours;

- (void)combineWithPodcast:(id<PartialPodcast>)partialPodcast {

}

+ (SkipDay)skipDayFromString:(NSString *)string {
    if ([string isEqualToString:@"monday"]) {
        return monday;
    } else if ([string isEqualToString:@"tuesday"]) {
        return tuesday;
    } else if ([string isEqualToString:@"wednesday"]) {
        return wednesday;
    } else if ([string isEqualToString:@"thursday"]) {
        return thursday;
    } else if ([string isEqualToString:@"friday"]) {
        return friday;
    } else if ([string isEqualToString:@"saturday"]) {
        return saturday;
    } else {
        return sunday;
    }
}

@end
