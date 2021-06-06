//
//  ZS_Scenic_Buffer_Model.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-27.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_Scenic_Buffer_Model.h"

@implementation ZS_Scenic_Buffer_Model


- (NSArray*)getSpeakContentByType:(SCENIC_TYPE)type
{
    NSMutableArray *array = [NSMutableArray array];
    
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_SpeakContent_BY_TYPE,type]];
    while (rs.next)
    {
        NSString *speakContentIn = ReplaceNULL2Empty([rs stringForColumn:@"SpeakContentIn"]);
        NSString *speakContentOut = ReplaceNULL2Empty([rs stringForColumn:@"SpeakContentOut"]);
        
        [array addObject:speakContentIn];
        [array addObject:speakContentOut];
    }
    [rs close];
    return array;
}

- (ZS_Scenic_Buffer_entity*)getBufferByType:(SCENIC_TYPE)type
{
    ZS_Scenic_Buffer_entity *entity = [[ZS_Scenic_Buffer_entity alloc] init];
    
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_SCENIC_BY_TYPE,type]];
    
    while (rs.next)
    {
        entity.ID = [rs intForColumn:@"ID"];
        entity.spotID = ReplaceNULL2Empty([rs stringForColumn:@"SpotID"]);
        entity.ScenicName = ReplaceNULL2Empty([rs stringForColumn:@"ViewName"]);
        entity.BufferIn = ReplaceNULL2Empty([rs stringForColumn:@"BufferIn"]);
        entity.BufferOut = ReplaceNULL2Empty([rs stringForColumn:@"BufferOut"]);
        
    }
    [rs close];
    
    return [entity autorelease];
}

- (BOOL)isScenic:(int)ID
{
    BOOL bReturn = NO;
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_SECNIC_COUNT_BY_ID,ID]];
    while (rs.next)
    {
        int cnt = [rs intForColumn:@"cnt"];
        if (cnt != 0)
        {
            bReturn = YES;
        }
    }
    return bReturn;
}

- (BOOL)updateScenicInfo:(NSArray*)data
{
    BOOL success = NO;
    if (nil == data)
    {
        return success;
    }
    
    FMDatabase *db = [FMDatabase sharedDataBase];
    [db beginTransaction];
    [db executeUpdate:DELETE_Scenic];
    for (ZS_Scenic_Buffer_entity *entity in data)
    {
        [db executeUpdate:INSERT_Scenic,entity.spotID,entity.ScenicName,entity.BufferIn,entity.BufferOut,entity.SpeakContentIn,entity.SpeakContentOut,nil];
    }
    success = [db commit];
    
    return success;
}
@end
