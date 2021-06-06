//
//  MapRouteNavResponse.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-12.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "MapRouteNavResponse.h"

@implementation MapRouteNavResponse
@synthesize routeId;
@synthesize routeName;
@synthesize totalLength;
@synthesize xmin;
@synthesize ymin;
@synthesize xmax;
@synthesize ymax;
@synthesize wkid;
@synthesize features;
@synthesize points;
- (id)init
{
    if (self = [super init])
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        self.features = array;
        SAFERELEASE(array)
        NSMutableArray *pointArray = [[NSMutableArray alloc] init];
        self.points = pointArray;
        SAFERELEASE(pointArray);
    }
    return self;
}

- (void)addFeature:(NSString*)text withRoute:(NSArray*)route withLength:(double)Length withDirection:(MAP_DIRECTION)direction
{
    Feature *feature = [[Feature alloc] init];
    feature.text = ReplaceNULL2Empty(text);
    feature.routePoints = route;
    feature.Length = Length;
    feature.direction = direction;
    [self.features addObject:feature];
    SAFERELEASE(feature)
}

- (void)dealloc
{
    SAFERELEASE(points)
    SAFERELEASE(features)
    SAFERELEASE(routeName)
    [super dealloc];
}

@end

@implementation Feature
@synthesize text,routePoints,Length,direction;

- (void)dealloc
{
    SAFERELEASE(routePoints)
    SAFERELEASE(text)
    [super dealloc];
}
@end
