//
//  ZS_Spot_entity.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_CustomizedSpot_entity.h"

@implementation ZS_CustomizedSpot_entity
@synthesize ID,SpotID,SpotName,SpotContent,SpotLength,SpotStar,SpotLat,SpotLng,SpotTickets,SpotImgUrl,SpotSmallUrl,SpotImgName,SpotSmallImgName,SpotType,SpotBuff,SpotParentID,SpotRemark,DisToPosition;

-(void)dealloc
{
    SAFERELEASE(SpotRemark)
    SAFERELEASE(SpotID)
    SAFERELEASE(SpotName)
    SAFERELEASE(SpotContent)
    SAFERELEASE(SpotStar)
    SAFERELEASE(SpotLength)
    SAFERELEASE(SpotStar)
    SAFERELEASE(SpotTickets)
    SAFERELEASE(SpotLng)
    SAFERELEASE(SpotLat)
    SAFERELEASE(SpotImgUrl)
    SAFERELEASE(SpotSmallUrl)
    SAFERELEASE(SpotImgName)
    SAFERELEASE(SpotSmallImgName)
    SAFERELEASE(SpotType)
    SAFERELEASE(SpotBuff)
    SAFERELEASE(SpotParentID)
    [super dealloc];
}

@end
