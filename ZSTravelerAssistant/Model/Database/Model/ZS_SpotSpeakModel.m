//
//  ZS_SpotSpeakModel.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-24.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_SpotSpeakModel.h"

@implementation ZS_SpotSpeakModel

- (BOOL)updateSpeakInfo:(NSArray*)data
{
    BOOL success = NO;
    if (nil == data)
    {
        return success;
    }
    
    FMDatabase *db = [FMDatabase sharedDataBase];
    [db beginTransaction];
    [db executeUpdate:DELETE_Speak];
    for (ZS_SpotSpeak_Entity *entity in data)
    {
        [db executeUpdate:INSERT_Speak,entity.SpotID,entity.SpotName,entity.SpeakSpotContent,entity.SpotBuffer,entity.SpotParentID,nil];
    }
    success = [db commit];
    
    return success;
}

-(NSArray *)getAllSpotSpeak
{
    NSMutableArray *speakArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:SELECT_ALL_SPOT_SPEAK];
    while ([rs next])
    {
        ZS_SpotSpeak_Entity *entity = [[ZS_SpotSpeak_Entity alloc]init];
        entity.ID = [rs intForColumn:@"ID"];
//        entity.SpeakSpotContent = ReplaceNULL2Empty([rs stringForColumn:@"SpeakSpotContent"]);
        entity.SpotID = ReplaceNULL2Empty([rs stringForColumn:@"SpotID"]);
        entity.SpotBuffer = ReplaceNULL2Empty([rs stringForColumn:@"SpotBuffer"]);
        entity.SpotName = ReplaceNULL2Empty([rs stringForColumn:@"SpotName"]);
        entity.SpotParentID = ReplaceNULL2Empty([rs stringForColumn:@"SpotParentID"]);
        [speakArray addObject:entity];
        [entity release];
    }
    [rs close];
    return speakArray;
}

- (NSArray *)getSpotSpeakByType:(SCENIC_TYPE)type
{
    NSString* strSql;
    switch (type) {
        case SCENIC_MXL:
            strSql = SELECT_MXL_SPOT_SPEAK;
            break;
        case SCENIC_ZSL:
            strSql = SELECT_ZSL_SPOT_SPEAK;
            break;
        case SCENIC_LGS:
            strSql = SELECT_LGS_SPOT_SPEAK;
            break;
        case SCENIC_IN:
            strSql = SELECT_ZB_SPOT_SPEAK;
            break;
            
        default:
            strSql = SELECT_ALL_SPOT_SPEAK;
            break;
    }
    
    NSMutableArray *speakArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:strSql];
    while ([rs next])
    {
        ZS_SpotSpeak_Entity *entity = [[ZS_SpotSpeak_Entity alloc]init];
        entity.ID = [rs intForColumn:@"ID"];
        //        entity.SpeakSpotContent = ReplaceNULL2Empty([rs stringForColumn:@"SpeakSpotContent"]);
        entity.SpotID = ReplaceNULL2Empty([rs stringForColumn:@"SpotID"]);
        entity.SpotBuffer = ReplaceNULL2Empty([rs stringForColumn:@"SpotBuffer"]);
        entity.SpotName = ReplaceNULL2Empty([rs stringForColumn:@"SpotName"]);
        entity.SpotParentID = ReplaceNULL2Empty([rs stringForColumn:@"SpotParentID"]);
        [speakArray addObject:entity];
        [entity release];
    }
    [rs close];
    return speakArray;
}

-(NSString *)getSpeakSpotContent:(int)SpotID
{
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_SPEAK_SPOT_CONTENT_BYID,SpotID]];
    NSString *res = @"";
    while ([rs next])
    {
        res = ReplaceNULL2Empty([rs stringForColumn:@"SpeakSpotContent"]);
    }
    [rs close];
    return res;;
}

@end
