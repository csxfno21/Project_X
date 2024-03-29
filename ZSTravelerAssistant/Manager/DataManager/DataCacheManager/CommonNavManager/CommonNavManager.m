//
//  CommonNavManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "CommonNavManager.h"
static CommonNavManager *manager;
@implementation CommonNavManager

+(CommonNavManager *)sharedInstance
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[CommonNavManager alloc] init];
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

- (void)requestGetPoi:(id)UIDelegate withInfoID:(int)infoID
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestGetPoi Error,UIDelegate can not be nil!");
        return;
    }
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_GET_POI;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_GET_POI];
    
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
        case CC_GET_POI:
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
                            NSArray *infoArray = [infoDic objectForKey:@"POIInfo"];
                            if(ISARRYCLASS(infoArray))
                            {
                                for (NSDictionary *entityDic in infoArray)
                                {
                                    ZS_CommonNav_entity *entity = [[[ZS_CommonNav_entity alloc] init] autorelease];
                                    entity.ID = [ReplaceNULL2Empty([entityDic objectForKey:@"ID"]) intValue];
                                    entity.NavType = ReplaceNULL2Empty([entityDic objectForKey:@"POIType"]);
                                    entity.NavLng = ReplaceNULL2Empty([entityDic objectForKey:@"POILng"]);
                                    entity.NavLat = ReplaceNULL2Empty([entityDic objectForKey:@"POILat"]);
                                    entity.NavTitle = ReplaceNULL2Empty([entityDic objectForKey:@"POITitle"]);
                                    entity.NavContent = ReplaceNULL2Empty([entityDic objectForKey:@"POIContent"]);
                                    entity.NavInSpotID = ReplaceNULL2Empty([entityDic objectForKey:@"POIParent"]);
                                    entity.NavIID = ReplaceNULL2Empty([entityDic objectForKey:@"POIID"]);
                                    entity.NavPosition = ReplaceNULL2Empty([entityDic objectForKey:@"POIPosition"]);
                                    entity.NavRemark = ReplaceNULL2Empty([entityDic objectForKey:@"POIRemark"]);
                                    entity.POITourCar = ReplaceNULL2Empty([entityDic objectForKey:@"POITourCar"]);
                                    entity.POIPark = ReplaceNULL2Empty([entityDic objectForKey:@"POIPark"]);
                                    if(response.cmdCode == CC_GET_POI)
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
