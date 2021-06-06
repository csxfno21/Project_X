//
//  MapRouteSectionResponse.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-29.
//  Copyright (c) 2013年 company. All rights reserved.
//

/**
 *  导航路段返回结构
 *
 */
#import "httpBaseResponse.h"

@interface MapRouteSectionResponse : HttpBaseResponse
{
    BOOL isRunned;//已经走完
    NSMutableArray *routeFeatures;
}
@property(nonatomic)BOOL isRunned;//已经走完
@property(nonatomic,retain)NSMutableArray *routeFeatures;
@end

/**
 * 路段
 */
@interface Section : NSObject
{
    BOOL isRunned;//已经走完
    RouteSection *routeSection;//大路段
    NSMutableArray *sectionAttributes;//小路段
}
@property(nonatomic)BOOL isRunned;//已经走完
@property(nonatomic,retain)RouteSection *routeSection;//大路段
@property(nonatomic,retain)NSMutableArray *sectionAttributes;//小路段
+ (Section*)sectionWithRouteSection:(RouteSection*)route withAttributes:(NSArray*)attributes;
@end

/**
 * 小路段
 */
@interface SectionAttribute : NSObject
{
    BOOL isRunned;//已经走完
    MAP_DIRECTION action;//该小路段的动作
    NSString *length;//该小路段的长度
    NSString *text;//路段行驶描述
    NSMutableArray *pointArray;//小路段点  存放 PoiPoint
}
@property(nonatomic)BOOL isSpeak;//路口播报
@property(nonatomic)BOOL isPreSpeak;//路口预播报
@property(nonatomic,assign)MAP_DIRECTION action;//该小路段的动作
@property(nonatomic,retain)NSString *length;//该小路段的长度
@property(nonatomic,retain)NSString *text;//路段行驶描述
@property(nonatomic,retain)NSMutableArray *pointArray;//路段行驶描述
+ (SectionAttribute*)attributeWithAction:(MAP_DIRECTION)ac withlength:(NSString*)l withText:(NSString*)t withPoints:(NSArray*)points;
@end
