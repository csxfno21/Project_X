//
//  RecommendIngManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "RecommendIngManager.h"

static RecommendIngManager *manager;
@implementation RecommendIngManager

+(RecommendIngManager *)sharedInstance
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[RecommendIngManager alloc] init];
        }
    }
    return manager;
}
- (id)init
{
    
    if (self = [super init])
    {
        _spotsCache = [[NSMutableArray alloc] init];
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
    SAFERELEASE(_spotsCache)
    [super dealloc];
}

- (void)requestGetMianScrolSpots:(id)UIDelegate
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestCheckVersion Error,UIDelegate can not be nil!");
        return;
    }
    
    NSArray *cache = [[DataAccessManager sharedDataModel] getAllRecommend];
    //判断 当前是否需要更新
    if(!self.waitUpdate && cache.count > 0)//读取数据库
    {
        HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
        base.cc_cmd_code = CC_GET_MAIN_SCROL_SPOTS;
        base.UIDelegate = UIDelegate;
        
        [_spotsCache removeAllObjects];
        [_spotsCache addObjectsFromArray:cache];
        
        base.error_code = E_HTTPSUCCEES;
        if(base.UIDelegate && [base.UIDelegate respondsToSelector:@selector(callBackToUI:)])
            [base.UIDelegate callBackToUI:base];
        [base release];
        return;
    }
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_MAIN_SCROL_SPOTS;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_MAIN_SCORLL_SPOTS];
    
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

- (void)reciveHttpRespondInfo:(HttpResponse *)response
{
    switch (response.cmdCode)
    {
        case CC_GET_MAIN_SCROL_SPOTS:
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
//                    NSLog(@"reciveHttpRespondInfo result %@",result);
                    SBJsonParser *jsonP = [[SBJsonParser alloc] init];
                    NSMutableDictionary *responsedic = [jsonP fragmentWithString:result];
                    if(ISDICTIONARYCLASS(responsedic))
                    {
                        NSDictionary *spotsInfoDic = [self getJSONContent:responsedic];
                        if (ISDICTIONARYCLASS(spotsInfoDic))
                        {
                            NSArray *spotsArray = [spotsInfoDic objectForKey:@"spots"];
                            if(ISARRYCLASS(spotsArray))
                            {
                                [_spotsCache removeAllObjects];
                                for (NSDictionary *entityDic in spotsArray)
                                {
                                    ZS_RecommendImg_entity *entity = [[[ZS_RecommendImg_entity alloc] init] autorelease];
                                    entity.ID = [ReplaceNULL2Empty([entityDic objectForKey:@"ID"]) intValue];
                                    entity.SpotID = [entityDic objectForKey:@"SpotID"];
                                    entity.ImageName = [entityDic objectForKey:@"ImgName"];
                                    entity.ImgUrl = [entityDic objectForKey:@"ImgUrl"];
                                    [_spotsCache addObject:entity];
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
