//
//  ZS_TableVersion.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-9.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_TableVersion.h"

@implementation ZS_TableVersion


-(NSArray *)getVersion
{
    NSMutableArray *versionArray = [NSMutableArray array];
    FMDatabase *db = [FMDatabase sharedDataBase];
    FMResultSet *rs = [db executeQuery:SELECT_ALL_Version];
    while ([rs next])
    {
        ZS_TableVersion_entity *entity = [[ZS_TableVersion_entity alloc]init];
        //        entity.ID = ReplaceNULL2Empty([rs intForColumn:@"ID"]);
        entity.tableName = ReplaceNULL2Empty([rs stringForColumn:@"TableName"]);
        entity.tableVersion = ReplaceNULL2Empty([rs stringForColumn:@"TableVersion"]);
        
        [versionArray addObject:entity];
        [entity release];
    }
    [rs close];
    return versionArray;
}
-(BOOL)updateTableVersion:(NSString*)tableName withVersion:(NSString*)version
{
    BOOL success = NO;
    if (nil == tableName || nil == version)
    {
        return success;
    }
    
    FMDatabase *db = [FMDatabase sharedDataBase];
    [db beginTransaction];
    NSString *sql = [NSString stringWithFormat:UPDATE_TABLE_VERSION,version,tableName];
    NSLog(@"SQL  %@",sql);
    [db executeUpdate:sql];
   
    success = [db commit];
    
    return success;
}

@end
