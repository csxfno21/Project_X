//
//  BaseResponse.m
//  Tourism
//
//  Created by csxfno21 on 13-4-3.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import "HttpResponse.h"

@implementation HttpResponse
@synthesize index,cmdCode,data,UIDelegate,errorCode;


- (void)dealloc
{
    SAFERELEASE(data)
    UIDelegate = nil;
    [super dealloc];
}
@end
