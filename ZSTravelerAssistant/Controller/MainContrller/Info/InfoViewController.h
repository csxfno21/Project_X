//
//  InfoViewController.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-7-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "InfoMainTableView.h"
#import "InfoTrafficTableView.h"
#import "InfoLineViewController.h"
#import "HttpManagerCenter.h"
#import "AKSegmentedControl.h"
@interface InfoViewController : BaseViewController<UIScrollViewDelegate,UITabBarDelegate,InfoMainTableViewDlegate,InfoTrafficTableViewDelegate,HttpManagerDelegate,AKSegmentedControlDelegate>
{
    
    InfoMainTableView *tableViewOne;
    InfoMainTableView *tableViewTwo;
    NSMutableArray *tableViewData;

}
//@property (retain, nonatomic) NSDictionary  *textAttibutes;
@property (retain, nonatomic) IBOutlet UILabel *topTitle;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property (retain, nonatomic) IBOutlet UITabBarItem *tabbarItemOne;
@property (retain, nonatomic) IBOutlet UITabBarItem *tabbarItemTwo;
@property (retain, nonatomic) IBOutlet UITabBarItem *tabbarItemThree;
@property (retain, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;
@property (retain,nonatomic)  InfoMainTableView *tableViewOne;
@property (retain,nonatomic)  InfoMainTableView *tableViewTwo;
@property (retain ,nonatomic) InfoTrafficTableView *tableViewThree;

@end
