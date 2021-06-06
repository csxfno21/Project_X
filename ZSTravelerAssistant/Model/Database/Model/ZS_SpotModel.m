//
//  ZS_Spot.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_SpotModel.h"

@implementation ZS_SpotModel

- (NSArray*)getAllSpot
{
    NSMutableArray *spotTypeArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:SELECT_ALL_Spot];

    while ([rs next])
    {
        ZS_CustomizedSpot_entity *entity = [[ZS_CustomizedSpot_entity alloc]init];
        entity.ID = [rs intForColumn:@"ID"];
        entity.SpotID = ReplaceNULL2Empty([rs stringForColumn:@"SpotID"]);
        entity.SpotName = ReplaceNULL2Empty([rs stringForColumn:@"SpotName"]);
        entity.SpotContent = ReplaceNULL2Empty([rs stringForColumn:@"SpotContent"]);
        entity.SpotLength = ReplaceNULL2Empty([rs stringForColumn:@"SpotLength"]);
        entity.SpotStar = ReplaceNULL2Empty([rs stringForColumn:@"SpotStar"]);
        entity.SpotLng = ReplaceNULL2Empty([rs stringForColumn:@"SpotLng"]);
        entity.SpotLat = ReplaceNULL2Empty([rs stringForColumn:@"SpotLat"]);
        entity.SpotTickets = ReplaceNULL2Empty([rs stringForColumn:@"SpotTickets"]);
        entity.SpotImgUrl = ReplaceNULL2Empty([rs stringForColumn:@"SpotImgUrl"]);
        entity.SpotSmallUrl = ReplaceNULL2Empty([rs stringForColumn:@"SpotSmallUrl"]);
        entity.SpotImgName = ReplaceNULL2Empty([rs stringForColumn:@"SpotImgName"]);
        entity.SpotSmallImgName = ReplaceNULL2Empty([rs stringForColumn:@"SpotSmallImgName"]);
        entity.SpotType = ReplaceNULL2Empty([rs stringForColumn:@"SpotType"]);
        entity.SpotBuff = ReplaceNULL2Empty([rs stringForColumn:@"SpotBuff"]);
        entity.SpotParentID = ReplaceNULL2Empty([rs stringForColumn:@"SpotParentID"]);
        entity.DisToPosition = [PublicUtils GetDistanceS:[MapManager sharedInstanced].oldLocation2D.longitude withlat1:[MapManager sharedInstanced].oldLocation2D.latitude withlng2:[entity.SpotLng doubleValue] withlat2:[entity.SpotLat doubleValue]];
        [spotTypeArray addObject:entity];
        [entity release];
    }
    [rs close];
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"DisToPosition" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [spotTypeArray sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}
-(NSArray *)quarySpotByType:(int)type
{
    NSMutableArray *spotTypeArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_ALL_SpotType,type]];
    while ([rs next])
    {
        ZS_CustomizedSpot_entity *entity = [[ZS_CustomizedSpot_entity alloc]init];
        entity.ID = [rs intForColumn:@"ID"];
        entity.SpotID = ReplaceNULL2Empty([rs stringForColumn:@"SpotID"]);
        entity.SpotName = ReplaceNULL2Empty([rs stringForColumn:@"SpotName"]);
        entity.SpotContent = ReplaceNULL2Empty([rs stringForColumn:@"SpotContent"]);
        entity.SpotLength = ReplaceNULL2Empty([rs stringForColumn:@"SpotLength"]);
        entity.SpotStar = ReplaceNULL2Empty([rs stringForColumn:@"SpotStar"]);
        entity.SpotLng = ReplaceNULL2Empty([rs stringForColumn:@"SpotLng"]);
        entity.SpotLat = ReplaceNULL2Empty([rs stringForColumn:@"SpotLat"]);
        entity.SpotTickets = ReplaceNULL2Empty([rs stringForColumn:@"SpotTickets"]);
        entity.SpotImgUrl = ReplaceNULL2Empty([rs stringForColumn:@"SpotImgUrl"]);
        entity.SpotSmallUrl = ReplaceNULL2Empty([rs stringForColumn:@"SpotSmallUrl"]);
        entity.SpotImgName = ReplaceNULL2Empty([rs stringForColumn:@"SpotImgName"]);
        entity.SpotSmallImgName = ReplaceNULL2Empty([rs stringForColumn:@"SpotSmallImgName"]);
        entity.SpotType = ReplaceNULL2Empty([rs stringForColumn:@"SpotType"]);
        entity.SpotBuff = ReplaceNULL2Empty([rs stringForColumn:@"SpotBuff"]);
        entity.SpotParentID = ReplaceNULL2Empty([rs stringForColumn:@"SpotParentID"]);
        [spotTypeArray addObject:entity];
        [entity release];
    }
    [rs close];
    return spotTypeArray;
  
}
- (id)getSpotByName:(NSString *)spotName
{
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_Spot_Name,spotName]];
    ZS_CustomizedSpot_entity *entity = [[[ZS_CustomizedSpot_entity alloc]init] autorelease];
    while ([rs next])
    {
        entity.ID = [rs intForColumn:@"ID"];
        entity.SpotID = ReplaceNULL2Empty([rs stringForColumn:@"SpotID"]);
        entity.SpotName = ReplaceNULL2Empty([rs stringForColumn:@"SpotName"]);
        entity.SpotContent = ReplaceNULL2Empty([rs stringForColumn:@"SpotContent"]);
        entity.SpotLength = ReplaceNULL2Empty([rs stringForColumn:@"SpotLength"]);
        entity.SpotStar = ReplaceNULL2Empty([rs stringForColumn:@"SpotStar"]);
        entity.SpotLng = ReplaceNULL2Empty([rs stringForColumn:@"SpotLng"]);
        entity.SpotLat = ReplaceNULL2Empty([rs stringForColumn:@"SpotLat"]);
        entity.SpotTickets = ReplaceNULL2Empty([rs stringForColumn:@"SpotTickets"]);
        entity.SpotImgUrl = ReplaceNULL2Empty([rs stringForColumn:@"SpotImgUrl"]);
        entity.SpotSmallUrl = ReplaceNULL2Empty([rs stringForColumn:@"SpotSmallUrl"]);
        entity.SpotImgName = ReplaceNULL2Empty([rs stringForColumn:@"SpotImgName"]);
        entity.SpotSmallImgName = ReplaceNULL2Empty([rs stringForColumn:@"SpotSmallImgName"]);
        entity.SpotType = ReplaceNULL2Empty([rs stringForColumn:@"SpotType"]);
        entity.SpotBuff = ReplaceNULL2Empty([rs stringForColumn:@"SpotBuff"]);
        entity.SpotParentID = ReplaceNULL2Empty([rs stringForColumn:@"SpotParentID"]);
    }
    [rs close];

    return entity;
}
- (id)getSpotBySpotID:(NSString *)spotID
{
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_Spot_ID,spotID]];
    ZS_CustomizedSpot_entity *entity = [[[ZS_CustomizedSpot_entity alloc]init] autorelease];
    while ([rs next])
    {
        entity.ID = [rs intForColumn:@"ID"];
        entity.SpotID = ReplaceNULL2Empty([rs stringForColumn:@"SpotID"]);
        entity.SpotName = ReplaceNULL2Empty([rs stringForColumn:@"SpotName"]);
        entity.SpotContent = ReplaceNULL2Empty([rs stringForColumn:@"SpotContent"]);
        entity.SpotLength = ReplaceNULL2Empty([rs stringForColumn:@"SpotLength"]);
        entity.SpotStar = ReplaceNULL2Empty([rs stringForColumn:@"SpotStar"]);
        entity.SpotLng = ReplaceNULL2Empty([rs stringForColumn:@"SpotLng"]);
        entity.SpotLat = ReplaceNULL2Empty([rs stringForColumn:@"SpotLat"]);
        entity.SpotTickets = ReplaceNULL2Empty([rs stringForColumn:@"SpotTickets"]);
        entity.SpotImgUrl = ReplaceNULL2Empty([rs stringForColumn:@"SpotImgUrl"]);
        entity.SpotSmallUrl = ReplaceNULL2Empty([rs stringForColumn:@"SpotSmallUrl"]);
        entity.SpotImgName = ReplaceNULL2Empty([rs stringForColumn:@"SpotImgName"]);
        entity.SpotSmallImgName = ReplaceNULL2Empty([rs stringForColumn:@"SpotSmallImgName"]);
        entity.SpotType = ReplaceNULL2Empty([rs stringForColumn:@"SpotType"]);
        entity.SpotBuff = ReplaceNULL2Empty([rs stringForColumn:@"SpotBuff"]);
        entity.SpotParentID = ReplaceNULL2Empty([rs stringForColumn:@"SpotParentID"]);
    }
    [rs close];
    
    return entity;
}

