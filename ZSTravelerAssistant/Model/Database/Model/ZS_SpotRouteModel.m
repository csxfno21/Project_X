//
//  ZS_SpotRoute.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_SpotRouteModel.h"

@implementation ZS_SpotRouteModel

-(NSArray *)quaryRoute:(int)type
{
    NSMutableArray *spotrouteArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_ALL_SpotRoute,type]];

    while ([rs next])
    {
        ZS_SpotRoute_entity *entity = [[ZS_SpotRoute_entity alloc]init];
        entity.ID =  [rs intForColumn:@"ID"];
        entity.RouteType = ReplaceNULL2Empty([rs stringForColumn:@"RouteType"]);
        entity.RouteTitle = ReplaceNULL2Empty([rs stringForColumn:@"RouteTitle"]);
        entity.RouteLength = ReplaceNULL2Empty([rs stringForColumn:@"RouteLength"]);
        entity.RouteTime = ReplaceNULL2Empty([rs stringForColumn:@"RouteTime"]);
        entity.RouteSmallImgUrl = ReplaceNULL2Empty([rs stringForColumn:@"RouteSmallImgUrl"]);
        entity.RouteSmallImgName = ReplaceNULL2Empty([rs stringForColumn:@"RouteSmallImgName"]);
        entity.RouteImageUrl = ReplaceNULL2Empty([rs stringForColumn:@"RouteImageUrl"]);
        entity.RouteImageName = ReplaceNULL2Empty([rs stringForColumn:@"RouteImageName"]);
        entity.RouteContent = ReplaceNULL2Empty([rs stringForColumn:@"RouteContent"]);
        entity.RouteTicket = ReplaceNULL2Empty([rs stringForColumn:@"RouteTicket"]);
        entity.RouteList = ReplaceNULL2Empty([rs stringForColumn:@"RouteList"]);
        
        [spotrouteArray addObject:entity];
        [entity release];
    }
    [rs close];
    return spotrouteArray;
}

-(BOOL)updateSpotRoute:(NSArray *)data
{
    BOOL success = NO;
    if (nil == data)
    {
        return success;
    }
    
    FMDatabase *db = [FMDatabase sharedDataBase];
    [db beginTransaction];
    [db executeUpdate:DELETE_SpotRoute];
    for (ZS_SpotRoute_entity *entity in data)
    {
        [db executeUpdate:INSERT_SpotRoute,entity.RouteLength,entity.RouteTime,entity.RouteTicket,entity.RouteTitle,entity.RouteContent,entity.RouteType,entity.RouteSmallImgUrl,entity.RouteSmallImgName,entity.RouteList,entity.RouteImageUrl,entity.RouteImageName,nil];
    }
    success = [db commit];
    
    return success;
}

@end