//
//  ZS_SpotSpeak_Entity.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-24.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_SpotSpeak_Entity.h"

@implementation ZS_SpotSpeak_Entity
@synthesize ID,SpotName,SpeakSpotContent,SpotID,SpotBuffer,SpotParentID;

- (void)dealloc
{
    SAFERELEASE(SpotParentID)
    SAFERELEASE(SpotBuffer)
    SAFERELEASE(SpotName)
    SAFERELEASE(SpotID)
    SAFERELEASE(SpeakSpotContent)
    [super dealloc];
}
@end
