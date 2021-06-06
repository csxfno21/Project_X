//
//  ZS_AroundModel.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZS_Around_entity.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "SQLConstans.h"

@interface ZS_AroundModel : NSObject

-(ZS_Around_entity *)quaryAroundByID:(NSString *)ID;
-(NSMutableArray *)quaryAllAroundByID;
@end
