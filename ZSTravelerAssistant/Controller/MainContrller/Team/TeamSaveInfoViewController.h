//
//  TeamSaveInfoViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-21.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "Config.h"
#import "TeamManager.h"

@interface TeamSaveInfoViewController : BaseViewController<UIGestureRecognizerDelegate,UITextFieldDelegate,UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *topTitleImgView;
@property (retain, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property (retain, nonatomic) IBOutlet UIButton *saveMyInfoBtn;
- (IBAction)onChangeSexBoy:(id)sender;
- (IBAction)onChangeSexGirl:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *imgCheckSexBoy;
@property (retain, nonatomic) IBOutlet UIImageView *imgCheckSexGirl;
@property (retain, nonatomic) IBOutlet UITextField *lbName;
@property (retain, nonatomic) IBOutlet UITextField *lbWhere;
@property (retain, nonatomic) IBOutlet UIScrollView *mScrollView;
- (IBAction)onSaveInfo:(id)sender;

@end
