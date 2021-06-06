//
//  SpotManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseRequestManager.h"

@interface SpotManager : BaseRequestManager

@property(nonatomic,readonly)NSMutableArray *viewSpotCache;
@property(nonatomic,readonly)NSMutableArray *nviewSpotCache;
@property(nonatomic,readonly)NSMutableArray *downLoadCache;
+(SpotManager *)sharedInstance;
- (void)requestGetSpot:(id)UIDelegate withInfoID:(int)infoID;
- (void)requestGetViewSpot:(id)UIDelegate;
- (void)requestGetViewSpot:(id)UIDelegate withMoreID:(int)moreID;
@end
