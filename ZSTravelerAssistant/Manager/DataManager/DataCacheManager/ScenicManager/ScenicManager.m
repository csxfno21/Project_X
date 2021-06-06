//
//  ScenicManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-27.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ScenicManager.h"
static ScenicManager *manager;
@implementation ScenicManager
+(ScenicManager *)sharedInstance
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[ScenicManager alloc] init];
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

- (void)requestGetScenicData:(id)UIDelegate
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetScenicData Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_SCENIC;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_SCENIC];
    
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
        case CC_GET_SCENIC:
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
                            NSArray *infoArray = [infoDic objectForKey:@"ScenicInfo"];
                            if(ISARRYCLASS(infoArray))
                            {
                                for (NSDictionary *entityDic in infoArray)
                                {
                                    ZS_Scenic_Buffer_entity *entity = [[[ZS_Scenic_Buffer_entity alloc] init] autorelease];
                                    entity.ID = [ReplaceNULL2Empty([entityDic objectForKey:@"ID"]) intValue];
                                    entity.spotID = ReplaceNULL2Empty([entityDic objectForKey:@"SpotID"]);
                                    entity.SpeakContentIn = ReplaceNULL2Empty([entityDic objectForKey:@"SpeakContentIn"]);
                                    entity.SpeakContentOut = ReplaceNULL2Empty([entityDic objectForKey:@"SpeakContentOut"]);
                                    entity.ScenicName = ReplaceNULL2Empty([entityDic objectForKey:@"ViewName"]);
                                    entity.BufferIn = ReplaceNULL2Empty([entityDic objectForKey:@"BufferIn"]);
                                    entity.BufferOut = ReplaceNULL2Empty([entityDic objectForKey:@"BufferOut"]);
                                    if(response.cmdCode == CC_GET_SCENIC)
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
