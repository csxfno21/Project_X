//
//  ZS_CommonNav.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZS_CommonNav_entity.h"
#import "ZS_PoiRelation_entity.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "SQLConstans.h"


typedef enum
{
    POI_SCENIC = 0,
    POI_SPOT    = 1,            //景点
    POI_TOTLITE,                //洗手间
    POI_SHOP,                   //商店
    POI_PARK,                   //停车场
    POI_SAIL,                   //售票
    POI_SIGHT_SEE,              //观光车
    POI_REPAST,                 //餐饮
    POI_BUS,                    //公共交通
    POI_TRAVEL_CENTER,          //游客中心
    POI_TEL_BOOTH,              //电话亭
    POI_BEST_PHOTO = 13,        //最佳拍照点
    POI_EXPORT_L,               //出口 通往景区外
    POI_ENTRANCE,               //人口 景区内入口
    POI_EXPORT = 17,            //出口 景区内出口
    POI_SPOT_BUS = 62,          //景区巴士
    POI_PARK_IN =41,            //停车场 入口
    POI_PARK_OUT,               //停车场 出口
    POI_OTHE = -1,              //其它
}POI_TYPE;
@interface ZS_CommonNavModel : NSObject

-(NSArray *)quaryAllCommonNav;
- (BOOL)updatePoiInfo:(NSArray*)data;
- (NSArray*)quaryAllPoi:(int)spotID withType:(NSArray*)args;
- (ZS_CommonNav_entity*)getPOI:(int)poiID;
- (NSString*)getPOITypeByID:(int)poiID;
- (ZS_PoiRelation_entity*)getPOIRelationPoiID:(int)parkInID;
- (NSArray*)getPOIRelationInfo:(int)parnentID;
- (NSString*)getParkBufferByID:(int)ID;
- (BOOL)updatePOIRelationInfo:(NSArray*)data;
- (BOOL)isPark:(int)ID;
@end
