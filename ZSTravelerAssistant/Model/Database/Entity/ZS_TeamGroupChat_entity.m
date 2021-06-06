//
//  ZS_GroupChat_entity.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_TeamGroupChat_entity.h"

@implementation ZS_TeamGroupChat_entity
@synthesize ID;
@synthesize TeamID;
@synthesize SenderID;
@synthesize SenderName;
@synthesize ChatContent;
@synthesize ChatTime;
@synthesize messageState;
-(void)dealloc
{
    SAFERELEASE(TeamID)
    SAFERELEASE(SenderID)
    SAFERELEASE(ChatContent)
    SAFERELEASE(ChatTime)
    SAFERELEASE(SenderName)
    [super dealloc];
}
@end