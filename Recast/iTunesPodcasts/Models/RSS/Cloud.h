//
//  Cloud.h
//  
//
//  Created by Mindy Lou on 10/14/18.
//

#import <CoreData/CoreData.h>

@interface Cloud : NSManagedObject

@property (nullable, nonatomic, copy) NSString *domain;
@property (nonatomic) NSNumber *port;
@property (nullable, nonatomic, copy) NSString *path;
@property (nullable, nonatomic, copy) NSString *registerProcedure;
@property (nullable, nonatomic, copy) NSString *protocolSpecification;

- (instancetype)initWithAttributes:(NSDictionary<NSString *, NSString *> *)attributes;

@end
