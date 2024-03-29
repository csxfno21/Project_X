//
//  InfoMationManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseRequestManager.h"

@interface InfoMationManager : BaseRequestManager


//数据缓存
@property(nonatomic,readonly)NSMutableArray *seasonInfoCache;
@property(nonatomic,readonly)NSMutableArray *recentlyInfoCache;
@property(nonatomic,readonly)NSMutableArray *downLoadCache;

+(InfoMationManager *)sharedInstance;
- (void)requestGetInfo:(id)UIDelegate withInfoID:(int)infoID;
- (void)requestGetSeasonInfo:(id)UIDelegate;
- (void)requestGetSeasonInfo:(id)UIDelegate withMoreID:(int)moreID;
- (void)requestGetRecentlyInfo :(id)UIDelegate;
- (void)requestGetRecentlyInfo :(id)UIDelegate withMoreID:(int)moreID;
@end
