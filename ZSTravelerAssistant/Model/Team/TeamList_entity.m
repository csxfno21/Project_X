//
//  TeamList_entity.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-11.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "TeamList_entity.h"

@implementation TeamList_entity
@synthesize success;
@synthesize teamID;
@synthesize teamName;
@synthesize teamCreator;
@synthesize onLineaPCount;
@synthesize teamCounts;

-(void)dealloc
{
    SAFERELEASE(success)
    SAFERELEASE(teamID)
    SAFERELEASE(teamName)
    SAFERELEASE(teamCreator)
    SAFERELEASE(onLineaPCount)
    SAFERELEASE(teamCounts)
    [super dealloc];
}

@end
