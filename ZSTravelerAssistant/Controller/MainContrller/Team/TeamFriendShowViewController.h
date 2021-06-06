//
//  TeamFriendShowViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-21.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "TeamFriendTableView.h"
#import "TeamSendMessagePopView.h"
#import "TeamBottomButtonView.h"
#import "TeamSaveInfoViewController.h"
#import "TeamManagerDelegate.h"
#import "MyNavController.h"

@interface TeamFriendShowViewController : BaseViewController<UIScrollViewDelegate,UITabBarDelegate,TeamSendMessagePopViewDelegate,TeamFriendTableViewDelegate,TeamManagerDelegate>
{
    
}
- (IBAction)onEditInfo:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *topBackgroundImgView;
@property (retain, nonatomic) IBOutlet UIImageView *myselfImgView;
@property (retain, nonatomic) IBOutlet UILabel *selfNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *myselfOnlineLabel;
@property (retain, nonatomic) IBOutlet UILabel *myselfSexLabel;
@property (retain, nonatomic) IBOutlet UILabel *myselfLocalLabel;
@property (retain, nonatomic) TeamFriendTableView *tableViewOne;
@property (retain, nonatomic) TeamBottomButtonView *teamBottomViewOne;
@property (retain, nonatomic) TeamBottomButtonView *teamBottomViewTwo;
@property (retain, nonatomic) TeamBottomButtonView *teamBottomViewThree;
@property (retain, nonatomic) TeamBottomButtonView *teamBottomViewFour;
@end
