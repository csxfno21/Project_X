//
//  ZS_TableVersion.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-9.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLConstans.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "ZS_TableVersion_entity.h"

@interface ZS_TableVersion : NSObject

-(NSArray *)getVersion;
-(BOOL)updateTableVersion:(NSString*)tableName withVersion:(NSString*)version;
@end
