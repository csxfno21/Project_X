//
//  ZS_CommonNav_entity.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZS_CommonNav_entity : NSObject
{
    int ID;
    NSString  *NavType;
    NSString  *NavTitle;
    NSString  *NavLng;
    NSString  *NavLat;
    NSString  *NavContent;
    NSString  *NavInSpotID;
    NSString  *NavIID;
    NSString  *NavPosition;
    NSString  *NavRemark;
    NSString  *POITourCar;
    NSString  *POIPark;
    int DisToPosition;
}
@property(nonatomic) int ID;
@property(nonatomic,retain) NSString *NavType;
@property(nonatomic,retain) NSString *NavTitle;
@property(nonatomic,retain) NSString *NavLng;
@property(nonatomic,retain) NSString *NavLat;
@property(nonatomic,retain) NSString *NavContent;
@property(nonatomic,retain) NSString *NavIID;
@property(nonatomic,retain) NSString *NavInSpotID;
@property(nonatomic,retain) NSString *NavPosition;
@property(nonatomic,retain) NSString *NavRemark;
@property(nonatomic,retain) NSString *POITourCar;
@property(nonatomic,retain) NSString *POIPark;
@property(nonatomic) int DisToPosition;
@end
