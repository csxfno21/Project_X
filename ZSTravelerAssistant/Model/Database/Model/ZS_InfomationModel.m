//
//  ZS_Infomation.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_InfomationModel.h"
#import "SQLConstans.h"

@implementation ZS_InfomationModel

-(ZS_Infomation_entity *)quaryInfoByID:(NSString *)ID
{
    ZS_Infomation_entity *entity = [[[ZS_Infomation_entity alloc]init]autorelease];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:SELECT_ALL_Infomation];
    while (rs)
    {
        entity.ID = [rs intForColumn:@"ID"];
        entity.InfoTitle = ReplaceNULL2Empty([rs stringForColumn:@"InfoTitle"]);
        entity.InfoImgUrl = ReplaceNULL2Empty([rs stringForColumn:@"InfoImgUrl"]);
        entity.InfoImgName = ReplaceNULL2Empty([rs stringForColumn:@"InfoImgName"]);
        entity.InfoType = ReplaceNULL2Empty([rs stringForColumn:@"InfoType"]);
        entity.InfoContent = ReplaceNULL2Empty([rs stringForColumn:@"InfoContent"]);
        entity.SmallImageUrl = ReplaceNULL2Empty([rs stringForColumn:@"SmallImageUrl"]);
        entity.SmallImageName = ReplaceNULL2Empty([rs stringForColumn:@"SmallImageName"]);
    }
    [rs close];

    return entity;
}
-(NSMutableArray *)quaryAllInfoByType:(int)type
{
    NSMutableArray *allInfoArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_ALL_Infomation,type]];
    while ([rs next])
    {
        ZS_Infomation_entity *entity = [[ZS_Infomation_entity alloc]init];
        entity.ID = [rs intForColumn:@"ID"];
        entity.InfoTitle = ReplaceNULL2Empty([rs stringForColumn:@"InfoTitle"]);
        entity.InfoImgUrl = ReplaceNULL2Empty([rs stringForColumn:@"InfoImgUrl"]);
        entity.InfoImgName = ReplaceNULL2Empty([rs stringForColumn:@"InfoImgName"]);
        entity.InfoType = ReplaceNULL2Empty([rs stringForColumn:@"InfoType"]);
        entity.InfoContent = ReplaceNULL2Empty([rs stringForColumn:@"InfoContent"]);
        entity.SmallImageUrl = ReplaceNULL2Empty([rs stringForColumn:@"SmallImageUrl"]);
        entity.SmallImageName = ReplaceNULL2Empty([rs stringForColumn:@"SmallImageName"]);
        [allInfoArray addObject:entity];
        [entity release];
    }
    [rs close];
    
    return allInfoArray;
}


- (BOOL)updateInfo:(NSArray*)data
{
    BOOL success = NO;
    if (nil == data)
    {
        return success;
    }
    
    FMDatabase *db = [FMDatabase sharedDataBase];
    [db beginTransaction];
    [db executeUpdate:DELETE_Information];
    for (ZS_Infomation_entity *entity in data)
    {
        [db executeUpdate:INSERT_Information,entity.InfoTitle,entity.InfoContent,entity.InfoImgUrl,entity.InfoImgName,entity.InfoType,entity.SmallImageUrl,entity.SmallImageName,nil];
    }
    success = [db commit];
    
    return success;
}
@end
