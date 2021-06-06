//
//  SpotRouteManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseRequestManager.h"

@interface SpotRouteManager : BaseRequestManager
@property(nonatomic,readonly)NSMutableArray *themRouteCache;
@property(nonatomic,readonly)NSMutableArray *commonRouteCache;
@property(nonatomic,readonly)NSMutableArray *downLoadCache;

+(SpotRouteManager *)sharedInstance;
- (void)requestGetThemRoute:(id)UIDelegate;
- (void)requestGetThemRoute:(id)UIDelegate withMoreID:(int)moreID;
- (void)requestGetCommonRoute:(id)UIDelegate;
- (void)requestGetCommonRoute:(id)UIDelegate withMoreID:(int)moreID;
- (void)requestGetRoute:(id)UIDelegate withInfoID:(int)infoID;
@end
