//
//  ZS_Traffic.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_TrafficModel.h"

@implementation ZS_TrafficModel

- (NSArray *)getAllBusInfo
{
    NSMutableArray *trafficArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_ALL_Traffic,1]];
    while ([rs next])
    {
        ZS_Traffic_entity *entity = [[ZS_Traffic_entity alloc]init];
        entity.ID = [rs intForColumn:@"ID"];
        entity.TrafficName = ReplaceNULL2Empty([rs stringForColumn:@"TrafficName"]);
        entity.TrafficStartTime = ReplaceNULL2Empty([rs stringForColumn:@"TrafficStartTime"]);
        entity.TrafficEndTime = ReplaceNULL2Empty([rs stringForColumn:@"TrafficEndTime"]);
        entity.TrafficDetail = ReplaceNULL2Empty([rs stringForColumn:@"TrafficDetail"]);
        entity.TrafficRemark = ReplaceNULL2Empty([rs stringForColumn:@"TrafficRemark"]);
        entity.TrafficPrice = ReplaceNULL2Empty([rs stringForColumn:@"TrafficTicket"]);
        entity.TrafficName = ReplaceNULL2Empty([rs stringForColumn:@"TrafficName"]);
        
        [trafficArray addObject:entity];
        [entity release];
    }
    [rs close];
    return trafficArray;
}
- (NSArray *)getAllTourisCarInfo
{
    NSMutableArray *trafficArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_ALL_Traffic,2]];
    while ([rs next])
    {
        ZS_Traffic_entity *entity = [[ZS_Traffic_entity alloc]init];
        entity.ID = [rs intForColumn:@"ID"];
        entity.TrafficName = ReplaceNULL2Empty([rs stringForColumn:@"TrafficName"]);
        entity.TrafficStartTime = ReplaceNULL2Empty([rs stringForColumn:@"TrafficStartTime"]);
        entity.TrafficEndTime = ReplaceNULL2Empty([rs stringForColumn:@"TrafficEndTime"]);
        entity.TrafficDetail = ReplaceNULL2Empty([rs stringForColumn:@"TrafficDetail"]);
        entity.TrafficRemark = ReplaceNULL2Empty([rs stringForColumn:@"TrafficRemark"]);
        entity.TrafficPrice = ReplaceNULL2Empty([rs stringForColumn:@"TrafficTicket"]);
        entity.TrafficName = ReplaceNULL2Empty([rs stringForColumn:@"TrafficName"]);
        
        [trafficArray addObject:entity];
        [entity release];
    }
    [rs close];
    return trafficArray;
}
- (BOOL)updateTrafficInfo:(NSArray*)data
{
    BOOL success = NO;
    if (nil == data)
    {
        return success;
    }
    
    FMDatabase *db = [FMDatabase sharedDataBase];
    [db beginTransaction];
    [db executeUpdate:DELETE_Traffic];
    for (ZS_Traffic_entity *entity in data)
    {
        [db executeUpdate:INSERT_Traffic,entity.TrafficName,entity.TrafficStartTime,entity.TrafficEndTime,entity.TrafficDetail,entity.TrafficRemark,entity.TrafficPrice,entity.TrafficType,nil];
    }
    success = [db commit];
    
    return success;

}
@end
