//
//  LocationPoint.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-28.
//  Copyright (c) 2013年 company. All rights reserved.
//
/**
 * 定位点 绘制类
 *
 */

@protocol LocationPointDelegate <NSObject>

- (void)loctationPointHeading:(double)angle;
- (void)loctationPointScale;
@end
typedef enum
{
    LOCATION_NO = 0,    //没有开始定位
    LOCATION_POINT_ROTATE = 10,
    LOCATION_MAP_ROTATE,
    LOCATION_DEFAULT,
}LOCATION_TYPE;
#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "MapManager.h"
@interface LocationPoint : NSObject<MapManagerDelegate>
{
    AGSGraphicsLayer *layer;//图层
    AGSGraphic *locationGr;//定位点 实体
    AGSPictureMarkerSymbol *sumbol;
    
    AGSGraphic *lineGr;//线 实体
    
    AGSGraphic *fillBuffGr;//定位精准误差图层
    AGSSimpleFillSymbol *fillsymbol;
    
    AGSMapView *contentMap;
    id<LocationPointDelegate> delegate;
    
    
    AGSGraphic *simulationGr;
}
@property(nonatomic,assign)id<LocationPointDelegate> delegate;
@property(nonatomic,assign)LOCATION_TYPE rotateType;
- (void)startLocation;
- (void)stopLoctation;
- (id)initWithMapView:(AGSMapView*)mapView;
- (void)setSimulationPoint:(double)lon withLat:(double)lat;
- (void)unVisableSimulationPoint;
@end
