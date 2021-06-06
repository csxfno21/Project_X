//
//  ZS_SingleChat_entity.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_TeamSingleChat_entity.h"

@implementation ZS_TeamSingleChat_entity
@synthesize ID;
@synthesize TeamID;
@synthesize SenderID;
@synthesize ChatContent;
@synthesize ChatTime;
@synthesize ReceiveID;
@synthesize ReceiveName;
@synthesize messageState;
-(void)dealloc
{
    SAFERELEASE(TeamID)
    SAFERELEASE(SenderID)
    SAFERELEASE(ChatContent)
    SAFERELEASE(ChatTime)
    SAFERELEASE(ReceiveID)
    SAFERELEASE(ReceiveName)
    [super dealloc];
}

@end
