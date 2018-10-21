//
//  Cloud.m
//  Recast
//
//  Created by Mindy Lou on 10/14/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Cloud.h"

@implementation Cloud

@dynamic domain;
@dynamic port;
@dynamic path;
@dynamic registerProcedure;
@dynamic protocolSpecification;

- (instancetype)initWithAttributes:(NSDictionary<NSString *,NSString *> *)attributes {
    self = [super init];
    if (self) {
        self.domain = attributes[@"domain"];
        self.port = [NSNumber numberWithInteger:[attributes[@"port"] integerValue]];
        self.path = attributes[@"path"];
        self.registerProcedure = attributes[@"registerProcedure"];
        self.protocolSpecification = attributes[@"protocolSpecification"];
    }

    return self;
}

@end
