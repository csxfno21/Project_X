//
//  TrafficManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "TrafficManager.h"
static TrafficManager *manager;
@implementation TrafficManager
+(TrafficManager *)sharedInstance
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[TrafficManager alloc] init];
        }
    }
    return manager;
}
- (id)init
{
    
    if (self = [super init])
    {
        _busInfoCache = [[NSMutableArray alloc] init];
        _tourisCarInfoCache = [[NSMutableArray alloc] init];
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
- (void)requestGetTourisCarInfo :(id)UIDelegate withMoreID:(int)moreID
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetTourisCarInfo Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_TOURISCAR_INFO_MORE;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_TOURIS_MORE];
    
    //JSON 结构
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setObject:INTTOOBJ(moreID) forKey:@"InfoID"];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *dataString  = [writer stringWithObject:postData];
    NSData *requestData = [[[NSData alloc]initWithBytes:[dataString UTF8String] length:strlen([dataString UTF8String])] autorelease];
    request.postData = requestData;
    [postData release];
    [writer release];
    
    [[ASIUtil sharedInstance] POSTRequest:request];
    [request release];
}
- (void)requestGetTourisCarInfo:(id)UIDelegate
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetTourisCarInfo Error,UIDelegate can not be nil!");
        return;
    }
    if(_tourisCarInfoCache.count > 0)
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_TOURISCAR_INFO;
        base.UIDelegate = UIDelegate;
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    NSArray *cache = [[DataAccessManager sharedDataModel] getAllTourisCarInfo];
    if(!self.waitUpdate && cache.count > 0)
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_TOURISCAR_INFO;
        base.UIDelegate = UIDelegate;
        
        [_tourisCarInfoCache removeAllObjects];
        [_tourisCarInfoCache addObjectsFromArray:cache];
        
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_TOURISCAR_INFO;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_TOURIS];
    
    //JSON 结构
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *dataString  = [writer stringWithObject:postData];
    NSData *requestData = [[[NSData alloc]initWithBytes:[dataString UTF8String] length:strlen([dataString UTF8String])] autorelease];
    request.postData = requestData;
    [postData release];
    [writer release];
    
    [[ASIUtil sharedInstance] POSTRequest:request];
    [request release];
}
- (void)requestGetBusInfo :(id)UIDelegate withMoreID:(int)moreID
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetBusInfo Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_BUSS_INFO_MORE;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_BUSS_MORE];
    
    //JSON 结构
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setObject:INTTOOBJ(moreID) forKey:@"InfoID"];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *dataString  = [writer stringWithObject:postData];
    NSData *requestData = [[[NSData alloc]initWithBytes:[dataString UTF8String] length:strlen([dataString UTF8String])] autorelease];
    request.postData = requestData;
    [postData release];
    [writer release];
    
    [[ASIUtil sharedInstance] POSTRequest:request];
    [request release];
}
- (void)requestGetBusInfo:(id)UIDelegate
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetBusInfo Error,UIDelegate can not be nil!");
        return;
    }
    if(_busInfoCache.count > 0)
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_BUSS_INFO;
        base.UIDelegate = UIDelegate;
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    NSArray *cache = [[DataAccessManager sharedDataModel] getAllBusInfo];
    if(!self.waitUpdate && cache.count > 0)
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_BUSS_INFO;
        base.UIDelegate = UIDelegate;
        
        [_busInfoCache removeAllObjects];
        [_busInfoCache addObjectsFromArray:cache];
        
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_BUSS_INFO;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_BUSS];
    
    //JSON 结构
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *dataString  = [writer stringWithObject:postData];
    NSData *requestData = [[[NSData alloc]initWithBytes:[dataString UTF8String] length:strlen([dataString UTF8String])] autorelease];
    request.postData = requestData;
    [postData release];
    [writer release];
    
    [[ASIUtil sharedInstance] POSTRequest:request];
    [request release];
}
- (void)requestGetTraffic:(id)UIDelegate withInfoID:(int)infoID
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetTraffic Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_TRAFFIC;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_TRAFFIC];
    
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
- (void)reciveHttpRespondInfo:(HttpResponse *)response
{
    switch (response.cmdCode)
    {
        case CC_GET_TOURISCAR_INFO_MORE:
        case CC_GET_TOURISCAR_INFO:
        case CC_GET_BUSS_INFO_MORE:
        case CC_GET_BUSS_INFO:
        case CC_GET_TRAFFIC:
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
//                    NSLog(@"----- %@",result);
                    SBJsonParser *jsonP = [[SBJsonParser alloc] init];
                    NSMutableDictionary *responsedic = [jsonP fragmentWithString:result];
                    if(ISDICTIONARYCLASS(responsedic))
                    {
                        NSDictionary *infoDic = [self getJSONContent:responsedic];
                        if (ISDICTIONARYCLASS(infoDic))
                        {
                            NSArray *infoArray = [infoDic objectForKey:@"busInfo"];
                            if(ISARRYCLASS(infoArray))
                            {
                                if(response.cmdCode == CC_GET_BUSS_INFO)
                                    [_busInfoCache removeAllObjects];
                                if(response.cmdCode == CC_GET_TOURISCAR_INFO)
                                    [_tourisCarInfoCache removeAllObjects];
                                for (NSDictionary *entityDic in infoArray)
                                {
                                    ZS_Traffic_entity *entity = [[[ZS_Traffic_entity alloc] init] autorelease];
                                    entity.ID = [ReplaceNULL2Empty([entityDic objectForKey:@"ID"]) intValue];
                                    entity.TrafficName = [entityDic objectForKey:@"TrafficName"];
                                    entity.TrafficStartTime = [entityDic objectForKey:@"TrafficStartTime"];
                                    entity.TrafficEndTime = [entityDic objectForKey:@"TrafficEndTime"];
                                    entity.TrafficDetail = [entityDic objectForKey:@"TrafficDetail"];
                                    entity.TrafficRemark = [entityDic objectForKey:@"TrafficRemark"];
                                    entity.TrafficPrice = [entityDic objectForKey:@"TrafficTicket"];
                                    entity.TrafficType = [entityDic objectForKey:@"TrafficType"];
                                    
                                    if(response.cmdCode == CC_GET_BUSS_INFO || response.cmdCode == CC_GET_BUSS_INFO_MORE)
                                    {
                                        if (entity.TrafficType.intValue == 1)
                                        {
                                            [_busInfoCache addObject:entity];
                                        }
                                    }
                                    else if(response.cmdCode == CC_GET_TOURISCAR_INFO || response.cmdCode == CC_GET_TOURISCAR_INFO_MORE)
                                    {
                                        if (entity.TrafficType.intValue == 2)
                                        {
                                            [_tourisCarInfoCache addObject:entity];
                                        }
                                    }
                                    else if(response.cmdCode == CC_GET_TRAFFIC)
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
    SAFERELEASE(_downLoadCache)
    SAFERELEASE(_busInfoCache)
    SAFERELEASE(_tourisCarInfoCache)
    [super dealloc];
}


@end
