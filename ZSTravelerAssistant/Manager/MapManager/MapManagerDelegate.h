//
//  MapManagerDelegate.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-27.
//  Copyright (c) 2013年 company. All rights reserved.
//


#define  MAP_DIDLOAD_SCALE     9000 //地图初始化 比例

typedef enum
{
    NAV_TYPE_CAR = 0,
    NAV_TYPE_TOUR_CAR,
    NAV_TYPE_WALK,
    NAV_TYPE_UNKNOW = -1,
}NAV_TYPE;

typedef enum
{
    esriDMTUnknown = -1,
    esriDMTStop,
    esriDMTStraight,
    esriDMTBearLeft,
    esriDMTBearRight,
    esriDMTTurnLeft,
    esriDMTTurnRight,
    esriDMTSharpLeft,
    esriDMTSharpRight,
    esriDMTUTurn,
    esriDMTFerry,
    esriDMTRoundabout,
    esriDMTHighwayMerge,
    esriDMTHighwayExiT,
    esriDMTHighwayChange,
    esriDMTForkCenter,
    esriDMTForkLeft,
    esriDMTForkRight,
    esriDMTDepart,
    esriDMTTripItem,
    esriDMTEndOfFerry,
}MAP_DIRECTION;

#import <CoreLocation/CoreLocation.h>
#import "ZS_Scenic_Buffer_Model.h"
#ifndef ZSTravelerAssistant_MapManagerDelegate_h
#define ZSTravelerAssistant_MapManagerDelegate_h

@protocol MapManagerDelegate <NSObject>
@optional
- (void)didUpdateToLocation:(id)newLocation fromLocation:(id)oldLocation;   //0
- (void)didUpdateError:(NSError *)error;                                                        //1
- (void)didUpdateHeading:(CLHeading *)newHeading;                                               //2

//当前所在 景区
- (void)didUpdateCurrentSenic:(SCENIC_TYPE)scenic;                                              //3


//定位弹出 callout
- (void)didShowCallout2Spot:(NSString*)spotName;                                                //4
- (void)didShowCallout2Spot:(NSString *)spotName withPoint:(AGSPoint*)point;                    //5
- (void)didShowCallout2POI:(NSString *)poiName withPoint:(AGSPoint*)point;                      //6


//线路  导航
- (void)didNavLine:(id)line withEnvelope:(id)envelope withPoints:(NSArray*)points withType:(NAV_TYPE)type;
- (void)didNavLineFailed:(NAV_TYPE)type;

- (void)centerNavLine:(NSArray*)graphics;
- (void)clearCenterNavLine;
- (void)reViewMapView;
- (void)viewNavMapView;
- (void)realNavigation;
- (void)simulation:(double)lon withLat:(double)lat;

- (void)changeTarget:(NSString*)currentTarget;//当前目标的信息显示
- (void)changeDis:(double)targetDis TurnDis:(double)turnDis;//下一个目标的信息显示
- (void)changeDirections:(MAP_DIRECTION)orientation;

@end
#endif
