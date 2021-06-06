//
//  NavCenterLineDrawer.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-10-10.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavCenterLineDrawer : NSObject<MapManagerDelegate>
{
    AGSGraphicsLayer *layer;//图层
    AGSMapView *contentView;
}
- (id)initWithMapView:(AGSMapView*)mapView;
- (void)drawLineWith:(NSArray*)graphics;//在图层上画线，点
- (void)clearGraphic;
- (void)registerMapManagerNotification;
- (void)unRegisterMapManagerNotification;
@end
