//
//  ZS_CommonNav_entity.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_CommonNav_entity.h"

@implementation ZS_CommonNav_entity
@synthesize ID,NavType,NavTitle,NavLng,NavLat,NavContent,NavInSpotID,NavIID,NavPosition,NavRemark,POITourCar,POIPark,DisToPosition;
-(void)dealloc
{
    SAFERELEASE(NavIID);
    SAFERELEASE(NavPosition);
    SAFERELEASE(NavRemark);
    SAFERELEASE(NavInSpotID)
    SAFERELEASE(NavType)
    SAFERELEASE(NavTitle)
    SAFERELEASE(NavLng)
    SAFERELEASE(NavLat)
    SAFERELEASE(NavContent)
    SAFERELEASE(POITourCar)
    SAFERELEASE(POIPark)
    [super dealloc];
}

@end
