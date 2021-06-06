//
//  TableVersionManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-9.
//  Copyright (c) 2013年 company. All rights reserved.
//


#import "TableVersionManager.h"
#import "JSON.h"
#import "CommonNavManager.h"
#import "InfoMationManager.h"
#import "RecommendIngManager.h"
#import "SpotManager.h"
#import "SpotRouteManager.h"
#import "TrafficManager.h"
#import "SpotSpeakContentManager.h"
#import "POIRelationManager.h"
#import "ScenicManager.h"
static TableVersionManager *manager;
@interface TableVersionManager(Private)
- (void)requestUpdateTableData:(NSString*)tableName withMoreID:(int)moreID;
@end

@implementation TableVersionManager

+(TableVersionManager *)sharedInstance
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[TableVersionManager alloc] init];
        }
    }
    return manager;
}
- (id)init
{
    
    if (self = [super init])
    {
        needUpdateTables = [[NSMutableDictionary alloc] init];
    }
    return self;
}
+(void)freeInstance
{
    SAFERELEASE(manager);
}
+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (manager == nil)
        {
            manager = [super allocWithZone:zone];
            return manager;
        }
    }
    return nil;
}
- (id)retain
{
    return self;
}
- (id)autorelease
{
    return self;
}

- (void)dealloc
{
    SAFERELEASE(needUpdateTables)
    [super dealloc];
}
#pragma mark - Request

/**
 * 检查数据表是否更新
 * (id) uidelegate 观察者指针
 */
- (void)requestCheckVersion:(id)UIDelegate
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestCheckVersion Error,UIDelegate can not be nil!");
        return;
    }
    NSArray *tableArray = [[DataAccessManager sharedDataModel] getVersion];
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_CHECK_TABLE_VERSION;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_CHECK_TABLE_VERSION];
    
    //JSON 结构
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (ZS_TableVersion_entity *entity in tableArray)
    {
        NSMutableDictionary *dic = [[[NSMutableDictionary alloc] init] autorelease];
        [dic setObject:entity.tableName forKey:@"tbName"];
        [dic setObject:entity.tableVersion forKey:@"tbVersion"];
        [array addObject:dic];
    }
    [postData setObject:array forKey:@"VersionList"];
    [array release];
    
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *dataString  = [writer stringWithObject:postData];
    NSData *requestData = [[[NSData alloc]initWithBytes:[dataString UTF8String] length:strlen([dataString UTF8String])] autorelease];
    request.postData = requestData;
    [postData release];
    [writer release];
    
    [[ASIUtil sharedInstance] POSTRequest:request];
    [request release];
}

/**
 * 私有函数，更新表数据
 * tableName  需要更新的表名  moreID 当首次获取时为空，之后为更多的ID
 */
- (void)requestUpdateTableData:(NSString*)tableName withMoreID:(int)moreID
{
    if([@"t_recommendimg" isEqualToString:tableName])
    {
        [[RecommendIngManager sharedInstance] requestGetMianScrolSpots:self];
    }
    else if([@"t_poi" isEqualToString:tableName])
    {
        [[CommonNavManager sharedInstance] requestGetPoi:self withInfoID:moreID];
    }
    else if([@"t_information" isEqualToString:tableName])
    {
        [[InfoMationManager sharedInstance] requestGetInfo:self withInfoID:moreID];
    }
    else if([@"t_spot" isEqualToString:tableName])
    {
        [[SpotManager sharedInstance] requestGetSpot:self withInfoID:moreID];
    }
    else if([@"t_spotroute" isEqualToString:tableName])
    {
        [[SpotRouteManager sharedInstance] requestGetRoute:self withInfoID:moreID];
    }
    else if([@"t_traffic" isEqualToString:tableName])
    {
        [[TrafficManager sharedInstance] requestGetTraffic:self withInfoID:moreID];
    }
    else if([@"t_speakcontent" isEqualToString:tableName])
    {
        [[SpotSpeakContentManager sharedInstance] requestGetSpeakData:self withInfoID:moreID];
    }
    else if([@"t_scenic" isEqualToString:tableName])
    {
        [[ScenicManager sharedInstance] requestGetScenicData:self];
    }
    else if([@"t_poirelation" isEqualToString:tableName])
    {
        [[POIRelationManager sharedInstance] requestGetPoiRelation:self withInfoID:moreID];
    }
}

