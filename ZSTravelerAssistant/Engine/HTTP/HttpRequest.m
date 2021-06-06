//
//  BaseRequest.m
//  Tourism
//
//  Created by csxfno21 on 13-4-3.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest
@synthesize index;
@synthesize requestType;
@synthesize postData;
@synthesize cmdCode;
@synthesize url;
@synthesize delegate;
@synthesize UIDelegate;
- (void)dealloc
{
    SAFERELEASE(url)
    SAFERELEASE(postData)
    delegate = nil;
    UIDelegate = nil;
    [super dealloc];
}
@end
