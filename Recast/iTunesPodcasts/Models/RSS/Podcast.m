//
//  Podcast.m
//  Recast
//
//  Created by Mindy Lou on 10/21/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Podcast.h"

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

- (void)combineWithPodcast:(id<PartialPodcast>)podcast {
    self.collectionId = podcast.collectionId;
    self.feedUrl = podcast.feedUrl;
    self.artistName = podcast.artistName;
    self.collectionName = podcast.collectionName;
    self.artworkUrl30 = podcast.artworkUrl30;
    self.artworkUrl60 = podcast.artworkUrl60;
    self.artworkUrl100 = podcast.artworkUrl100;
    self.artworkUrl600 = podcast.artworkUrl600;
    self.collectionExplicitness = podcast.collectionExplicitness;
    self.primaryGenreName = podcast.primaryGenreName;
    self.genreIds = podcast.genreIds;
    self.genres = podcast.genres;
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
    } else if ([string isEqualToString:@"sunday"]) {
        return sunday;
    }
    return NULL;
}

@end
