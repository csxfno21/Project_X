//
//  ZS_SpotRoute_entity.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZS_SpotRoute_entity : NSObject
{
    NSInteger ID;
    NSString  *RouteType;
    NSString  *RouteTitle;
    NSString  *RouteLength;
    NSString  *RouteTime;
    NSString  *RouteSmallImgUrl;
    NSString  *RouteSmallImgName;
    NSString  *RouteList;
    NSString  *RouteTicket;
    NSString  *RouteContent;
    NSString  *RouteImageUrl;
    NSString  *RouteImageName;
}
@property (nonatomic) NSInteger ID;
@property (nonatomic, retain) NSString *RouteType;
@property (nonatomic, retain) NSString *RouteTitle;
@property (nonatomic, retain) NSString *RouteLength;
@property (nonatomic, retain) NSString *RouteTime;
@property (nonatomic, retain) NSString *RouteSmallImgUrl;
@property (nonatomic, retain) NSString *RouteSmallImgName;
@property (nonatomic, retain) NSString *RouteList;
@property (nonatomic, retain) NSString *RouteTicket;
@property (nonatomic, retain) NSString *RouteContent;
@property (nonatomic, retain) NSString *RouteImageUrl;
@property (nonatomic, retain) NSString *RouteImageName;

@end