- (NSString*) getSpotBufferByID:(int)ID
{
    FMDatabase *db = [FMDatabase sharedDataBase];
    NSString *strID = [NSString stringWithFormat:@"%d",ID];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_SpotBufferByID,strID]];
    NSString *Buffer = @"";
    while ([rs next])
    {
        Buffer = ReplaceNULL2Empty([rs stringForColumn:@"SpotBuff"]);
    }
    [rs close];
    
    return Buffer;
}
-(BOOL)updateSpot:(NSArray *)data
{
    BOOL success = NO;
    if (nil == data)
    {
        return success;
    }
    
    FMDatabase *db = [FMDatabase sharedDataBase];
    [db beginTransaction];
    [db executeUpdate:DELETE_Spot];
    for (ZS_CustomizedSpot_entity *entity in data)
    {
        [db executeUpdate:INSERT_Spot,entity.SpotID,entity.SpotName,entity.SpotStar,entity.SpotLng,entity.SpotLat,entity.SpotTickets,entity.SpotLength,entity.SpotContent,entity.SpotImgUrl,entity.SpotSmallUrl,entity.SpotImgName,entity.SpotSmallImgName,entity.SpotType,entity.SpotBuff,entity.SpotParentID,nil];
    }
    success = [db commit];
    
    return success;
}
-(NSArray *)quarySpotsDetailByIDs:(NSArray *)SpotIDs
{
    NSString *sql = @"";
    for (NSString* spotID in SpotIDs)
    {
        if(sql.length == 0)
            sql = [NSString stringWithFormat:@"SpotID = %@",spotID];
        else
            sql = [NSString stringWithFormat:@"%@ OR SpotID = %@",sql,spotID];
    }
    NSMutableArray *spotArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_Spots_Detail,sql]];
    while ([rs next])
    {
        ZS_CustomizedSpot_entity *entity = [[ZS_CustomizedSpot_entity alloc]init];
        entity.ID = [rs intForColumn:@"ID"];
        entity.SpotID = ReplaceNULL2Empty([rs stringForColumn:@"SpotID"]);
        entity.SpotName = ReplaceNULL2Empty([rs stringForColumn:@"SpotName"]);
        entity.SpotContent = ReplaceNULL2Empty([rs stringForColumn:@"SpotContent"]);
        entity.SpotLength = ReplaceNULL2Empty([rs stringForColumn:@"SpotLength"]);
        entity.SpotStar = ReplaceNULL2Empty([rs stringForColumn:@"SpotStar"]);
        entity.SpotLng = ReplaceNULL2Empty([rs stringForColumn:@"SpotLng"]);
        entity.SpotLat = ReplaceNULL2Empty([rs stringForColumn:@"SpotLat"]);
        entity.SpotTickets = ReplaceNULL2Empty([rs stringForColumn:@"SpotTickets"]);
        entity.SpotImgUrl = ReplaceNULL2Empty([rs stringForColumn:@"SpotImgUrl"]);
        entity.SpotSmallUrl = ReplaceNULL2Empty([rs stringForColumn:@"SpotSmallUrl"]);
        entity.SpotImgName = ReplaceNULL2Empty([rs stringForColumn:@"SpotImgName"]);
        entity.SpotSmallImgName = ReplaceNULL2Empty([rs stringForColumn:@"SpotSmallImgName"]);
        entity.SpotType = ReplaceNULL2Empty([rs stringForColumn:@"SpotType"]);
        entity.SpotBuff = ReplaceNULL2Empty([rs stringForColumn:@"SpotBuff"]);
        entity.SpotParentID = ReplaceNULL2Empty([rs stringForColumn:@"SpotParentID"]);
        
        [spotArray addObject:entity];
        [entity release];
    }
    [rs close];
    NSMutableArray *resArray = [NSMutableArray array];
    for (NSString* spotID in SpotIDs)
    {
        for (ZS_CustomizedSpot_entity *entity in spotArray)
        {
            if ([spotID isEqualToString:entity.SpotID])
            {
                [resArray addObject:entity];
            }
        }

    }
    [spotArray removeAllObjects];
    return resArray;
}
@end
