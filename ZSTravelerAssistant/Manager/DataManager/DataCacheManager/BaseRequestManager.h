//
//  BaseRequestManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-9.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIUtil.h"
#import "HttpRequest.h"
#import "HttpResponse.h"
#import "HttpManagerCenter.h"
#import "DataAccessManager.h"
#import "ZS_RecommendModel.h"
#import "ZS_InfomationModel.h"
#import "ZS_TrafficModel.h"
#import "ZS_SpotRouteModel.h"
#import "ZS_SpotModel.h"
#import "ZS_CommonNavModel.h"
@interface BaseRequestManager : NSObject<HttpManagerCenterDelegate,ASIRequestInteface>

- (id)getJSONContent:(NSDictionary*)dic;


@property(nonatomic,assign)BOOL waitUpdate;
@end
