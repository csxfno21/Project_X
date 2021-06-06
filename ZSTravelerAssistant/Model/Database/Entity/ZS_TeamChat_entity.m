//
//  ZS_TeamChat_entity.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-11.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_TeamChat_entity.h"

@implementation ZS_TeamChat_entity
@synthesize ID;
@synthesize ChatCreator;
@synthesize ChatCreatorID;
@synthesize ChatName;
@synthesize ChatNameID;

-(void)dealloc
{
    SAFERELEASE(ChatCreator)
    SAFERELEASE(ChatCreatorID)
    SAFERELEASE(ChatName)
    SAFERELEASE(ChatNameID)
    [super dealloc];
}
@end
