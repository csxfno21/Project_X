//
//  ZS_Scenic_Buffer_entity.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-27.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_Scenic_Buffer_entity.h"

@implementation ZS_Scenic_Buffer_entity
@synthesize ID,spotID,SpeakContentIn,SpeakContentOut,ScenicName,BufferIn,BufferOut;



- (void)dealloc
{
    ID = 0;
    SAFERELEASE(spotID)
    SAFERELEASE(SpeakContentOut)
    SAFERELEASE(SpeakContentIn)
    SAFERELEASE(ScenicName)
    SAFERELEASE(BufferOut)
    SAFERELEASE(BufferIn)
    [super dealloc];
}
@end
