//
//  InfoViewController.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-7-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "InfoViewController.h"
#import "InfoTrafficTableViewCell.h"
#import "InfoSubVIewDetailController.h"

#define TABLEVIEW_TAG               100
#define CELLHIGHT 100.0

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize tableViewOne;
@synthesize tableViewTwo;
@synthesize tableViewThree;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    InfoMainTableView *tmptableViewOne = [[InfoMainTableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.mScrollView.frame.size.height)];
    if(!iPhone5)
    {
        tmptableViewOne.frame = CGRectMake(0, 0, 320, 372 - 4);
    }
    tmptableViewOne.infodelegate = self;
    tmptableViewOne.tag = TABLEVIEW_TAG;
    tmptableViewOne.type = INFOTYPE_SEASON;
    [tmptableViewOne addPullToRefreshFooter];
    [self.mScrollView addSubview:tmptableViewOne];
    self.tableViewOne = tmptableViewOne;
    SAFERELEASE(tmptableViewOne)
    
    InfoMainTableView *tmptableViewTwo = [[InfoMainTableView alloc] initWithFrame:CGRectMake(320, 0, 320, self.mScrollView.frame.size.height)];
    if(!iPhone5)
    {
        tmptableViewTwo.frame = CGRectMake(320, 0, 320, 372 - 4);
    }
    tmptableViewTwo.infodelegate = self;
    tmptableViewTwo.tag = TABLEVIEW_TAG + 1;
    tmptableViewTwo.type = INFOTYPE_RECENTLY;
    [tmptableViewTwo addPullToRefreshFooter];
    [self.mScrollView addSubview:tmptableViewTwo];
    self.tableViewTwo = tmptableViewTwo;
    SAFERELEASE(tmptableViewTwo)
    
    InfoTrafficTableView  *tmptableViewThree1 = [[InfoTrafficTableView alloc]initWithFrame:CGRectMake(650, 45, 300, self.mScrollView.frame.size.height - 45)];
    if(!iPhone5)
    {
        tmptableViewThree1.frame = CGRectMake(650, 45, 320, 372 - 45);
    }
    tmptableViewThree1.trafficdelegate = self;
    tmptableViewThree1.type = TRAFFICTYPE_BUS;
    tmptableViewThree1.tag = TABLEVIEW_TAG + 2;
    [tmptableViewThree1 addPullToRefreshFooter];
    self.tableViewThree = tmptableViewThree1;
    [self.mScrollView addSubview:tmptableViewThree1];
    [tmptableViewThree1 release];
    
    
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(670.0, 8, 260.0, 32.0)];
    [segmentedControl setDelegate:self];
    [self setupSegmentedControl:segmentedControl];
    [self.mScrollView addSubview:segmentedControl];
    
    SAFERELEASE(segmentedControl)
    
    [self.tabbarItemOne setTitle:[Language stringWithName:INFO_TABBAR_ITEM_ONE]];
    [self.tabbarItemTwo setTitle:[Language stringWithName:INFO_TABBAR_ITEM_TWO]];
    [self.tabbarItemThree setTitle:[Language stringWithName:INFO_TABBAR_ITEM_THREE]];
    self.tabBar.delegate = self;
    self.tabBar.selectedItem = self.tabbarItemOne;
    self.mScrollView.contentSize = CGSizeMake(320 * 3, 0);
    self.mScrollView.delegate = self;
    
    [self.topTitle setText:[Language stringWithName:ROOT_PAGE_ONE_TITLE]];
    [self.backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"back-on.png"] forState:UIControlStateHighlighted];
    [self.backLabel setText:[Language stringWithName:BACK]];
    
    
    
    [[InfoMationManager sharedInstance] requestGetSeasonInfo:self];
    [[InfoMationManager sharedInstance] requestGetRecentlyInfo:self];
    [[TrafficManager sharedInstance] requestGetBusInfo:self];
}

