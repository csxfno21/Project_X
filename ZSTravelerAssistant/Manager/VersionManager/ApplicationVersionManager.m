//
//  ApplicationVersionManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-2.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ApplicationVersionManager.h"
static ApplicationVersionManager *manager;
@implementation ApplicationVersionManager

+ (ApplicationVersionManager *)sharedInstance
{
    @synchronized(self)
    {
        if (!manager)
        {
            manager = [[ApplicationVersionManager alloc] init];
        }
    }
    return manager;
}

- (id)init
{
    if (self = [super init])
    {
        
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

- (void)requestCheckVersion:(id)UIDelegate
{
    if(UIDelegate == nil)
    {
        NSLog(@"requestCheckVersion Error,UIDelegate can not be nil!");
        return;
    }
    
    HttpRequest *request = [[HttpRequest alloc] init];
    request.cmdCode = CC_VERSION_CHECK;
    request.requestType = MSG;
    request.delegate = self;
    request.UIDelegate = UIDelegate;
    request.url = [NSString stringWithFormat:@"%@%@",SERVER_ADDRESS,ACTION_CHECK_APPLICATION_VERSION];
    
    //JSON 结构
    NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
    [postData setObject:@"IOS" forKey:@"device"];
    [postData setObject:[PublicUtils version] forKey:@"appVersion"];
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
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
        case CC_VERSION_CHECK:
        {
            CheckVersionResponse *base = [[CheckVersionResponse alloc] init];
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
                            NSDictionary *versionInfo = [infoDic objectForKey:@"appCheckInfo"];
                            if (ISDICTIONARYCLASS(versionInfo))
                            {
                                base.version = [ReplaceNULL2Empty([versionInfo objectForKey:@"isNeedUpdate"]) intValue];
                                base.currentVersion = [versionInfo objectForKey:@"currentVersion"];
                                base.appLink = [versionInfo objectForKey:@"appLink"];
                            }
                            else
                            base.error_code = E_HTTPERR_FAILED;
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
    [super dealloc];
}
@end
