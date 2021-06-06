//
//  ZS_Traffic.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "SQLConstans.h"
#import "ZS_Traffic_entity.h"

@interface ZS_TrafficModel : NSObject

- (NSArray *)getAllBusInfo;
- (NSArray *)getAllTourisCarInfo;
- (BOOL)updateTrafficInfo:(NSArray*)data;
@end
