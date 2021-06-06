//
//  TeamSendMessagePopView.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-22.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TeamSendMessagePopViewDelegate <NSObject>

-(void)sendMessagePopViewAction:(int)index;

@end

@interface TeamSendMessagePopView : UIView
{
    UIControl *overlayView;
    id<TeamSendMessagePopViewDelegate> delegate;
}
@property (assign, nonatomic) id<TeamSendMessagePopViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UIImageView *iImgView;
@property (retain, nonatomic) IBOutlet UILabel *sendToAllLabel;
@property (retain, nonatomic) IBOutlet UITextField *messageTextField;
@property (retain, nonatomic) IBOutlet UIButton *groupMessageSendBtn;
@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;

+(TeamSendMessagePopView*)instanceSendMessagePopView;
-(void)show;
-(void)dismiss;
@end