#pragma mark - calBack
- (void)callBackToUI:(HttpBaseResponse *)response
{
    switch (response.cc_cmd_code)
    {
        case CC_GET_MAIN_SCROL_SPOTS:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
               BOOL success = [[DataAccessManager sharedDataModel] updateRecommend:[RecommendIngManager sharedInstance].spotsCache];
               if(success)
               {
                    //更新版本控制表
                   ZS_TableVersion_entity *entity = [needUpdateTables objectForKey:@"t_recommendimg"];
                   if(entity)
                   {
                       [[DataAccessManager sharedDataModel] updateTableVersion:@"t_recommendimg" withVersion:entity.tableVersion];
                       [needUpdateTables removeObjectForKey:@"t_recommendimg"];
                       [RecommendIngManager sharedInstance].waitUpdate = NO;
                   }
                   
               }
            }
            break;
        }
        case CC_GET_INFO:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                ZS_TableVersion_entity *entity = [needUpdateTables objectForKey:@"t_information"];
                if([InfoMationManager sharedInstance].downLoadCache.count < entity.UpdataCount)
                {
                    ZS_Infomation_entity *infoEntity = [[InfoMationManager sharedInstance].downLoadCache lastObject];
                    [self requestUpdateTableData:@"t_information" withMoreID:infoEntity.ID];
                }
                else
                {
                    BOOL success = [[DataAccessManager sharedDataModel] updateInfo:[InfoMationManager sharedInstance].downLoadCache];
                    if(success)
                    {
                        [[DataAccessManager sharedDataModel] updateTableVersion:@"t_information" withVersion:entity.tableVersion];
                        [needUpdateTables removeObjectForKey:@"t_information"];
                        [InfoMationManager sharedInstance].waitUpdate = NO;
                    }
                }
            }
            break;
        }
        case CC_GET_TRAFFIC:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                ZS_TableVersion_entity *entity = [needUpdateTables objectForKey:@"t_traffic"];
                if([TrafficManager sharedInstance].downLoadCache.count < entity.UpdataCount)
                {
                    ZS_Traffic_entity *infoEntity = [[TrafficManager sharedInstance].downLoadCache lastObject];
                    [self requestUpdateTableData:@"t_traffic" withMoreID:infoEntity.ID];
                }
                else
                {
                    BOOL success = [[DataAccessManager sharedDataModel] updateTrafficInfo:[TrafficManager sharedInstance].downLoadCache];
                    if(success)
                    {
                        [[DataAccessManager sharedDataModel] updateTableVersion:@"t_traffic" withVersion:entity.tableVersion];
                        [needUpdateTables removeObjectForKey:@"t_traffic"];
                        [TrafficManager sharedInstance].waitUpdate = NO;
                    }
                }
            }
            break;
        }
        case CC_GET_ROUTE:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                ZS_TableVersion_entity *entity = [needUpdateTables objectForKey:@"t_spotroute"];
                if([SpotRouteManager sharedInstance].downLoadCache.count < entity.UpdataCount)
                {
                    ZS_SpotRoute_entity *infoEntity = [[SpotRouteManager sharedInstance].downLoadCache lastObject];
                    [self requestUpdateTableData:@"t_spotroute" withMoreID:infoEntity.ID];
                }
                else
                {
                    BOOL success = [[DataAccessManager sharedDataModel] updateRouteInfo:[SpotRouteManager sharedInstance].downLoadCache];
                    if(success)
                    {
                        [[DataAccessManager sharedDataModel] updateTableVersion:@"t_spotroute" withVersion:entity.tableVersion];
                        [needUpdateTables removeObjectForKey:@"t_spotroute"];
                        [SpotRouteManager sharedInstance].waitUpdate = NO;
                    }
                }
            }
            break;
        }
        case CC_GET_SPOT:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                ZS_TableVersion_entity *entity = [needUpdateTables objectForKey:@"t_spot"];
                if([SpotManager sharedInstance].downLoadCache.count < entity.UpdataCount)
                {
                    ZS_CustomizedSpot_entity *infoEntity = [[SpotManager sharedInstance].downLoadCache lastObject];
                    [self requestUpdateTableData:@"t_spot" withMoreID:infoEntity.ID];
                }
                else
                {
                    BOOL success = [[DataAccessManager sharedDataModel] updateSpotInfo:[SpotManager sharedInstance].downLoadCache];
                    if(success)
                    {
                        [[DataAccessManager sharedDataModel] updateTableVersion:@"t_spot" withVersion:entity.tableVersion];
                        [needUpdateTables removeObjectForKey:@"t_spot"];
                        [SpotManager sharedInstance].waitUpdate = NO;
                    }
                }
            }
            break;
        }
        case CC_GET_POI:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                ZS_TableVersion_entity *entity = [needUpdateTables objectForKey:@"t_poi"];
                if([CommonNavManager sharedInstance].downLoadCache.count < entity.UpdataCount)
                {
                    ZS_CommonNav_entity *infoEntity = [[CommonNavManager sharedInstance].downLoadCache lastObject];
                    [self requestUpdateTableData:@"t_poi" withMoreID:infoEntity.ID];
                }
                else
                {
                    BOOL success = [[DataAccessManager sharedDataModel] updatePoiInfo:[CommonNavManager sharedInstance].downLoadCache];
                    if(success)
                    {
                        [[DataAccessManager sharedDataModel] updateTableVersion:@"t_poi" withVersion:entity.tableVersion];
                        [needUpdateTables removeObjectForKey:@"t_poi"];
                        [CommonNavManager sharedInstance].waitUpdate = NO;
                    }
                }
            }
            break;
        }
        case CC_GET_SPEAK:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                ZS_TableVersion_entity *entity = [needUpdateTables objectForKey:@"t_speakcontent"];
                if([SpotSpeakContentManager sharedInstance].downLoadCache.count < entity.UpdataCount)
                {
                    ZS_SpotSpeak_Entity *infoEntity = [[SpotSpeakContentManager sharedInstance].downLoadCache lastObject];
                    [self requestUpdateTableData:@"t_speakcontent" withMoreID:infoEntity.ID];
                }
                else
                {
                    BOOL success = [[DataAccessManager sharedDataModel] updateSpeakInfo:[SpotSpeakContentManager sharedInstance].downLoadCache];
                    if(success)
                    {
                        [[DataAccessManager sharedDataModel] updateTableVersion:@"t_speakcontent" withVersion:entity.tableVersion];
                        [needUpdateTables removeObjectForKey:@"t_speakcontent"];
                        [SpotSpeakContentManager sharedInstance].waitUpdate = NO;
                    }
                }
            }
            break;
        }
        case CC_GET_SCENIC:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                ZS_TableVersion_entity *entity = [needUpdateTables objectForKey:@"t_scenic"];
                BOOL success = [[DataAccessManager sharedDataModel] updateScenicInfo:[ScenicManager sharedInstance].downLoadCache];
                if(success)
                {
                    [[DataAccessManager sharedDataModel] updateTableVersion:@"t_scenic" withVersion:entity.tableVersion];
                    [needUpdateTables removeObjectForKey:@"t_scenic"];
                    [ScenicManager sharedInstance].waitUpdate = NO;
                }

            }
            break;
        }
        case CC_GET_POI_RELATION:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                ZS_TableVersion_entity *entity = [needUpdateTables objectForKey:@"t_poirelation"];
                if([POIRelationManager sharedInstance].downLoadCache.count < entity.UpdataCount)
                {
                    ZS_PoiRelation_entity *infoEntity = [[POIRelationManager sharedInstance].downLoadCache lastObject];
                    [self requestUpdateTableData:@"t_poirelation" withMoreID:infoEntity.ID];
                }
                else
                {
                    BOOL success = [[DataAccessManager sharedDataModel] updatePOIRelationInfo:[POIRelationManager sharedInstance].downLoadCache];
                    if(success)
                    {
                        [[DataAccessManager sharedDataModel] updateTableVersion:@"t_poirelation" withVersion:entity.tableVersion];
                        [needUpdateTables removeObjectForKey:@"t_poirelation"];
                        [POIRelationManager sharedInstance].waitUpdate = NO;
                    }
                }
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark - http callback
- (void)reciveHttpRespondInfo:(HttpResponse *)response
{
    switch (response.cmdCode)
    {
        case CC_CHECK_TABLE_VERSION:
        {
            //判断请求是否成功
            _checkTableVersionSuccess = NO;
            
            HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
            base.cc_cmd_code = response.cmdCode;
            base.UIDelegate = response.UIDelegate;
            base.error_code = response.errorCode;
            if(base.error_code ==  E_HTTPSUCCEES)
            {
                if(response.data)
                {
                    NSString *result = [[NSString alloc] initWithData:response.data  encoding:NSUTF8StringEncoding];
                    NSLog(@"reciveHttpRespondInfo result %@",result);
                    SBJsonParser *jsonP = [[SBJsonParser alloc] init];
                    NSMutableDictionary *responsedic = [jsonP fragmentWithString:result];
                    if(ISDICTIONARYCLASS(responsedic))
                    {
                        
                       NSDictionary *versionInfoDic = [self getJSONContent:responsedic];
                        if (ISDICTIONARYCLASS(versionInfoDic))
                        {
                            NSArray *versionInfoArray = [versionInfoDic objectForKey:@"VersionInfo"];
                            if(ISARRYCLASS(versionInfoArray))
                            {
                                _checkTableVersionSuccess = YES;
                                [needUpdateTables removeAllObjects];
                                for (NSDictionary *entityDic in versionInfoArray)
                                {
                                    if([[entityDic objectForKey:@"IsNeedUpdate"] intValue] == 1)//需要更新
                                    {
                                        //TODO 判断哪张表 需要更新，在具体哪个manager里面 添加变量 isNeedUpdate 当获取需要更新表的数据时候，直接走网络.
                                        BaseRequestManager *manager = nil;
                                        NSString *tableName = ReplaceNULL2Empty([entityDic objectForKey:@"TableName"]);
                                        if([@"t_poi" isEqualToString:tableName])
                                        {
                                            manager = [CommonNavManager sharedInstance];
                                        }
                                        else if([@"t_infomation" isEqualToString:tableName])
                                        {
                                            manager = [InfoMationManager sharedInstance];
                                        }
                                        else if([@"t_recommendimg" isEqualToString:tableName])
                                        {
                                            manager = [RecommendIngManager sharedInstance];
                                        }
                                        else if([@"t_spot" isEqualToString:tableName])
                                        {
                                            manager = [SpotManager sharedInstance];
                                        }
                                        else if([@"t_spotroute" isEqualToString:tableName])
                                        {
                                            manager = [SpotRouteManager sharedInstance];
                                        }
                                        else if([@"t_traffic" isEqualToString:tableName])
                                        {
                                            manager = [TrafficManager sharedInstance];
                                        }
                                        else if([@"t_speakcontent" isEqualToString:tableName])
                                        {
                                            manager = [SpotSpeakContentManager sharedInstance];
                                        }
                                        else if([@"t_scenic" isEqualToString:tableName])
                                        {
                                            manager = [ScenicManager sharedInstance];
                                        }
                                        else if([@"t_poirelation" isEqualToString:tableName])
                                        {
                                            manager = [POIRelationManager sharedInstance];
                                        }
                                        manager.waitUpdate = YES;
                                        
                                        ZS_TableVersion_entity *entity = [[[ZS_TableVersion_entity alloc] init] autorelease];
                                        entity.tableName = ReplaceNULL2Empty([entityDic objectForKey:@"TableName"]);
                                        entity.tableVersion = ReplaceNULL2Empty([entityDic objectForKey:@"CurrentVersion"]);
                                        entity.UpdataCount = [ReplaceNULL2Empty([entityDic objectForKey:@"UpdataCount"]) intValue];
                                        [needUpdateTables setObject:entity forKey:entity.tableName];
                                    }
                                }
                            }
                            else
                            {
                                base.error_code = E_HTTPERR_FAILED;
                            }
                        }
                        else
                        {
                            base.error_code = E_HTTPERR_FAILED;
                        }
                    }
                    else
                    {
                        base.error_code = E_HTTPERR_FAILED;
                    }
                    [result release];
                    [jsonP release];
                }
                else
                {
                    base.error_code = E_HTTPERR_FAILED;
                }
            }
            
            if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
            [base release];

            //2.请求成功  更新需要更新的表
            for (NSString *tableName in needUpdateTables.allKeys)
            {
                ZS_TableVersion_entity *entity = [needUpdateTables objectForKey:tableName];
                [self requestUpdateTableData:entity.tableName withMoreID:-1];
            }
            break;
        }
        default:
            break;
    }
}

@end
