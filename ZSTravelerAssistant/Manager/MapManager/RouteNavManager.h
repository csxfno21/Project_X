//
//  RouteNavManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-11.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapRouteNavResponse.h"
#import "MapRouteSectionResponse.h"
#import "BaseRequestManager.h"
/**
 *
 * 请求路径
 */
@interface RouteNavManager : BaseRequestManager
{

}
+ (RouteNavManager*)sharedInstance;
- (void)requestWalkRoute:(id)UIDelegate withPOIRect:(NSArray*)points;
- (void)requestCarRoute:(id)UIDelegate withPOIRect:(NSArray*)points;
- (void)requestTourCarRoute:(id)UIDelegate withPOIRect:(NSArray*)points;
- (void)requestRoute:(id)UIDelegate withSections:(NSArray *)sections withNavType:(NAV_TYPE)type withBarriers:(NSString*)Barriers;
@end


