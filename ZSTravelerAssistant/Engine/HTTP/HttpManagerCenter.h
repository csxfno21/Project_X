//
//  HttpManagerCenter.h
//  Tourism
//
//  Created by csxfno21 on 13-4-3.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "httpBaseResponse.h"
#import "HttpResponse.h"

@protocol HttpManagerDelegate <NSObject>
- (void)callBackToUI:(HttpBaseResponse*)response;
@end

@protocol HttpManagerCenterDelegate <NSObject>
- (void)reciveHttpRespondInfo:(HttpResponse*)response;
@end