- (void)setupSegmentedControl:(AKSegmentedControl*)control
{
    UIImage *backgroundImage = [[UIImage imageNamed:@"segmented-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [control setBackgroundImage:backgroundImage];
    [control setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    [control setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    
    [control setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
    
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"segmented-bg-pressed-left.png"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
//    UIImage *buttonBackgroundImagePressedCenter = [[UIImage imageNamed:@"segmented-bg-pressed-center.png"]
//                                                   resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"segmented-bg-pressed-right.png"]
                                                  resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
    
    // Button 1
    UIButton *buttonSocial = [[[UIButton alloc] init] autorelease];
    [buttonSocial setTitle:[Language stringWithName:PUBLIC_TRANSIT] forState:UIControlStateNormal];
    [buttonSocial setTitleColor:[UIColor colorWithRed:82.0/255.0 green:113.0/255.0 blue:131.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [buttonSocial setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonSocial.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonSocial.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonSocial setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
//    UIImage *buttonSocialImageNormal = [UIImage imageNamed:@"social-icon.png"];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
//    [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateNormal];
//    [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateSelected];
//    [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateHighlighted];
//    [buttonSocial setImage:buttonSocialImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
    UIButton *buttonStar = [[[UIButton alloc] init] autorelease];
    
    [buttonStar setTitle:[Language stringWithName:TOUR_BUSES] forState:UIControlStateNormal];
    [buttonStar setTitleColor:[UIColor colorWithRed:82.0/255.0 green:113.0/255.0 blue:131.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [buttonStar setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonStar.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonStar.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonStar setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [buttonStar setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [buttonStar setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [buttonStar setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
//    [buttonStar setImage:buttonStarImageNormal forState:UIControlStateNormal];
//    [buttonStar setImage:buttonStarImageNormal forState:UIControlStateSelected];
//    [buttonStar setImage:buttonStarImageNormal forState:UIControlStateHighlighted];
//    [buttonStar setImage:buttonStarImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [control setButtonsArray:@[buttonSocial, buttonStar]];
}
#pragma mark- updateLanguage
- (void)updateLanguage:(id)sender
{

}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- segmengChange
- (void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
//    [self.tableViewThree scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    [self.tableViewThree stopLoading];
    switch (index)
    {
        case 0:
        {
            [[TrafficManager sharedInstance] cancelRequestWithCode:CC_GET_TOURISCAR_INFO];
            [[TrafficManager sharedInstance] cancelRequestWithCode:CC_GET_TOURISCAR_INFO_MORE];
            self.tableViewThree.type = TRAFFICTYPE_BUS;
            [[TrafficManager sharedInstance] requestGetBusInfo:self];
            break;
        }
        case 1:
        {
            [[TrafficManager sharedInstance] cancelRequestWithCode:CC_GET_BUSS_INFO];
            [[TrafficManager sharedInstance] cancelRequestWithCode:CC_GET_BUSS_INFO_MORE];
            self.tableViewThree.type = TRAFFICTYPE_SIGHTSEEING;
            [[TrafficManager sharedInstance] requestGetTourisCarInfo:self];
            break;
        }
        default:
            break;
    }
    [self.tableViewThree reloadData];

}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offsetx = scrollView.contentOffset.x;
    int page = offsetx / 320;
    if(page == 0)self.tabBar.selectedItem = self.tabbarItemOne;
    else if(page == 1)self.tabBar.selectedItem = self.tabbarItemTwo;
    else if(page == 2)self.tabBar.selectedItem = self.tabbarItemThree;
}

#pragma mark UITabbar Delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index =  item.tag;
    CGPoint newOffset = CGPointMake(index * 320, 0);
    [self.mScrollView setContentOffset:newOffset animated:YES];
}

#pragma mark - InfoMainTableView Delegate
- (void)itemDidSelected:(int)index withType:(InfoType)type
{
    [[InfoMationManager sharedInstance] cancelRequest:self];
    [self.tableViewOne stopLoading];
    [self.tableViewTwo stopLoading];
    switch (type) {
        case INFOTYPE_SEASON:
        {
            InfoSubVIewDetailController *tmpDetailView = [[InfoSubVIewDetailController alloc] init];
            tmpDetailView.entity = [[InfoMationManager sharedInstance].seasonInfoCache objectAtIndex:index];
            [self.navigationController pushViewController:tmpDetailView animated:YES];
            SAFERELEASE(tmpDetailView);
        }
        break;
        case INFOTYPE_RECENTLY:
        {
            InfoSubVIewDetailController *tmpDetailView = [[InfoSubVIewDetailController alloc] init];
            tmpDetailView.entity = [[InfoMationManager sharedInstance].recentlyInfoCache objectAtIndex:index];
            [self.navigationController pushViewController:tmpDetailView animated:YES];
            SAFERELEASE(tmpDetailView);
        }
            break;
            
        default:
            break;
    }


}
#pragma mark - InfoTrafficTableView Delegate
-(void)cellDidSelected:(int) index withType:(TRAFFICTYPE)type
{
    switch (type) {
        case TRAFFICTYPE_BUS:
        {
            InfoLineViewController *controller = [[InfoLineViewController alloc]init];
            ZS_Traffic_entity *entity = [[TrafficManager sharedInstance].busInfoCache objectAtIndex:index];
            if(entity)
            controller.entity = entity;
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller)
            break;
        }
        case TRAFFICTYPE_SIGHTSEEING:
        {
            InfoLineViewController *controller = [[InfoLineViewController alloc]init];
            ZS_Traffic_entity *entity = [[TrafficManager sharedInstance].tourisCarInfoCache objectAtIndex:index];
            if(entity)
            controller.entity = entity;
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller)
            break;
        }
        default:
            break;
    }
}


#pragma mark - callBack
- (void)callBackToUI:(HttpBaseResponse *)response
{
    switch (response.cc_cmd_code)
    {
        case CC_GET_SEASON_INFO:
        {
            self.tableViewOne.data = [InfoMationManager sharedInstance].seasonInfoCache;
            break;
        }
        case CC_GET_REC_INFO:
        {
            self.tableViewTwo.data = [InfoMationManager sharedInstance].recentlyInfoCache;
            break;
        }
        case CC_GET_BUSS_INFO:
        {
            if(self.tableViewThree.type == TRAFFICTYPE_BUS)
            self.tableViewThree.trafficData = [TrafficManager sharedInstance].busInfoCache;
            break;
        }
        case CC_GET_TOURISCAR_INFO:
        {
            if(self.tableViewThree.type == TRAFFICTYPE_SIGHTSEEING)
            self.tableViewThree.trafficData = [TrafficManager sharedInstance].tourisCarInfoCache;
            break;
        }
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_topTitle release];
    [_backBtn release];
    [_backLabel release];
    [_tabbarItemOne release];
    [_tabbarItemTwo release];
    [_tabbarItemThree release];
    [_mScrollView release];
    [_tabBar release];
    SAFERELEASE(tableViewOne)
    SAFERELEASE(tableViewTwo)
    [tableViewThree release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setTopTitle:nil];
    [self setBackBtn:nil];
    [self setBackLabel:nil];
    [self setTabbarItemOne:nil];
    [self setTabbarItemTwo:nil];
    [self setTabbarItemThree:nil];
    [self setMScrollView:nil];
    [self setTabBar:nil];
    [super viewDidUnload];
}
@end
