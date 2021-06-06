//
//  InfoViewController.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-7-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "RouteThirdTableView.h"
#import "RecomdLineTableView.h"
#import "RouteOneView.h"
#import "RouteNavPopView.h"
#import "AKSegmentedControl.h"
#import "SpotManager.h"
@interface RouteViewController : BaseViewController<UIScrollViewDelegate,UITabBarDelegate,RouteThirdTableViewDlegate,RouteOneViewDelegate,RecomdLineTableViewDelegate,RouteNavPopViewDelegate,AKSegmentedControlDelegate>
{
    
    NSMutableArray *addedSpot;
    int count;
    ZS_SpotRoute_entity* routData;
    ZS_CustomizedSpot_entity* spotData;
    
}
//@property (retain, nonatomic) NSMutableArray *addedSpot;
@property (retain, nonatomic) IBOutlet UIButton *routeSpotBtn;
@property (retain, nonatomic) IBOutlet UILabel *routeSpotLabel;
@property (retain, nonatomic) IBOutlet UIImageView *routeSpotImgView;
@property (retain, nonatomic) IBOutlet UILabel *topTitle;
@property (retain, nonatomic) IBOutlet UILabel *chosenLabel;

@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property (retain, nonatomic) IBOutlet UITabBarItem *tabbarItemOne;
@property (retain, nonatomic) IBOutlet UITabBarItem *tabbarItemTwo;
@property (retain, nonatomic) IBOutlet UITabBarItem *tabbarItemThree;
@property (retain, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (retain, nonatomic) IBOutlet UITabBar *tabBar;
@property (retain, nonatomic) RecomdLineTableView *recomdLineTableView;
@property (retain, nonatomic) RouteThirdTableView *tableViewThree;
@end
