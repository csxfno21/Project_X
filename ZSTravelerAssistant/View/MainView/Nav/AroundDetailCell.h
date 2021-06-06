//
//  AroundDetailCell.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AroundDetailCell : UIButton
{
    UIImageView *smallImgView;
    UILabel     *smallLabel;
}
@property (nonatomic, retain)    UIImageView *smallImgView;
@property (nonatomic, retain)    UILabel     *smallLabel;

@end
