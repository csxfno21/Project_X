//
//  CommonViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-14.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonTableViewOne.h"
#import "CommonTableViewTwo.h"
#import "AKSegmentedControl.h"
#import "CommonTableViewDelegate.h"
#import "RouteNavPopView.h"
#import "CommonNavManager.h"

@interface CommonViewController : BaseViewController<UITabBarDelegate,UIScrollViewDelegate,AKSegmentedControlDelegate,CommonTableViewDelegate,CommonTableViewTwoDelegate,RouteNavPopViewDelegate>
{

    NSInteger openIndex;
    ZS_CommonNav_entity* selectEntity;
}
@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) IBOutlet UIImageView *topTitleImgView;
@property (retain, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;
@property (retain, nonatomic) IBOutlet UITabBarItem *tabBarItemOne;
@property (retain, nonatomic) IBOutlet UITabBarItem *tabBarItemTwo;
@property (retain, nonatomic) IBOutlet UITabBarItem *tabBarItemThree;
@property (retain, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (retain, nonatomic) CommonTableViewOne *tableViewOne;
@property (retain, nonatomic) CommonTableViewTwo *tableViewTwo;
@property (retain, nonatomic) CommonTableViewOne *tableViewThree;


@end
