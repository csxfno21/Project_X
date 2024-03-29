//
//  TabbarItemView.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-9-24.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabbarItemView : UIButton
{
    UIImageView *imgView;
    UIBarButtonItem *barItem;
    UILabel     *titleLabel;
}
@property(nonatomic, retain)    UIImageView *imgView;
@property(nonatomic, retain)    UIBarButtonItem *barItem;
@property(nonatomic, retain)    UILabel     *titleLabel;
@end
