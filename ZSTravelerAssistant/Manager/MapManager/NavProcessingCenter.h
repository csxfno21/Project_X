//
//  NavProcessingCenter.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-12.
//  Copyright (c) 2013年 company. All rights reserved.
//

/**
 *
 * 路径 处理类 ，包含 请求发送、接受、导航逻辑处理、偏移处理、抛出
 */
@protocol NavProcessingCenterDelegate <NSObject>

- (void)centeravLine:(id)line withEnvelope:(id)envelope withPoints:(NSArray*)points withType:(int)type;
- (void)centerFailed:(int)navType;

@optional
- (void)centerNavLine:(NSArray*)graphics;//画从服务器回来的导航路线
- (void)clearCenterNavLine;//清除导航路线
- (void)viewNavMapView;//显示导航UI
- (void)reViewMapView;//去除导航UI
- (void)simulation:(double)lon withLat:(double)lat;
- (void)realNavigation;
- (void)changeTarget:(NSString*)currentTarget;//当前目标的信息显示
- (void)changeDis:(double)targetDis TurnDis:(double)turnDis;//下一个目标的信息显示
- (void)changeDirections:(MAP_DIRECTION)orientation;
@end
#import <Foundation/Foundation.h>
#import "RouteStructFactory.h"
#import "PoiPoint.h"
@interface NavProcessingCenter : NSObject<HttpManagerDelegate,MapManagerDelegate>
{
    id<NavProcessingCenterDelegate> delegate;
    RouteStructFactory *routeStructFactory;
    NSMutableArray* simulationPts;
    int simulationPtsIndex;     //模拟导航时，当前feature上点的索引
    NAV_TYPE lastNavType;       //当前路段的出行方式
    PoiPoint* lastPt;       //当前feature上的第一个点(作为偏航时障碍点)
    BOOL bIsNavStop;        //导航状态，为Yes时表示正在景区内游玩/停车场逗留，此时不进行导航操作
    int nLastPOIID;           //记录上一个目的地的POIID；
    int poiType;        //当前目标点的Poi类型
    NSMutableArray *testArray;

}

@property(nonatomic,readonly) NSMutableArray *navData;   //放导航队列
@property(nonatomic,assign)id<NavProcessingCenterDelegate> delegate;
@property(nonatomic,assign) int simulationPtsIndex;
/*
 * 请求 步行 路线  Points poi 点数组 PoiPoint
 */
- (void)requestWalkRoute:(NSArray*)points;

/*
 * 请求 自驾 路线  Points poi 点数组 PoiPoint
 */
- (void)requestCarRoute:(NSArray*)points;

/*
 * 请求 游览车 路线  Points poi 点数组 PoiPoint
 */
- (void)requestTourCarRoute:(NSArray*)points;



/*
 * 请求 路线  Points endPoi 目的地 int navType 导航类型
 */
- (void)requestNavTo:(NSArray*)pois withType:(int)navType withSimulation:(BOOL)simulation withBarriers:(NSString*)Barriers;

- (void)cancelRrequest:(id)delegate;

- (void)stopNav;

@end

@interface NavProcessingData : NSObject
{
    id  runningRouteSection;
    NSMutableArray *navPoints;
    BOOL simulation;
    int navType;
    BOOL isInsertedPOI;
}
@property(nonatomic,assign)int navType;
@property(nonatomic,assign)BOOL simulation;
@property(nonatomic,retain)id  runningRouteSection;
@property(nonatomic,retain)NSMutableArray* navPoints;
@property(nonatomic,assign)BOOL isInsertedPOI;
@end
