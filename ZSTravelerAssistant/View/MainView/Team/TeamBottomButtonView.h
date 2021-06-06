//
//  TeamBottomButtonView.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-10-27.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamBottomButtonView : UIButton
{
    UIImageView *btnImageView;
    UILabel *btnLabel;
}
@property(nonatomic, retain) UIImageView *btnImageView;
@property(nonatomic, retain) UILabel *btnLabel;
@end
