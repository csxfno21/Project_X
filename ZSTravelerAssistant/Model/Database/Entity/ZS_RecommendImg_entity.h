//
//  ZS_RecommendImg_entity.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZS_RecommendImg_entity : NSObject
{
    int ID;
    NSString  *SpotID;
    NSString  *ImageName;
    NSString  *ImgUrl;
}
@property (nonatomic) int ID;
@property (nonatomic, retain) NSString *SpotID;
@property (nonatomic, retain) NSString *ImageName;
@property (nonatomic, retain) NSString *ImgUrl;
@end
