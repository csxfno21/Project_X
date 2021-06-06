//
//  ScenicManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-27.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseRequestManager.h"

@interface ScenicManager : BaseRequestManager
@property(nonatomic,readonly)NSMutableArray *downLoadCache;
+ (ScenicManager*)sharedInstance;
- (void)requestGetScenicData:(id)UIDelegate;
@end
