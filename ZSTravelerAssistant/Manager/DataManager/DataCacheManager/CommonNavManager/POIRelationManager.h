//
//  POIRelationManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-24.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseRequestManager.h"

@interface POIRelationManager : BaseRequestManager
@property(nonatomic,readonly)NSMutableArray *downLoadCache;
+ (POIRelationManager*)sharedInstance;
- (void)requestGetPoiRelation:(id)UIDelegate withInfoID:(int)infoID;
@end
