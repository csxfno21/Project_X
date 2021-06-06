//
//  SpotSpeakContentManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-24.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "SpotSpeakContentManager.h"
static SpotSpeakContentManager *manager;
@implementation SpotSpeakContentManager
+(SpotSpeakContentManager *)sharedInstance
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[SpotSpeakContentManager alloc] init];
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

- (void)dealloc
{
    SAFERELEASE(manager)
    [super dealloc];
}



- (void)requestGetSpeakData:(id)UIDelegate withInfoID:(int)infoID
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetSpeakData Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_SPEAK;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_SPEAK];
    
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
        case CC_GET_SPEAK:
        {
            HttpBaseResponse *base = [[HttpBaseResponse alloc] init];
            base.cc_cmd_code = response.cmdCode;
            base.UIDelegate = response.UIDelegate;
            base.error_code = response.errorCode;
            if(response.errorCode == E_HTTPSUCCEES)
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
                            NSArray *infoArray = [infoDic objectForKey:@"SpeakSpotDetail"];
                            if(ISARRYCLASS(infoArray))
                            {
                                for (NSDictionary *entityDic in infoArray)
                                {
                                    ZS_SpotSpeak_Entity *entity = [[[ZS_SpotSpeak_Entity alloc] init] autorelease];
                                    entity.ID = [ReplaceNULL2Empty([entityDic objectForKey:@"ID"]) intValue];
                                    entity.SpotBuffer = [entityDic objectForKey:@"SpotBuffer"];
                                    entity.SpotID = [entityDic objectForKey:@"SpotID"];
                                    entity.SpotName = [entityDic objectForKey:@"SpotName"];
                                    entity.SpeakSpotContent = [entityDic objectForKey:@"SpeakSpotContent"];
                                    entity.SpotParentID = [entityDic objectForKey:@"parentID"];
                                    if(response.cmdCode == CC_GET_SPEAK)
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
