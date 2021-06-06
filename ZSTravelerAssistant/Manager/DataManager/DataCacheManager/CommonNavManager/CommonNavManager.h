//
//  CommonNavManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseRequestManager.h"

@interface CommonNavManager : BaseRequestManager

@property(nonatomic,readonly)NSMutableArray *downLoadCache;
+ (CommonNavManager*)sharedInstance;
- (void)requestGetPoi:(id)UIDelegate withInfoID:(int)infoID;
@end
