//
//  SenderUser.m
//  ZSTravelerAssistant
//
//  Created by 严道秋 on 13-11-11.
//  Copyright (c) 2013年 com.szmap. All rights reserved.
//

#import "TeamUser.h"

@implementation TeamUser
@synthesize userID,userName,userType;
- (id)init
{
    if(self = [super init])
    {
        userType = TEAM_USER_SENDER;        //默认为 发送者
    }
    return self;
}
- (void)dealloc
{
    SAFERELEASE(userName)
    SAFERELEASE(userID)
    [super dealloc];
}
@end
