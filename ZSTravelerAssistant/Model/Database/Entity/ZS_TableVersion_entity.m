//
//  ZS_TableVersion.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-9.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_TableVersion.h"

@implementation ZS_TableVersion_entity
@synthesize ID,tableName,tableVersion,UpdataCount;

-(void)dealloc
{
    SAFERELEASE(tableName)
    SAFERELEASE(tableVersion)
    [super dealloc];
}
@end
