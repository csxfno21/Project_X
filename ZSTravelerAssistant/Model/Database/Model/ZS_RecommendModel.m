//
//  ZS_Recommending.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_RecommendModel.h"

@implementation ZS_RecommendModel

-(NSMutableArray *)quaryAllRecommend
{
    NSMutableArray *recommendArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:SELECT_ALL_Recommend];
    while ([rs next])
    {
        ZS_RecommendImg_entity *entity = [[ZS_RecommendImg_entity alloc]init];
        entity.ID = [rs intForColumn:@"ID"];
        entity.SpotID = ReplaceNULL2Empty([rs stringForColumn:@"SpotID"]);
        entity.ImageName = ReplaceNULL2Empty([rs stringForColumn:@"ImageName"]);
        entity.ImgUrl = ReplaceNULL2Empty([rs stringForColumn:@"ImgUrl"]);
        
        [recommendArray addObject:entity];
        [entity release];
    }
    [rs close];
    
    return recommendArray;
}
- (BOOL)updateRecommend:(NSArray *)data
{
    BOOL success = NO;
    if (nil == data)
    {
        return success;
    }
    
    FMDatabase *db = [FMDatabase sharedDataBase];
    [db beginTransaction];
    [db executeUpdate:DELETE_Recommend];
    for (ZS_RecommendImg_entity *entity in data)
    {
        [db executeUpdate:INSERT_Recommend,entity.SpotID,entity.ImageName,entity.ImgUrl,nil];
    }
    success = [db commit];
    
    return success;
}
@end
