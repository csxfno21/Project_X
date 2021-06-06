//
//  TextMarkDrawer.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-3.
//  Copyright (c) 2013年 company. All rights reserved.
//

/**
 *  注记绘制类
 */
@protocol TextMarkDrawerDelegate <NSObject>

- (void)textMarkDrawerCompleted;

@end
#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "CallOutDrawer.h"
@interface TextMarkDrawer : NSObject<AGSQueryTaskDelegate,AGSMapViewCalloutDelegate>
{
    AGSGraphicsLayer *layer;//图层
    AGSQueryTask   *textMarkTask;
    AGSMapView *conentView;
    
    int lastLevel;
    CallOutDrawer *callOutDrawer;
    id<TextMarkDrawerDelegate>  delegate;
    
    double lastAnagle;
}
@property(nonatomic,assign)id<TextMarkDrawerDelegate>  delegate;
@property(nonatomic,readonly)NSMutableArray *allTextMarkCache;
- (id)initWithMapView:(AGSMapView*)mapView;
- (void)requestTextMark;
- (void)drawTextMark:(int)scal;
- (void)rotateGraphicAngel:(double)angle;
@end
