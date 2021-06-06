//
//  InfoMationManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "InfoMationManager.h"
static InfoMationManager *manager;
@implementation InfoMationManager

+(InfoMationManager *)sharedInstance
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[InfoMationManager alloc] init];
        }
    }
    return manager;
}
- (id)init
{
    if (self = [super init])
    {
        _downLoadCache = [[NSMutableArray alloc] init];
        _seasonInfoCache = [[NSMutableArray alloc] init];
        _recentlyInfoCache = [[NSMutableArray alloc] init];
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
    SAFERELEASE(_downLoadCache)
    SAFERELEASE(_recentlyInfoCache)
    SAFERELEASE(_seasonInfoCache)
    [super dealloc];
}

- (void)requestGetSeasonInfo:(id)UIDelegate withMoreID:(int)moreID
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetSeasonInfo Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_SEASON_INFO_MORE;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_SEASON_INFO_MORE];
    
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
- (void)requestGetSeasonInfo:(id)UIDelegate
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetSeasonInfo Error,UIDelegate can not be nil!");
        return;
    }
   
    if(_seasonInfoCache.count > 0)
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_SEASON_INFO;
        base.UIDelegate = UIDelegate;
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    NSArray *cache = [[DataAccessManager sharedDataModel] getAllSeasonInfo];
    if(!self.waitUpdate && cache.count > 0)
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_SEASON_INFO;
        base.UIDelegate = UIDelegate;
        
        [_seasonInfoCache removeAllObjects];
        [_seasonInfoCache addObjectsFromArray:cache];
        
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_SEASON_INFO;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_SEASON_INFO];
    
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
- (void)requestGetRecentlyInfo :(id)UIDelegate withMoreID:(int)moreID
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetRecentlyInfo Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_REC_INFO_MORE;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_REC_INFO_MORE];
    
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
- (void)requestGetRecentlyInfo:(id)UIDelegate
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetRecentlyInfo Error,UIDelegate can not be nil!");
        return;
    }
    if(_recentlyInfoCache.count > 0)
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_REC_INFO;
        base.UIDelegate = UIDelegate;
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    NSArray *cache = [[DataAccessManager sharedDataModel] getAllRecentlyInfo];
    if(!self.waitUpdate && cache.count > 0)
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_REC_INFO;
        base.UIDelegate = UIDelegate;
        
        [_recentlyInfoCache removeAllObjects];
        [_recentlyInfoCache addObjectsFromArray:cache];
        
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_REC_INFO;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_REC_INFO];
    
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
- (void)requestGetInfo:(id)UIDelegate withInfoID:(int)infoID
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetInfo Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_INFO;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_INFO];
    
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
        case CC_GET_REC_INFO:
        case CC_GET_REC_INFO_MORE:
        case CC_GET_SEASON_INFO_MORE:
        case CC_GET_SEASON_INFO:
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
                            NSArray *infoArray = [infoDic objectForKey:@"SeasonInfo"];
                            if(ISARRYCLASS(infoArray))
                            {
                                if(response.cmdCode == CC_GET_SEASON_INFO)
                                [_seasonInfoCache removeAllObjects];
                                if(response.cmdCode == CC_GET_REC_INFO)
                                [_recentlyInfoCache removeAllObjects];
                                for (NSDictionary *entityDic in infoArray)
                                {
                                    ZS_Infomation_entity *entity = [[[ZS_Infomation_entity alloc] init] autorelease];
                                    entity.ID = [ReplaceNULL2Empty([entityDic objectForKey:@"ID"]) intValue];
                                    entity.InfoType = [entityDic objectForKey:@"infoType"];
                                    entity.InfoTitle = [entityDic objectForKey:@"infoTitle"];
                                    entity.InfoImgUrl = [entityDic objectForKey:@"infoImgUrl"];
                                    entity.InfoImgName = [entityDic objectForKey:@"infoImgName"];
                                    entity.SmallImageUrl = [entityDic objectForKey:@"SmallinfoImgUrl"];
                                    entity.SmallImageName = [entityDic objectForKey:@"SmallinfoImgName"];
                                    entity.InfoContent = [entityDic objectForKey:@"Content"];

                                    if (entity.InfoType.intValue == 1)//景区推荐
                                    {
                                        [_seasonInfoCache addObject:entity];
                                    }
                                    else if(entity.InfoType.intValue == 2)
                                    {
                                        [_recentlyInfoCache addObject:entity];
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
        case CC_GET_INFO:
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
                            NSArray *infoArray = [infoDic objectForKey:@"SeasonInfo"];
                            if(ISARRYCLASS(infoArray))
                            {
                                for (NSDictionary *entityDic in infoArray)
                                {
                                    ZS_Infomation_entity *entity = [[[ZS_Infomation_entity alloc] init] autorelease];
                                    entity.ID = [ReplaceNULL2Empty([entityDic objectForKey:@"ID"]) intValue];
                                    entity.InfoType = [entityDic objectForKey:@"infoType"];
                                    entity.InfoTitle = [entityDic objectForKey:@"infoTitle"];
                                    entity.InfoImgUrl = [entityDic objectForKey:@"infoImgUrl"];
                                    entity.InfoImgName = [entityDic objectForKey:@"infoImgName"];
                                    entity.SmallImageUrl = [entityDic objectForKey:@"SmallinfoImgUrl"];
                                    entity.SmallImageName = [entityDic objectForKey:@"SmallinfoImgName"];
                                    entity.InfoContent = [entityDic objectForKey:@"Content"];
    
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
@end
