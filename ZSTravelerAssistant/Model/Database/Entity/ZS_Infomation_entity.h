//
//  ZS_Infomation_entity.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZS_Infomation_entity : NSObject
{
    NSInteger  ID;
    NSString   *InfoType;
    NSString   *InfoTitle;
    NSString   *InfoImgUrl;
    NSString   *InfoImgName;
    NSString   *InfoContent;
    NSString   *SmallImageUrl;
    NSString   *SmallImageName;

}
@property (nonatomic) NSInteger ID;
@property (nonatomic, retain) NSString *InfoType;
@property (nonatomic, retain) NSString *InfoTitle;
@property (nonatomic, retain) NSString *InfoImgUrl;
@property (nonatomic, retain) NSString *InfoImgName;
@property (nonatomic, retain) NSString *InfoContent;
@property (nonatomic, retain) NSString *SmallImageUrl;
@property (nonatomic, retain) NSString *SmallImageName;
@end
