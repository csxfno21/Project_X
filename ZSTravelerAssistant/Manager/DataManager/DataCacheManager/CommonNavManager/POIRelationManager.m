//
//  POIRelationManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-24.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "POIRelationManager.h"
static POIRelationManager *manager;
@implementation POIRelationManager
+(POIRelationManager *)sharedInstance
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[POIRelationManager alloc] init];
        }
    }
    return manager;
}
- (id)init
{
    
    if (self = [super init])
    {
        _downLoadCache = [[NSMutableArray alloc] init];
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
- (void)requestGetPoiRelation:(id)UIDelegate withInfoID:(int)infoID
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetPoiRelation Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_POI_RELATION;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_POIRELATION];
    
    //JSON 结构
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    [postData setObject:INTTOOBJ(infoID) forKey:@"InfoID"];
    NSString *dataString  = [writer stringWithObject:postData];
    NSData *requestData = [[[NSData alloc]initWithBytes:[dataString UTF8String] length:strlen([dataString UTF8String])] autorelease];
    request.postData = requestData;
    [postData release];
    [writer release];
    
    [[ASIUtil sharedInstance] POSTRequest:request];
    [request release];
}

#pragma mark - reciveHttpRespondInfo
- (void)reciveHttpRespondInfo:(HttpResponse *)response
{
    switch (response.cmdCode)
    {
    case CC_GET_POI_RELATION:
        {
            HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
            base.cc_cmd_code = response.cmdCode;
            base.UIDelegate = response.UIDelegate;
            base.error_code = response.errorCode;
            if(base.error_code ==  E_HTTPSUCCEES)
            {
                if(response.data)
                {
                    NSString *result = [[NSString alloc] initWithData:response.data  encoding:NSUTF8StringEncoding];
                    SBJsonParser *jsonP = [[SBJsonParser alloc] init];
                    NSMutableDictionary *responsedic = [jsonP fragmentWithString:result];
                    if(ISDICTIONARYCLASS(responsedic))
                    {
                        NSDictionary *infoDic = [self getJSONContent:responsedic];
                        if (ISDICTIONARYCLASS(infoDic))
                        {
                            NSArray *infoArray = [infoDic objectForKey:@"POIRelationData"];
                            if(ISARRYCLASS(infoArray))
                            {
                                for (NSDictionary *entityDic in infoArray)
                                {
                                    ZS_PoiRelation_entity *entity = [[[ZS_PoiRelation_entity alloc] init] autorelease];
                                    entity.ID = [ReplaceNULL2Empty([entityDic objectForKey:@"ID"]) intValue];
                                    entity.PoiID = ReplaceNULL2Empty([entityDic objectForKey:@"POIID"]);
                                    entity.ParentID = ReplaceNULL2Empty([entityDic objectForKey:@"POIParentID"]);
                                    entity.POITitle = ReplaceNULL2Empty([entityDic objectForKey:@"POITitle"]);
                                    entity.POIType = ReplaceNULL2Empty([entityDic objectForKey:@"POIType"]);
                                    entity.POILng = ReplaceNULL2Empty([entityDic objectForKey:@"POILng"]);
                                    entity.POILat = ReplaceNULL2Empty([entityDic objectForKey:@"POILat"]);
                                    entity.POIBuffer = ReplaceNULL2Empty([entityDic objectForKey:@"POIBuffer"]);
                                    [_downLoadCache addObject:entity];
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
            
            break;
        }
    default:
        break;
    }
}
- (void)dealloc
{
    SAFERELEASE(manager)
    SAFERELEASE(_downLoadCache)
    [super dealloc];
}
@end
