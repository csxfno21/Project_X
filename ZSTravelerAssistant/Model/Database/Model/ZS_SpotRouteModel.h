//
//  ZS_SpotRoute.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZS_SpotRoute_entity.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "SQLConstans.h"

@interface ZS_SpotRouteModel : NSObject

-(NSArray *)quaryRoute:(int)type;
- (BOOL)updateSpotRoute:(NSArray*)data;

@end
