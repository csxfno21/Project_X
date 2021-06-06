//
//  PoiPoint.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "PoiPoint.h"

@implementation PoiPoint
@synthesize name,longitude,latitude,poiID;
+(id)pointWithName:(NSString*)name withLongitude:(double)longitude withLatitude:(double)latitude
{
    PoiPoint * point = [[[PoiPoint alloc] init] autorelease];
    point.name = name;
    point.longitude = longitude;
    point.latitude = latitude;
    return point;
}
+(id)pointWithName:(NSString*)name withLongitude:(double)longitude withLatitude:(double)latitude withPoiID:(int)poiID
{
    PoiPoint * point = [[[PoiPoint alloc] init] autorelease];
    point.name = name;
    point.longitude = longitude;
    point.latitude = latitude;
    point.poiID = poiID;
    return point;
}
- (void)dealloc
{
    SAFERELEASE(name)
    [super dealloc];
}
@end

@implementation RouteSection
@synthesize startPoi,endPoi,navType;

+(id)sectionWithStartPoi:(PoiPoint*)start withEndPoi:(PoiPoint*)end withNavType:(int)navType
{
    RouteSection *section = [[[RouteSection alloc] init] autorelease];
    section.startPoi = start;
    section.endPoi = end;
    section.navType = navType;
    return section;
}
- (void)dealloc
{
    SAFERELEASE(startPoi)
    SAFERELEASE(endPoi)
    [super dealloc];
}
@end