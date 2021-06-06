//
//  BaseRequestManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-9.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseRequestManager.h"

#define JSON_ROOT_KEY         @"result"
#define JSON_ERROR_CODE       @"errorCode"
#define JSON_CONTENT_KEY      @"Content"


@implementation BaseRequestManager
@synthesize waitUpdate;
#pragma mark
#pragma mark ASIRequestInteface
- (void)cancelAllRequest
{
    [[ASIUtil sharedInstance] cancelAllRequest];
}

- (void)cancelRequest:(id)delegate
{
    [[ASIUtil sharedInstance] cancelRequest:delegate];
}

- (void)cancelRequestWithCode:(REQUEST_CMD_CODE)cc_code
{
    [[ASIUtil sharedInstance] cancelRequestWithCode:cc_code];
}

- (void)reciveHttpRespondInfo:(HttpResponse *)response
{
    
}

/**
 *
 * 返回结构体
 */
- (id)getJSONContent:(NSDictionary*)dic
{
    
    if (ISDICTIONARYCLASS(dic))
    {
        NSDictionary *result = [dic objectForKey:JSON_ROOT_KEY];
        if(ISDICTIONARYCLASS(result))
        {
            int errorCode = [ReplaceNULL2Empty([result objectForKey:JSON_ERROR_CODE]) intValue];
            if(errorCode == 0)//JSON 返回成功
            {
                return [result objectForKey:JSON_CONTENT_KEY];
            }
        }
    }
    
    return nil;
}
@end
