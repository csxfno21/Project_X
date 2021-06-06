//
//  TrafficManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseRequestManager.h"

@interface TrafficManager : BaseRequestManager
@property(nonatomic,readonly)NSMutableArray *busInfoCache;
@property(nonatomic,readonly)NSMutableArray *tourisCarInfoCache;
@property(nonatomic,readonly)NSMutableArray *downLoadCache;
+(TrafficManager *)sharedInstance;

- (void)requestGetBusInfo :(id)UIDelegate;
- (void)requestGetBusInfo :(id)UIDelegate withMoreID:(int)moreID;
- (void)requestGetTourisCarInfo:(id)UIDelegate;
- (void)requestGetTourisCarInfo :(id)UIDelegate withMoreID:(int)moreID;
- (void)requestGetTraffic:(id)UIDelegate withInfoID:(int)infoID;
@end
