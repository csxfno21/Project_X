//
//  ZS_Recommending.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZS_RecommendImg_entity.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "SQLConstans.h"

@interface ZS_RecommendModel : NSObject

-(NSMutableArray *)quaryAllRecommend;
- (BOOL)updateRecommend:(NSArray *)data;
@end
