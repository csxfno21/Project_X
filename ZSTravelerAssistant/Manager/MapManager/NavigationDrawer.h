//
//  NavigationDrawer.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-12.
//  Copyright (c) 2013年 company. All rights reserved.
//
/**
 * 线路预览 画线
 *
 */
#import <Foundation/Foundation.h>

@interface NavigationDrawer : NSObject<AGSInfoTemplateDelegate>
{
    AGSGraphicsLayer *layer;//图层
    AGSMapView *contentView;
}
- (id)initWithMapView:(AGSMapView*)mapView;
- (void)drawLineWith:(AGSPolyline*)line withPoints:(NSArray*)point withType:(NAV_TYPE)type;
- (void)clearGraphic;
@end

@interface NavPoiTemplateDelegate : NSObject<AGSInfoTemplateDelegate>

@end
