//
//  CallOutDrawer.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

/**
 * callout 绘制类
 * 负责绘制弹出并分发点击事件、处理分层绘制逻辑
 */
#import <Foundation/Foundation.h>

@interface CallOutDrawer : NSObject<AGSQueryTaskDelegate,AGSMapViewCalloutDelegate>
{
    AGSGraphicsLayer *layer;
    NSMutableArray *allCallOutGaphicCache;
    AGSQueryTask *callOutGraphicTask;
    int lastLevel;
    AGSMapView *contentView;
}
- (id)initWithMapView:(AGSMapView*)mapView;
- (void)drawCallOutGraphic:(int)scal;
- (id)infoTemplate:(NSString*)title;
- (UIView*)infoView:(NSString*)title;
- (UIView*)poiView:(NSString*)title;
@end
@interface MapCallOutView : UIView
{
    UIButton *spotspeak;
    UILabel *infoTitlelabel;
    UIButton *spotsolve;
}

@property(nonatomic,retain)UILabel *infoTitlelabel;
-(void)setTitle:(NSString *)str;
- (void)setPoiTitle:(NSString *)str;
@end
