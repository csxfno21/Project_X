//
//  ZS_Infomation_entity.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_Infomation_entity.h"

@implementation ZS_Infomation_entity
@synthesize ID,InfoType,InfoTitle,InfoImgUrl,InfoImgName,InfoContent,SmallImageUrl,SmallImageName;

-(void)dealloc
{
    SAFERELEASE(InfoType)
    SAFERELEASE(InfoTitle)
    SAFERELEASE(InfoImgUrl)
    SAFERELEASE(InfoImgName)
    SAFERELEASE(InfoContent)
    SAFERELEASE(SmallImageUrl)
    SAFERELEASE(SmallImageName)
    [super dealloc];
}

@end
