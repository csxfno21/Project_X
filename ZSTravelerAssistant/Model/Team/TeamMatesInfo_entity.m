//
//  TeamMatesInfo_entity.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-11.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "TeamMatesInfo_entity.h"

@implementation TeamMatesInfo_entity
@synthesize ID;
@synthesize nickName;
@synthesize sex;
@synthesize where;
@synthesize longitude;
@synthesize latitude;
@synthesize state;

-(void)dealloc
{
    SAFERELEASE(ID)
    SAFERELEASE(nickName)
    SAFERELEASE(sex)
    SAFERELEASE(where)
    SAFERELEASE(longitude)
    SAFERELEASE(latitude)
    SAFERELEASE(state)
    [super dealloc];
}
@end
