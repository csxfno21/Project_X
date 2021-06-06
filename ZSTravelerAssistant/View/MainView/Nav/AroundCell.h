//
//  CommonCell.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-12.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AroundCell : UIButton
{
    UIImageView *imageView;
    UILabel     *nameLabel;
}
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UILabel     *nameLabel;

@end
