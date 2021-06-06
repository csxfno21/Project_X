//
//  SpotSpeakContentManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-24.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseRequestManager.h"

@interface SpotSpeakContentManager : BaseRequestManager
@property(nonatomic,readonly)NSMutableArray *downLoadCache;
+ (SpotSpeakContentManager*)sharedInstance;
- (void)requestGetSpeakData:(id)UIDelegate withInfoID:(int)infoID;
@end
