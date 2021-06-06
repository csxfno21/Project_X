//
//  ApplicationVersionManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-2.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseRequestManager.h"
#import "CheckVersionResponse.h"
@interface ApplicationVersionManager : BaseRequestManager

@property(readonly,nonatomic,retain)NSString *version;
+ (ApplicationVersionManager*)sharedInstance;
- (void)requestCheckVersion:(id)UIDelegate;
@end
