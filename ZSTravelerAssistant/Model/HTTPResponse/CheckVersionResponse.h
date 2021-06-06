//
//  CheckVersionResponse.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-9-2.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "httpBaseResponse.h"
#import "APPlicationVersionEnum.h"
@interface CheckVersionResponse : HttpBaseResponse
{
    APPLICATION_VERSION version;
    NSString *appLink;
    NSString *currentVersion;
}
@property(assign,nonatomic)APPLICATION_VERSION version;
@property(retain,nonatomic)NSString* appLink;
@property(retain,nonatomic)NSString* currentVersion;
@end
