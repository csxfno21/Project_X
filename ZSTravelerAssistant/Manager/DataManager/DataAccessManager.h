//
//  DataAccessManager.h
//  Tourism
//
//  Created by csxfno21 on 13-7-10.
//  Copyright (c) 2013年 csxfno21. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapManager.h"
#import "ZS_TableVersion.h"
#import "ZS_RecommendModel.h"
#import "ZS_InfomationModel.h"
#import "ZS_TrafficModel.h"
#import "ZS_SpotRouteModel.h"
#import "ZS_SpotModel.h"
#import "ZS_CommonNavModel.h"
#import "ZS_SpotSpeakModel.h"
#import "ZS_Scenic_Buffer_Model.h"
#import "ZS_TeamChat_Model.h"
#import "ZS_TeamGroupChat_Model.h"
#import "ZS_TeamSingleChat_Model.h"

@interface DataAccessManager : NSObject
{
    ZS_TableVersion *tableVersion;
    
    ZS_RecommendModel *recommendModel;
    ZS_InfomationModel *infoMationModel;
    ZS_TrafficModel *trafficModel;
    ZS_SpotRouteModel *spotRouteModel;
    ZS_SpotModel      *spotModel;
    ZS_CommonNavModel *commModel;
    ZS_SpotSpeakModel *speakModel;
    ZS_Scenic_Buffer_Model *scenicModel;
    
    ZS_TeamChat_Model *teamChatModel;
    ZS_TeamGroupChat_Model *groupChatModel;
    ZS_TeamSingleChat_Model *singleChatMode;
}
+(DataAccessManager *)sharedDataModel;
-(NSArray *)getVersion;
- (BOOL)updateTableVersion:(NSString*)tableName withVersion:(NSString*)version;


- (NSArray *)getAllRecommend;
- (BOOL)updateRecommend:(NSArray *)data;

- (NSArray*)getAllSeasonInfo;
- (NSArray*)getAllRecentlyInfo;
- (BOOL)updateInfo:(NSArray*)data;

- (NSArray*)getAllBusInfo;
- (NSArray*)getAllTourisCarInfo;
- (BOOL)updateTrafficInfo:(NSArray*)data;


- (NSArray*)getAllThemRoute;
- (NSArray*)getAllCommonRoute;
- (BOOL)updateRouteInfo:(NSArray*)data;


- (NSArray*)getAllSpot;
- (NSArray*)getViewSpot;
- (NSArray *)getNViewSpot;
- (id)getSpotByName:(NSString*)spotName;
- (id)getSpotBySpotID:(NSString *)spotID;
- (BOOL)updateSpotInfo:(NSArray *)data;
- (NSArray *)getSpotsDetailByIDs:(NSArray*)ids;
- (NSString*) getSpotBufferByID:(int)ID;

- (NSArray*)getAllCommonNav;
- (BOOL)updatePoiInfo:(NSArray *)data;
- (NSArray*)getLocationPoi:(POI_TYPE)type,...;
- (ZS_CommonNav_entity*)getPOI:(int)poiID;
- (NSString*)getPOITypeByID:(int)poiID;
- (NSArray*)getPOi:(int)spotID withPoiType:(POI_TYPE)type,...;

- (NSArray*)getPOIRelationInfo:(int)parnentID;
- (ZS_PoiRelation_entity*)getPOIRelationPoiID:(int)parkInID;
- (BOOL)updatePOIRelationInfo:(NSArray*)data;
- (NSString*)getParkBufferByID:(int)ID;

- (BOOL)updateSpeakInfo:(NSArray *)data;
- (NSArray*)getAllSpotSpeak;
- (NSArray*)getSpotSpeakByType:(SCENIC_TYPE)type;
-(NSString *)getSpeakSpotContent:(int)SpotID;

- (NSArray*)getSpeakContentByType:(SCENIC_TYPE)type;
- (ZS_Scenic_Buffer_entity*)getBufferByType:(SCENIC_TYPE)type;
- (BOOL)updateScenicInfo:(NSArray*)data;
- (BOOL)isScenic:(int)ID;
- (BOOL)isPark:(int)ID;

-(NSArray *)quaryAllTeamChat;
-(ZS_TeamChat_entity *)quaryTeamChatByID:(int)ID;
-(BOOL)updateTeamChat:(NSArray*)data;

-(NSArray*)quaryAllGroupChat;
-(ZS_TeamGroupChat_entity*)quaryGropuChatByID:(int)ID;
-(BOOL)updateGroupChat:(NSArray*)data;

-(NSArray*)quaryAllSingleChat;
-(ZS_TeamSingleChat_entity *)quraySingleChatByID:(int)ID;
-(BOOL)updateSingleChat:(NSArray*)data;

@end
