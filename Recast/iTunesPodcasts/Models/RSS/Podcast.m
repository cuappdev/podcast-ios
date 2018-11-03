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

//@synthesize collectionId;
//@synthesize feedUrl;
//@synthesize artistName;
//@synthesize collectionName;
//@synthesize artworkUrl30;
//@synthesize artworkUrl60;
//@synthesize artworkUrl100;
//@synthesize artworkUrl600;
//@synthesize collectionExplicitness;
//@synthesize primaryGenreName;
//@synthesize genreIds;
//@synthesize genres;
//@synthesize title;
//@synthesize link;
//@synthesize descriptionText;
//@synthesize language;
//@synthesize copyright;
//@synthesize managingEditor;
//@synthesize webMaster;
//@synthesize pubDate;
//@synthesize lastBuildDate;
//@synthesize categories;
//@synthesize generator;
//@synthesize docs;
//@synthesize cloud;
//@synthesize rating;
//@synthesize ttl;
//@synthesize image;
//@synthesize items;
//@synthesize iTunes;
//@synthesize rawSkipDays;
//@synthesize textInput;
//@synthesize skipHours;

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
