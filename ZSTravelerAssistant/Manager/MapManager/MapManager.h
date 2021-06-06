//
//  MapManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-21.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "MapManagerDelegate.h"
#import "NavProcessingCenter.h"
#import "LoactionRegulation.h"
@interface MapManager : NSObject<CLLocationManagerDelegate,NavProcessingCenterDelegate>
{
    NSMutableDictionary *scenicCache;// 三大景区、钟山风景区 缓冲区
    
    CLLocationManager* locationManager;
    
    NSMutableArray *mapManagerNotifications;
    
    NavProcessingCenter *navCenter;
    LoactionRegulation *loctaionRegulation;
    

}
@property(nonatomic,readonly) SCENIC_TYPE currentScenic;
@property(nonatomic,readonly) CLLocationCoordinate2D oldLocation2D;
@property(nonatomic,readonly) double altitude;//海拔高度
@property(nonatomic,readonly) double oldHorizontalAccuracy;//精细度
@property(nonatomic,readonly) double magneticHeading;
@property(nonatomic,readonly) double trueHeading;
@property(nonatomic,readonly) double headingAccuracy;
@property(nonatomic,retain)   NSMutableArray *hasSpeaked;
+(MapManager*)sharedInstanced;
+(void)freeInstance;


- (void)startLocation;
- (void)stopLocation;
- (void)cleanLocation;
- (void)startUpdateHeading;
- (void)stopUpdateHeading;
/**
 *  currentScenic 获取当前所在区域
 *  point : 结构化类型 x 精度 y 纬度
 */
- (SCENIC_TYPE)currentScenic:(AGSPoint*)locationPoint;

- (void)registerMapManagerNotification:(id<MapManagerDelegate>)delegate;
- (void)unRegisterMapManagerNotification:(id<MapManagerDelegate>)delegate;



//主动弹出callout
- (void)didShowCallout2Spot:(NSString*)spotName;
- (void)didShowCallout2Spot:(NSString*)spotName withPoint:(AGSPoint *)point;
- (void)didShowCallout2POI:(NSString*)poiName withPoint:(AGSPoint *)point;

- (void)didShowNavLine:(NSArray*)points withType:(NAV_TYPE)type;
- (void)cancelRequestNavCenter;

//endpoi  POIPoint
- (void)startNavByOne:(id)endPoi withType:(NAV_TYPE)navType simulation:(BOOL)simulation withBarriers:(NSString*)Barriers;
- (void)startNavByMany:(NSArray*)pois withType:(NAV_TYPE)navType simulation:(BOOL)simulation withBarriers:(NSString*)Barriers;
- (void)startNav:(NSArray*)pois withType:(NAV_TYPE)navType withBarriers:(NSString*)Barriers;
- (void)stopNav;
@end
