//
//  SpotRouteManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "SpotRouteManager.h"
static SpotRouteManager *manager;
@implementation SpotRouteManager
+(SpotRouteManager *)sharedInstance
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[SpotRouteManager alloc] init];
        }
    }
    return manager;
}
- (id)init
{
    
    if (self = [super init])
    {
        _themRouteCache = [[NSMutableArray alloc] init];
        _commonRouteCache = [[NSMutableArray alloc] init];
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

- (void)requestGetThemRoute:(id)UIDelegate
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetThemRoute Error,UIDelegate can not be nil!");
        return;
    }
    if(_themRouteCache.count > 0)
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_THEM_ROUTE;
        base.UIDelegate = UIDelegate;
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    NSArray *cache = [[DataAccessManager sharedDataModel] getAllThemRoute];
    if(!self.waitUpdate && cache.count > 0)
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_THEM_ROUTE;
        base.UIDelegate = UIDelegate;
        
        [_themRouteCache removeAllObjects];
        [_themRouteCache addObjectsFromArray:cache];
        
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_THEM_ROUTE;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_THEM_ROUTE];
    
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
- (void)requestGetThemRoute:(id)UIDelegate withMoreID:(int)moreID
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetTraffic Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_THEM_ROUTE_MORE;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_THEM_ROUTE_MORE];
    
    //JSON 结构
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    [postData setObject:INTTOOBJ(moreID) forKey:@"InfoID"];
    NSString *dataString  = [writer stringWithObject:postData];
    NSData *requestData = [[[NSData alloc]initWithBytes:[dataString UTF8String] length:strlen([dataString UTF8String])] autorelease];
    request.postData = requestData;
    [postData release];
    [writer release];
    
    [[ASIUtil sharedInstance] POSTRequest:request];
    [request release];
}
- (void)requestGetCommonRoute:(id)UIDelegate
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetCommonRoute Error,UIDelegate can not be nil!");
        return;
    }
    if(_commonRouteCache.count > 0)
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_COMMON_ROUTE;
        base.UIDelegate = UIDelegate;
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    NSArray *cache = [[DataAccessManager sharedDataModel] getAllCommonRoute];
    if(!self.waitUpdate && cache.count > 0)
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_COMMON_ROUTE;
        base.UIDelegate = UIDelegate;
        
        [_commonRouteCache removeAllObjects];
        [_commonRouteCache addObjectsFromArray:cache];
        
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_COMMON_ROUTE;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_COMMON_ROUTE];
    
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
- (void)requestGetCommonRoute:(id)UIDelegate withMoreID:(int)moreID
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetCommonRoute Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_COMMON_ROUTE_MORE;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_COMMON_ROUTE_MORE];
    
    //JSON 结构
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    [postData setObject:INTTOOBJ(moreID) forKey:@"InfoID"];
    NSString *dataString  = [writer stringWithObject:postData];
    NSData *requestData = [[[NSData alloc]initWithBytes:[dataString UTF8String] length:strlen([dataString UTF8String])] autorelease];
    request.postData = requestData;
    [postData release];
    [writer release];
    
    [[ASIUtil sharedInstance] POSTRequest:request];
    [request release];

}
- (void)requestGetRoute:(id)UIDelegate withInfoID:(int)infoID
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetRoute Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_ROUTE;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_ROUTE];
    
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
        case CC_GET_THEM_ROUTE:
        case CC_GET_THEM_ROUTE_MORE:
        case CC_GET_COMMON_ROUTE:
        case CC_GET_COMMON_ROUTE_MORE:
        case CC_GET_ROUTE:
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
                            NSArray *infoArray = [infoDic objectForKey:@"RouteInfo"];
                            if(ISARRYCLASS(infoArray))
                            {
                                if(response.cmdCode == CC_GET_THEM_ROUTE)
                                {
                                    [_themRouteCache removeAllObjects];
                                }
                                else if(response.cmdCode == CC_GET_COMMON_ROUTE)
                                {
                                    [_commonRouteCache removeAllObjects];
                                }
                                
                                for (NSDictionary *entityDic in infoArray)
                                {
                                    ZS_SpotRoute_entity *entity = [[[ZS_SpotRoute_entity alloc] init] autorelease];
                                    entity.ID = [ReplaceNULL2Empty([entityDic objectForKey:@"ID"]) intValue];
                                    entity.RouteType = [entityDic objectForKey:@"RouteType"];
                                    entity.RouteTitle = [entityDic objectForKey:@"RouteTitle"];
                                    entity.RouteLength = [entityDic objectForKey:@"RouteLength"];
                                    entity.RouteSmallImgUrl = [entityDic objectForKey:@"RouteSmallImgUrl"];
                                    entity.RouteSmallImgName = [entityDic objectForKey:@"RouteSmallImgName"];
                                    entity.RouteTime = [entityDic objectForKey:@"RouteTime"];
                                    entity.RouteList = ReplaceNULL2Empty([entityDic objectForKey:@"SpotList"]);
//                                    NSArray *spotList = [entityDic objectForKey:@"SpotList"];
//                                    NSString *tmp = @"";
//                                    for (NSString *spotID in spotList)
//                                    {
//                                        if(tmp.length == 0)
//                                            tmp = spotID;
//                                        else
//                                            tmp = [NSString stringWithFormat:@"%@,%@",tmp,spotID];
//                                    }
//                                    entity.RouteList = tmp;
                                    entity.RouteTicket = [entityDic objectForKey:@"RouteTicket"];
                                    entity.RouteContent = [entityDic objectForKey:@"RouteContent"];
                                    entity.RouteImageUrl = [entityDic objectForKey:@"RouteImageUrl"];
                                    entity.RouteImageName = [entityDic objectForKey:@"RouteImageName"];
                                    if(response.cmdCode == CC_GET_THEM_ROUTE || response.cmdCode == CC_GET_THEM_ROUTE_MORE)
                                    {
                                        [_themRouteCache addObject:entity];
                                    }
                                    else if(response.cmdCode == CC_GET_COMMON_ROUTE || response.cmdCode == CC_GET_COMMON_ROUTE_MORE)
                                    {
                                        [_commonRouteCache addObject:entity];
                                    }
                                    else if(response.cmdCode == CC_GET_ROUTE)
                                    {
                                        [_downLoadCache addObject:entity];
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
            
            break;
        }
        default:
            break;
    }
}


- (void)dealloc
{
    SAFERELEASE(_themRouteCache)
    SAFERELEASE(_commonRouteCache)
    SAFERELEASE(_downLoadCache)
    [super dealloc];
}


@end
