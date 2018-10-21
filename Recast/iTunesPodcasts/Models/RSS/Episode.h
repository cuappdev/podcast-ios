//
//  Episode.h
//  Recast
//
//  Created by Mindy Lou on 10/21/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "iTunesNamespace.h"

@class DownloadInfo;
@class Enclosure;
@class ItemSource;

@interface Episode : NSManagedObject

@property (nullable, nonatomic, copy) NSString *title;

@property (nullable, nonatomic, copy) NSString *link;

@property (nullable, nonatomic, copy) NSString *descriptionText;

@property (nullable, nonatomic, copy) NSString *author;

@property (nullable, nonatomic, copy) NSArray<NSString *> *categories;

@property (nullable, nonatomic, copy) NSString *comments;

@property (nullable, nonatomic, copy) Enclosure *enclosure;

@property (nullable, nonatomic, copy) NSString *guid;

@property (nullable, nonatomic, copy) NSDate *pubDate;

@property (nullable, nonatomic, copy) ItemSource *source;

@property (nullable, nonatomic, copy) NSString *content;

@property (nullable, nonatomic, copy) ITunesNamespace *iTunes;

@property (nullable, nonatomic, copy) DownloadInfo *downloadInfo;

@property (nullable, nonatomic, copy) NSURL *audioURL;

@end
