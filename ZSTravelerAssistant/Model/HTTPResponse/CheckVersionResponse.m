//
//  CheckVersionResponse.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-2.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "CheckVersionResponse.h"

@implementation CheckVersionResponse
@synthesize version;
@synthesize appLink;
@synthesize currentVersion;
- (id)init
{
    if (self = [super init])
    {
        version = VERSION_UNKNOW;
    }
    return self;
}

- (void)dealloc
{
    version = VERSION_UNKNOW;
    SAFERELEASE(appLink)
    SAFERELEASE(currentVersion)
    [super dealloc];
}
@end
