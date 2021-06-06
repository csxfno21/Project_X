//
//  ZS_Around_entity.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ZS_Around_entity.h"

@implementation ZS_Around_entity
@synthesize ID,Type,Title,Lng,Lat,Address,Business,DetailedBusiness,ImgUrl;
-(void)dealloc
{
    SAFERELEASE(Type)
    SAFERELEASE(Title)
    SAFERELEASE(Lng)
    SAFERELEASE(Lat)
    SAFERELEASE(Address)
    SAFERELEASE(Business)
    SAFERELEASE(DetailedBusiness)
    SAFERELEASE(ImgUrl)
    [super dealloc];
}
@end
