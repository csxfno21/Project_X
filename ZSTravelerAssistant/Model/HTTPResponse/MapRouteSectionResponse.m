//
//  MapRouteSectionResponse.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-29.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "MapRouteSectionResponse.h"

@implementation MapRouteSectionResponse
@synthesize routeFeatures,isRunned;
- (id)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        self.routeFeatures = array;
        SAFERELEASE(array)
    }
    return self;
}
- (void)dealloc
{
    SAFERELEASE(routeFeatures)
    [super dealloc];
}
@end


@implementation Section
@synthesize routeSection,sectionAttributes,isRunned;
- (id)init
{
    self = [super init];
    if (self)
    {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        self.sectionAttributes = array;
        SAFERELEASE(array)
    }
    return self;
}
+ (Section*)sectionWithRouteSection:(RouteSection*)route withAttributes:(NSArray*)attributes
{
    Section *section = [[[Section alloc] init] autorelease];
    if (route)
    {
        section.routeSection = route;
    }
    if (ISARRYCLASS(attributes))
    {
        [section.sectionAttributes addObjectsFromArray:attributes];
    }
    return section;
}
- (void)dealloc
{
    SAFERELEASE(routeSection)
    SAFERELEASE(sectionAttributes)
    [super dealloc];
}
@end

@implementation SectionAttribute
@synthesize action,length,text,pointArray,isSpeak,isPreSpeak;
- (id)init
{
    self = [super init];
    if (self)
    {
        self.action = esriDMTUnknown;//初始化动作状态
        NSMutableArray *array = [[NSMutableArray alloc] init];
        self.pointArray = array;
        SAFERELEASE(array)
    }
    return self;
}
+ (SectionAttribute*)attributeWithAction:(MAP_DIRECTION)ac withlength:(NSString*)l withText:(NSString*)t withPoints:(NSArray*)points
{
    SectionAttribute *sa = [[[SectionAttribute alloc] init] autorelease];
    sa.action = ac;
    sa.length = l;
    sa.text = t;
    
    if (ISARRYCLASS(points))
    {
        [sa.pointArray addObjectsFromArray:points];
    }
    return sa;
}
- (void)dealloc
{
    self.action = esriDMTUnknown;
    SAFERELEASE(pointArray)
    SAFERELEASE(length)
    SAFERELEASE(text)
    [super dealloc];
}
@end
