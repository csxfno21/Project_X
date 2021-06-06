//
//  ZS_Infomation.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZS_Infomation_entity.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "SQLConstans.h"

@interface ZS_InfomationModel : NSObject

-(ZS_Infomation_entity *)quaryInfoByID:(NSString *)ID;
-(NSMutableArray *)quaryAllInfoByType:(int)type;
- (BOOL)updateInfo:(NSArray*)data;
@end
