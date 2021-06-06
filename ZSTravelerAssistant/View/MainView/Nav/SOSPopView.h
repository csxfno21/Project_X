//
//  SOSPopView.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-8.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SOSPopViewDelegate <NSObject>

-(void)sosPopAction:(int)index;

@end

@interface SOSPopView : UIView
{
    UIControl  *overlayView;
    id<SOSPopViewDelegate> delegate;
}
@property (nonatomic, assign) id<SOSPopViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *mGoodsStolenLabel;
@property (retain, nonatomic) IBOutlet UILabel *mSpotAlarmWarnLabel;
@property (retain, nonatomic) IBOutlet UIButton *mConfirmBtn;
@property (retain, nonatomic) IBOutlet UIButton *mCancelBtn;

+(SOSPopView *)instanceSOSPopView;
- (void)dismiss;
- (void)show;
@end
