//
//  ZS_TeamChat_Model.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-11.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_TeamChat_Model.h"

@implementation ZS_TeamChat_Model

-(NSArray *)quaryAllTeamChat
{
    NSMutableArray *array = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:SELECT_ALL_TEAMCHAT];
    while ([rs next])
    {
        ZS_TeamChat_entity *entity = [[ZS_TeamChat_entity alloc] init];
        entity.ID = [rs intForColumn:@"ID"];
        entity.ChatCreator = ReplaceNULL2Empty([rs stringForColumn:@"ChatCreator"]);
        entity.ChatCreatorID = ReplaceNULL2Empty([rs stringForColumn:@"ChatCreatorID"]);
        entity.ChatNameID = ReplaceNULL2Empty([rs stringForColumn:@"ChatNameID"]);
        entity.ChatName = ReplaceNULL2Empty([rs stringForColumn:@"ChatName"]);
        [array addObject:entity];
        [entity release];
    }
    [rs close];
    return array;
}
-(ZS_TeamChat_entity *)quaryTeamChatByID:(int)ID
{
    ZS_TeamChat_entity *entity = [[[ZS_TeamChat_entity alloc] init] autorelease];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_SINGLE_TEAMCHAT,ID]];
    while ([rs next])
    {
        entity.ID = [rs intForColumn:@"ID"];
        entity.ChatCreator = ReplaceNULL2Empty([rs stringForColumn:@"ChatCreator"]);
        entity.ChatCreatorID = ReplaceNULL2Empty([rs stringForColumn:@"ChatCreatorID"]);
        entity.ChatNameID = ReplaceNULL2Empty([rs stringForColumn:@"ChatNameID"]);
        entity.ChatName = ReplaceNULL2Empty([rs stringForColumn:@"ChatName"]);
    }
    [rs close];
    return entity;
}
-(BOOL)updateTeamChat:(NSArray *)data
{
    BOOL success = NO;
    if (nil == data)
    {
        return success;
    }
    FMDatabase *db = [FMDatabase sharedDataBase];
    [db beginTransaction];
    [db executeUpdate:DELETE_ALL_TEAMCHAT];
    for (ZS_TeamChat_entity *entity in data)
    {
        [db executeUpdate:INSERT_TEAMCHAT,entity.ID,entity.ChatCreator,entity.ChatCreatorID,entity.ChatNameID,entity.ChatName];
    }
    success = [db commit];
    return success;
}

@end
