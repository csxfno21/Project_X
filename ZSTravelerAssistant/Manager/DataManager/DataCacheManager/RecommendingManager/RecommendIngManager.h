//
//  RecommendIngManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseRequestManager.h"

@interface RecommendIngManager : BaseRequestManager
+(RecommendIngManager *)sharedInstance;


@property(nonatomic,readonly)NSMutableArray *spotsCache;

- (void)requestGetMianScrolSpots:(id)UIDelegate;
@end
