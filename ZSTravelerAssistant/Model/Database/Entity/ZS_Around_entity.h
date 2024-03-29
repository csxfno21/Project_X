//
//  ZS_Around_entity.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZS_Around_entity : NSObject
{
    NSInteger ID;
    NSString  *Type;
    NSString  *Title;
    NSString  *Lng;
    NSString  *Lat;
    NSString  *Address;
    NSString  *Business;
    NSString  *DetailedBusiness;
    NSString  *ImgUrl;
}
@property (nonatomic) NSInteger ID;
@property (nonatomic,retain) NSString *Type;
@property (nonatomic,retain) NSString *Title;
@property (nonatomic,retain) NSString *Lng;
@property (nonatomic,retain) NSString *Lat;
@property (nonatomic,retain) NSString *Address;
@property (nonatomic,retain) NSString *Business;
@property (nonatomic,retain) NSString *DetailedBusiness;
@property (nonatomic,retain) NSString *ImgUrl;
@end
