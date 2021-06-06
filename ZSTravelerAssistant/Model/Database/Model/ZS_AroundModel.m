//
//  ZS_AroundModel.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_AroundModel.h"

@implementation ZS_AroundModel

-(ZS_Around_entity *)quaryAroundByID:(NSString *)ID
{
    ZS_Around_entity *entity = [[[ZS_Around_entity alloc]init]autorelease];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:SELECT_SINGLE_Around,ID]];
    while (rs)
    {
//        entity.ID = ReplaceNULL2Empty([rs intForColumn:@"ID"]);
        entity.Type = ReplaceNULL2Empty([rs stringForColumn:@"Type"]);
        entity.Title = ReplaceNULL2Empty([rs stringForColumn:@"Title"]);
        entity.Lng = ReplaceNULL2Empty([rs stringForColumn:@"Lng"]);
        entity.Lat = ReplaceNULL2Empty([rs stringForColumn:@"Lat"]);
        entity.Address = ReplaceNULL2Empty([rs stringForColumn:@"Adress"]);
        entity.Business = ReplaceNULL2Empty([rs stringForColumn:@"Business"]);
        entity.DetailedBusiness = ReplaceNULL2Empty([rs stringForColumn:@"DetailedBusiness"]);
        entity.ImgUrl = ReplaceNULL2Empty([rs stringForColumn:@"ImgUrl"]);
         
    }
    [rs close];

    return entity;
}
-(NSMutableArray *)quaryAllAroundByID
{
    NSMutableArray *aroundArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:SELECT_ALL_Around];
    while ([rs next])
    {
        ZS_Around_entity *entity = [[ZS_Around_entity alloc]init];
//        entity.ID = ReplaceNULL2Empty([rs intForColumn:@"ID"]);
        entity.Type = ReplaceNULL2Empty([rs stringForColumn:@"Type"]);
        entity.Title = ReplaceNULL2Empty([rs stringForColumn:@"Title"]);
        entity.Lng = ReplaceNULL2Empty([rs stringForColumn:@"Lng"]);
        entity.Lat = ReplaceNULL2Empty([rs stringForColumn:@"Lat"]);
        entity.Address = ReplaceNULL2Empty([rs stringForColumn:@"Adress"]);
        entity.Business = ReplaceNULL2Empty([rs stringForColumn:@"Business"]);
        entity.DetailedBusiness = ReplaceNULL2Empty([rs stringForColumn:@"DetailedBusiness"]);
        entity.ImgUrl = ReplaceNULL2Empty([rs stringForColumn:@"ImgUrl"]);
        [aroundArray addObject:entity];
        [entity release];
    }
    [rs close];
    
    return aroundArray;
}
@end
