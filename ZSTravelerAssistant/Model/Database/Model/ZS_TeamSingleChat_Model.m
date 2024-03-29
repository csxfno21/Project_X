//
//  ZS_SingleChat_Model.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_TeamSingleChat_Model.h"

@implementation ZS_TeamSingleChat_Model

-(NSArray*)quaryAllSingleChat
{
    NSMutableArray *array = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:SELECT_ALL_SINGLECHAT];
    while ([rs next])
    {
        ZS_TeamSingleChat_entity *entity = [[ZS_TeamSingleChat_entity alloc] init];
        entity.ID = [rs intForColumn:@"ID"];
        
        entity.SenderID = ReplaceNULL2Empty([rs stringForColumn:@"SenderID"]);
        entity.ReceiveID = ReplaceNULL2Empty([rs stringForColumn:@"ReceiveID"]);
        entity.ReceiveName = ReplaceNULL2Empty([rs stringForColumn:@"ReceiveName"]);
        entity.TeamID = ReplaceNULL2Empty([rs stringForColumn:@"TeamID"]);
        entity.ChatContent = ReplaceNULL2Empty([rs stringForColumn:@"ChatContent"]);
        entity.ChatTime = ReplaceNULL2Empty([rs stringForColumn:@"ChatTime"]);
        entity.messageState = 1;
        [array addObject:entity];
        [entity release];
    }
    [rs close];
    return array;
}
-(ZS_TeamSingleChat_entity *)quraySingleChatByID:(int)ID
{
    ZS_TeamSingleChat_entity *entity = [[[ZS_TeamSingleChat_entity alloc] init] autorelease];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_SINGLE_SINGLECHA,ID]];
    while ([rs next])
    {
        entity.ID = [rs intForColumn:@"ID"];
        entity.SenderID = ReplaceNULL2Empty([rs stringForColumn:@"SenderID"]);
        entity.ReceiveID = ReplaceNULL2Empty([rs stringForColumn:@"ReceiveID"]);
        entity.ReceiveName = ReplaceNULL2Empty([rs stringForColumn:@"ReceiveName"]);
        entity.TeamID = ReplaceNULL2Empty([rs stringForColumn:@"TeamID"]);
        entity.ChatContent = ReplaceNULL2Empty([rs stringForColumn:@"ChatContent"]);
        entity.ChatTime = ReplaceNULL2Empty([rs stringForColumn:@"ChatTime"]);
        entity.messageState = 1;
    }
    [rs close];
    return entity;
}
-(BOOL)updateSingleChat:(NSArray *)data
{
    BOOL success = NO;
    if (nil == data)
    {
        return success;
    }
    FMDatabase *db = [FMDatabase sharedDataBase];
    [db beginTransaction];
    for (ZS_TeamSingleChat_entity *entity in data)
    {
        [db executeUpdate:INSERT_SINGLECHAT,entity.TeamID,entity.SenderID,entity.ChatContent,entity.ChatTime,entity.ReceiveID,entity.ReceiveName];
    }
    success = [db commit];
    return success;
}
@end
