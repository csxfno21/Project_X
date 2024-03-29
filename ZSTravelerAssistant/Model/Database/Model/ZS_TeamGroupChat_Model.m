//
//  ZS_GroupChat_Model.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_TeamGroupChat_Model.h"

@implementation ZS_TeamGroupChat_Model

-(NSArray *)quaryAllGroupChat
{
    NSMutableArray *array = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:SELECT_ALL_GROUPCHAT];
    while ([rs next])
    {
        ZS_TeamGroupChat_entity *entity = [[ZS_TeamGroupChat_entity alloc] init];
        entity.ID = [rs intForColumn:@"ID"];
        entity.TeamID = ReplaceNULL2Empty([rs stringForColumn:@"TeamID"]);
        entity.SenderID = ReplaceNULL2Empty([rs stringForColumn:@"SenderID"]);
        entity.ChatContent = ReplaceNULL2Empty([rs stringForColumn:@"ChatContent"]);
        entity.ChatTime = ReplaceNULL2Empty([rs stringForColumn:@"ChatTime"]);
        entity.SenderName = ReplaceNULL2Empty([rs stringForColumn:@"SenderName"]);
        entity.messageState = 1;
        [array addObject:entity];
        [entity release];
    }
    [rs close];
    return array;
}
-(ZS_TeamGroupChat_entity *)quaryGropuChatByID:(int)ID
{
    ZS_TeamGroupChat_entity *entity = [[[ZS_TeamGroupChat_entity alloc] init] autorelease];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_SINGLE_GROUPCHAT,ID]];
    while ([rs next])
    {
        entity.ID = [rs intForColumn:@"ID"];
        entity.TeamID = ReplaceNULL2Empty([rs stringForColumn:@"TeamID"]);
        entity.SenderID = ReplaceNULL2Empty([rs stringForColumn:@"SenderID"]);
        entity.ChatContent = ReplaceNULL2Empty([rs stringForColumn:@"ChatContent"]);
        entity.ChatTime = ReplaceNULL2Empty([rs stringForColumn:@"ChatTime"]);
        entity.SenderName = ReplaceNULL2Empty([rs stringForColumn:@"SenderName"]);
        entity.messageState = 1;
    }
    [rs close];
    return entity;
}
-(BOOL)updateGroupChat:(NSArray *)data
{
    BOOL success = NO;
    if (nil == data)
    {
        return success;
    }
    FMDatabase *db = [FMDatabase sharedDataBase];
    [db beginTransaction];
    for (ZS_TeamGroupChat_entity *entity in data)
    {
        [db executeUpdate:INSERT_GROUPCHAT,entity.TeamID,entity.SenderID,entity.ChatContent,entity.ChatTime,entity.SenderName];
    }
    success = [db commit];
    return success;
}
@end
