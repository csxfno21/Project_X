//
//  InfoViewController.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-7-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "RouteViewController.h"
#import "SpotDetailViewController.h"
#import "RouteDetailViewController.h"
#import "MyNavController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Genie.h"
#import "ChooseSpotListControllerViewController.h"
#define TABLEVIEW_TAG               100
@interface RouteViewController ()

@end

@implementation RouteViewController
@synthesize recomdLineTableView,tableViewThree;
//@synthesize addedSpot;
//@synthesize recomdLineTableView;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSpot:) name:NOTIFICATION_REMOVE_SPOT object:nil];
    
    addedSpot = [[NSMutableArray alloc] init];
    
    RouteOneView *tableViewOne = nil;
    if (!iPhone5)
    {
        tableViewOne = [[RouteOneView alloc]initWithFrame:CGRectMake(0, 0, 320, 372)];
    }
    else
    {
        tableViewOne = [[RouteOneView alloc]initWithFrame:CGRectMake(0, 0, 320, self.mScrollView.frame.size.height)];
    }
    tableViewOne.tag = TABLEVIEW_TAG;
    tableViewOne.delegate = self;
    [self.mScrollView addSubview:tableViewOne];
    SAFERELEASE(tableViewOne)
    
    RecomdLineTableView *tableViewTwo = [[RecomdLineTableView alloc]initWithFrame:CGRectMake(320, 45, 320, self.mScrollView.frame.size.height - 45)];
    if (!iPhone5)
    {
        tableViewTwo.frame = CGRectMake(320, 50, 320, 372 - 55);
    }
    [tableViewTwo addPullToRefreshFooter];
    tableViewTwo.recomdelegate = self;
    tableViewTwo.type = LINETYPE_THEME;
    tableViewTwo.tag = TABLEVIEW_TAG + 1;
    self.recomdLineTableView = tableViewTwo;
    [self.mScrollView addSubview:tableViewTwo];
    SAFERELEASE(tableViewTwo)
    
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(350.0, 8, 260.0, 32.0)];
    [segmentedControl setDelegate:self];
    [self setupSegmentedControl:segmentedControl];
    [self.mScrollView addSubview:segmentedControl];
    
    SAFERELEASE(segmentedControl)
    
    
    RouteThirdTableView *tmptableViewThree = [[RouteThirdTableView alloc] initWithFrame:CGRectMake(640, 0, 320, self.mScrollView.frame.size.height)];
    if(!iPhone5)
    {
        tmptableViewThree.frame = CGRectMake(640, 0, 320, 372 - 10);
    }
    tmptableViewThree.type = SPOT_VIEW_CHOOSE;
    tmptableViewThree.RouteDelegate = self;
    tmptableViewThree.tag = TABLEVIEW_TAG+2;
//    [tmptableViewThree addPullToRefreshFooter];
    self.tableViewThree = tmptableViewThree;
//    self.routeSpotLabel.text = [NSString stringWithFormat:@"%d",count-self.tableViewThree.notificationCount];
    [self.mScrollView addSubview:tmptableViewThree];
    SAFERELEASE(tmptableViewThree)
    
    [self.tabbarItemOne setTitle:[Language stringWithName:ROUTE_TABBAR_ITEM_ONE]];
    [self.tabbarItemTwo setTitle:[Language stringWithName:ROUTE_TABBAR_ITEM_TWO]];
    [self.tabbarItemThree setTitle:[Language stringWithName:ROUTE_TABBAR_ITEM_THREE]];
    self.tabBar.delegate = self;
    self.tabBar.selectedItem = self.tabbarItemOne;
    self.mScrollView.contentSize = CGSizeMake(320 * 3, 0);
    self.mScrollView.delegate = self;
    
    [self.topTitle setText:[Language stringWithName:ROOT_PAGE_TWO_TITLE]];
    [self.backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"back-on.png"] forState:UIControlStateHighlighted];
    [self.backLabel setText:[Language stringWithName:BACK]];
    [self.chosenLabel setText:[Language stringWithName:ALREADY_CHOSEN]];
    
    
    
    [[SpotRouteManager sharedInstance] requestGetThemRoute:self];
    [[SpotManager sharedInstance] requestGetViewSpot:self];
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
    [buttonSocial setTitle:[Language stringWithName:THEME_LINE] forState:UIControlStateNormal];
    [buttonSocial setTitleColor:[UIColor colorWithRed:82.0/255.0 green:113.0/255.0 blue:131.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [buttonSocial setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonSocial.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonSocial.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonSocial setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Button 2
    UIButton *buttonStar = [[[UIButton alloc] init] autorelease];
    
    [buttonStar setTitle:[Language stringWithName:ROUTINE_LINE] forState:UIControlStateNormal];
    [buttonStar setTitleColor:[UIColor colorWithRed:82.0/255.0 green:113.0/255.0 blue:131.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [buttonStar setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buttonStar.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [buttonStar.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
    [buttonStar setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    
    [buttonStar setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
    [buttonStar setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
    [buttonStar setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    
    [control setButtonsArray:@[buttonSocial, buttonStar]];
}

- (void)removeSpot:(NSNotification*)notification
{
    count = addedSpot.count - 1;
    self.routeSpotLabel.text = [NSString stringWithFormat:@"%d",count];;
}

#pragma mark- updateLanguage
- (void)updateLanguage:(id)sender
{
    
}
- (IBAction)showRouteAction:(id)sender
{
    if (addedSpot.count == 0 )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language stringWithName:SELF_CHOOSE_SPOT]
                                                        message:[Language stringWithName:NO_CHOOSED_SPOTS] delegate:nil cancelButtonTitle:[Language stringWithName:CONFIRM] otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    ChooseSpotListControllerViewController *controller = [[ChooseSpotListControllerViewController alloc] initWithNibName:@"ChooseSpotListControllerViewController" bundle:nil];
    controller.data = addedSpot;
    
    [self.navigationController pushViewController:controller animated:YES];
    SAFERELEASE(controller)
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)segmentedViewController:(AKSegmentedControl *)segmentedControl touchedAtIndex:(NSUInteger)index
{
    [self.recomdLineTableView stopLoading];
    switch (index)
    {
        case 0:
        {
            [[SpotRouteManager sharedInstance] cancelRequestWithCode:CC_GET_COMMON_ROUTE];
            [[SpotRouteManager sharedInstance] cancelRequestWithCode:CC_GET_COMMON_ROUTE_MORE];
            self.recomdLineTableView.type = LINETYPE_THEME;
            [[SpotRouteManager sharedInstance] requestGetThemRoute:self];
            break;
        }
        case 1:
        {
            [[SpotRouteManager sharedInstance] cancelRequestWithCode:CC_GET_THEM_ROUTE];
            [[SpotRouteManager sharedInstance] cancelRequestWithCode:CC_GET_THEM_ROUTE_MORE];
            self.recomdLineTableView.type = LINETYPE_ROUTINE;
            [[SpotRouteManager sharedInstance] requestGetCommonRoute:self];
            break;
        }
        default:
        break;
    }
    [self.recomdLineTableView reloadData];
    [self.recomdLineTableView setLoadingViewFram];
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offsetx = scrollView.contentOffset.x;
    int page = offsetx / 320;
    if(page == 0)
    {
        self.tabBar.selectedItem = self.tabbarItemOne;
        self.routeSpotBtn.hidden = YES;
        self.routeSpotImgView.hidden = YES;
        self.routeSpotLabel.hidden = YES;
        self.chosenLabel.hidden = YES;
    }
    else if(page == 1)
    {
        self.tabBar.selectedItem = self.tabbarItemTwo;
        self.routeSpotBtn.hidden = YES;
        self.routeSpotImgView.hidden = YES;
        self.routeSpotLabel.hidden = YES;
        self.chosenLabel.hidden = YES;
    }
    else if(page == 2)
    {
        self.tabBar.selectedItem = self.tabbarItemThree;
        self.routeSpotBtn.hidden = NO;
        self.routeSpotImgView.hidden = NO;
        self.routeSpotLabel.hidden = NO;
        self.chosenLabel.hidden = NO;
        self.routeSpotLabel.backgroundColor = [UIColor clearColor];
        self.routeSpotLabel.textColor = [UIColor blackColor];
        self.chosenLabel.backgroundColor = [UIColor clearColor];
    }
}

#pragma mark UITabbar Delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSInteger index =  item.tag;
    CGPoint newOffset = CGPointMake(index * 320, 0);
    [self.mScrollView setContentOffset:newOffset animated:YES];
    if(index == 2)
    {
        self.routeSpotBtn.hidden = NO;
        self.routeSpotImgView.hidden = NO;
        self.routeSpotLabel.hidden = NO;
        self.chosenLabel.hidden = NO;
    }
    else
    {
        self.routeSpotBtn.hidden = YES;
        self.routeSpotImgView.hidden = YES;
        self.routeSpotLabel.hidden = YES;
        self.chosenLabel.hidden = YES;
    }
}

#pragma mark - routeOneViewAction
- (void)routeOneViewAction
{
    MyNavController *controller = [[MyNavController alloc] initWithNibName:@"MyNavController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    SAFERELEASE(controller)

}

#pragma mark - RouteThirdTableView Delegate
- (void)routeThirdItemDidSelected:(int)index withType:(ROUTE_MENU_TYPE)type
{
    if(index >= [SpotManager sharedInstance].viewSpotCache.count)return;
    switch (type)
    {
        case ROUTE_MENU_TYPE_DETAIL:
        {
            SpotDetailViewController *controller = [[SpotDetailViewController alloc] init];
            controller.spotEntity = [[SpotManager sharedInstance].viewSpotCache objectAtIndex:index];
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller);
            break;
        }
        case ROUTE_MENU_TYPE_LOCATION:
        {
            ZS_CustomizedSpot_entity *entity = [[SpotManager sharedInstance].viewSpotCache objectAtIndex:index];
            MyNavController *controller = [[MyNavController alloc] initWithNibName:@"MyNavController" bundle:nil];

            [self.navigationController pushViewController:controller animated:YES];
            AGSPoint *point = [AGSPoint pointWithX:[entity.SpotLng doubleValue] y:[entity.SpotLat doubleValue] spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
            [[MapManager sharedInstanced] didShowCallout2Spot:entity.SpotName withPoint:point];
            SAFERELEASE(controller)
            break;
        }
        case ROUTE_MENU_TYPE_NAVIGATION:
        {
            spotData = [[SpotManager sharedInstance].viewSpotCache objectAtIndex:index];
            CGFloat xWidth = self.view.bounds.size.width - 30.0f;
            CGFloat yHeight = 300.0f;
            CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
            RouteNavPopView *popView = [RouteNavPopView instanceRouteNavPopView];
            popView.frame = CGRectMake(15, yOffset, xWidth, yHeight);
            [popView setTitleText:spotData.SpotName];
            popView.delegate = self;
            [popView show];

            break;
        }
        default:
            break;
    }
}

-(void)routeThirdItemAddSpot:(ZS_CustomizedSpot_entity *)entity withIndex:(int)index
{
    [addedSpot addObject:entity];
    UITableViewCell *cell = [self.tableViewThree cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [self addAnim:cell withIndex:index];
    self.routeSpotLabel.text = [NSString stringWithFormat:@"%d",addedSpot.count];
}

- (void)routeThirdItemDeleteSpot:(ZS_CustomizedSpot_entity *)entity withIndex:(int)index
{
    [addedSpot removeObject:entity];
    UITableViewCell *cell = [self.tableViewThree cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [self deleteAnim:cell withIndex:index];
    self.routeSpotLabel.text = [NSString stringWithFormat:@"%d",addedSpot.count];
}
//判断点开后tableview是否向上移动
//-(void)upScroll:(UIView*)cell withIndex:(int)index
//{
//    
//}

- (void)addAnim:(UIView*)cell withIndex:(int)index
{
    CGRect cellRect = [self.tableViewThree rectForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    float offsetY = self.tableViewThree.contentOffset.y;
    float animY = cellRect.origin.y - offsetY + 44;
    if (cellRect.origin.y - self.tableViewThree.contentOffset.y + cell.frame.size.height > self.tableViewThree.frame.size.height)
    {
        float needScrolOffsetY = cellRect.size.height -  self.tableViewThree.frame.size.height + (cellRect.origin.y - self.tableViewThree.contentOffset.y);
        animY -= needScrolOffsetY;
    }
    cellRect = CGRectMake(cellRect.origin.x, animY, cellRect.size.width, cellRect.size.height);
    
    UIImageView *animView = [[UIImageView alloc] initWithFrame:cellRect];
    animView.backgroundColor = [UIColor redColor];
    
    UIGraphicsBeginImageContext(cellRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [cell.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [animView setImage:img];
    [self.view addSubview:animView];
    CGRect endRect = CGRectMake(290, 22, 2, 2);
    
    [animView genieInTransitionWithDuration:pow(animY*.5/44.0,1.0/3.0)  destinationRect:endRect destinationEdge:BCRectEdgeBottom completion:^
     {
         [animView removeFromSuperview];
         [animView release];
         
     }];
    
}

- (void)deleteAnim:(UIView*)cell withIndex:(int)index
{
    CGRect cellRect = [self.tableViewThree rectForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    float offsetY = self.tableViewThree.contentOffset.y;
    float animY = cellRect.origin.y - offsetY + 44;
    
    if (cellRect.origin.y - self.tableViewThree.contentOffset.y + cellRect.size.height > self.tableViewThree.frame.size.height)
    {
        float needScrolOffsetY = cellRect.size.height -  self.tableViewThree.frame.size.height + (cellRect.origin.y - self.tableViewThree.contentOffset.y);
        animY -= needScrolOffsetY;
        cellRect = CGRectMake(cellRect.origin.x, animY, cellRect.size.width, cellRect.size.height);
    }
    cellRect = CGRectMake(cellRect.origin.x, animY, cellRect.size.width, cellRect.size.height);
    UIImageView *animView = [[UIImageView alloc] initWithFrame:cellRect];
    animView.backgroundColor = [UIColor redColor];
    
    UIGraphicsBeginImageContext(cellRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [cell.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [animView setImage:img];
    [self.view addSubview:animView];

    [animView genieOutTransitionWithDuration:pow(animY*.5/44.0,1.0/3.0) startRect:CGRectMake(290, 22, 2, 2) startEdge:BCRectEdgeBottom completion:^{
         [animView removeFromSuperview];
         [animView release];
    }];
    
}

#pragma mark- RecomdLineTableView Delegate
- (void)recomdLineItemDidSelectedMenuType:(int)index withLineType:(LINETYPE)lineType withType:(ROUTE_MENU_TYPE)type
{
    switch (lineType)
    {
        case LINETYPE_THEME:
        {
            if(type == ROUTE_MENU_TYPE_DETAIL)
            {
                if(index >= [SpotRouteManager sharedInstance].themRouteCache.count)return;
                RouteDetailViewController *detail = [[RouteDetailViewController alloc] initWithNibName:@"RouteDetailViewController" bundle:nil];
                ZS_SpotRoute_entity *entity = [[SpotRouteManager sharedInstance].themRouteCache objectAtIndex:index];
                detail.mTitle.text = entity.RouteTitle;
                NSArray *spotIDs = [entity.RouteList componentsSeparatedByString:@","];
                detail.data = [[DataAccessManager sharedDataModel] getSpotsDetailByIDs:spotIDs];
                [self.navigationController pushViewController:detail animated:YES];
                SAFERELEASE(detail)
            }
            else if(type == ROUTE_MENU_TYPE_LOCATION)
            {
                if(index >= [SpotRouteManager sharedInstance].themRouteCache.count)return;
                ZS_SpotRoute_entity *entity = [[SpotRouteManager sharedInstance].themRouteCache objectAtIndex:index];
                NSArray *spotIDs = [entity.RouteList componentsSeparatedByString:@","];
                NSArray *spots = [[DataAccessManager sharedDataModel] getSpotsDetailByIDs:spotIDs];
                NSMutableArray *poiArray = [[NSMutableArray alloc] init];
                for (ZS_CustomizedSpot_entity *entity in spots)
                {
                    [poiArray addObject:[PoiPoint pointWithName:entity.SpotName withLongitude:[entity.SpotLng doubleValue] withLatitude:[entity.SpotLat doubleValue]]];
                }
                 MyNavController *controller = [[MyNavController alloc] initWithNibName:@"MyNavController" bundle:nil];
                [self.navigationController pushViewController:controller animated:YES];
                SAFERELEASE(controller)
                [[MapManager sharedInstanced] didShowNavLine:poiArray withType:NAV_TYPE_WALK];
//                [[MapManager sharedInstanced] didShowNavLine:poiArray withType:NAV_TYPE_TOUR_CAR];
                SAFERELEASE(poiArray)
               
            }
            else if (type == ROUTE_MENU_TYPE_NAVIGATION)
            {
                if(index >= [SpotRouteManager sharedInstance].themRouteCache.count)return;
                routData = [[SpotRouteManager sharedInstance].themRouteCache objectAtIndex:index];
                CGFloat xWidth = self.view.bounds.size.width - 30.0f;
                CGFloat yHeight = 300.0f;
                CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
                RouteNavPopView *popView = [RouteNavPopView instanceRouteNavPopView];
                popView.frame = CGRectMake(15, yOffset, xWidth, yHeight);
                [popView setTitleText:routData.RouteTitle];
                popView.delegate = self;
                [popView show];
            }
            break;
        }
        case LINETYPE_ROUTINE:
        {
            if(type == ROUTE_MENU_TYPE_DETAIL)
            {
                if(index >= [SpotRouteManager sharedInstance].commonRouteCache.count)return;
                RouteDetailViewController *detail = [[RouteDetailViewController alloc] initWithNibName:@"RouteDetailViewController" bundle:nil];
                ZS_SpotRoute_entity *entity = [[SpotRouteManager sharedInstance].commonRouteCache objectAtIndex:index];
                detail.mTitle.text = entity.RouteTitle;
                NSArray *spotIDs = [entity.RouteList componentsSeparatedByString:@","];
                detail.data = [[DataAccessManager sharedDataModel] getSpotsDetailByIDs:spotIDs];
                [self.navigationController pushViewController:detail animated:YES];
                SAFERELEASE(detail)
            }
            else if(type == ROUTE_MENU_TYPE_LOCATION)
            {
                if(index >= [SpotRouteManager sharedInstance].commonRouteCache.count)return;
                ZS_SpotRoute_entity *entity = [[SpotRouteManager sharedInstance].commonRouteCache objectAtIndex:index];
                NSArray *spotIDs = [entity.RouteList componentsSeparatedByString:@","];
                NSArray *spots = [[DataAccessManager sharedDataModel] getSpotsDetailByIDs:spotIDs];
                NSMutableArray *poiArray = [[NSMutableArray alloc] init];
                for (ZS_CustomizedSpot_entity *entity in spots)
                {
                    [poiArray addObject:[PoiPoint pointWithName:entity.SpotName withLongitude:[entity.SpotLng doubleValue] withLatitude:[entity.SpotLat doubleValue]]];
                }
                
                MyNavController *controller = [[MyNavController alloc] initWithNibName:@"MyNavController" bundle:nil];
                [self.navigationController pushViewController:controller animated:YES];
                SAFERELEASE(controller)
                
                [[MapManager sharedInstanced] didShowNavLine:poiArray withType:NAV_TYPE_WALK];
//                [[MapManager sharedInstanced] didShowNavLine:poiArray withType:NAV_TYPE_TOUR_CAR];
                SAFERELEASE(poiArray)
            }
            else if (type == ROUTE_MENU_TYPE_NAVIGATION)
            {
                if(index >= [SpotRouteManager sharedInstance].commonRouteCache.count)return;
                routData = [[SpotRouteManager sharedInstance].commonRouteCache objectAtIndex:index];
                CGFloat xWidth = self.view.bounds.size.width - 30.0f;
                CGFloat yHeight = 300.0f;
                CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
                RouteNavPopView *popView = [RouteNavPopView instanceRouteNavPopView];
                popView.frame = CGRectMake(15, yOffset, xWidth, yHeight);
                [popView setTitleText:routData.RouteTitle];
                popView.delegate = self;
                [popView show];
            }
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
        case CC_GET_THEM_ROUTE:
        {
            self.recomdLineTableView.data = [SpotRouteManager sharedInstance].themRouteCache;
            break;
        }
        case CC_GET_COMMON_ROUTE:
        {
            self.recomdLineTableView.data = [SpotRouteManager sharedInstance].commonRouteCache;
            break;
        }
        case CC_GET_VIEW_SPOT:
        {
            self.tableViewThree.data = [SpotManager sharedInstance].viewSpotCache;
            break;
        }
        default:
            break;
    }
}

- (void)routeNavAction:(int)index withType:(int)type
{
    
    if (self.tabBar.selectedItem.tag == 2)      //自选景点导航
    {
        BOOL isSimulation = type;
        NAV_TYPE nav_type = (NAV_TYPE)index;
        
        PoiPoint *poiPoint = [PoiPoint pointWithName:spotData.SpotName withLongitude:spotData.SpotLng.doubleValue withLatitude:spotData.SpotLat.doubleValue withPoiID:spotData.SpotID.intValue];
        [[MapManager sharedInstanced] startNavByOne:poiPoint withType:nav_type simulation:isSimulation withBarriers:@""];
        
        MyNavController *controller = [[MyNavController alloc] initWithNibName:@"MyNavController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
        SAFERELEASE(controller)
    }
    else        //推荐路线导航
    {
        NSArray *spotIDs = [routData.RouteList componentsSeparatedByString:@","];
        NSArray *spots = [[DataAccessManager sharedDataModel] getSpotsDetailByIDs:spotIDs];
        NSMutableArray *poiArray = [[[NSMutableArray alloc] init] autorelease];
        for (ZS_CustomizedSpot_entity *entity in spots)
        {
            PoiPoint *point = [PoiPoint pointWithName:entity.SpotName withLongitude:[entity.SpotLng doubleValue] withLatitude:[entity.SpotLat doubleValue] withPoiID:[entity.SpotID intValue]];
            [poiArray addObject:point];
        }
        [[MapManager sharedInstanced] startNavByMany:poiArray withType:index simulation:type withBarriers:@""];
        MyNavController *controller = [[MyNavController alloc] initWithNibName:@"MyNavController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
        SAFERELEASE(controller)
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    
    [[MapManager sharedInstanced] cancelRequestNavCenter];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_REMOVE_SPOT object:nil];
    SAFERELEASE(addedSpot)
    SAFERELEASE(_topTitle);
    SAFERELEASE(_backBtn);
    SAFERELEASE(_backLabel);
    SAFERELEASE(_tabbarItemOne);
    SAFERELEASE(_tabbarItemTwo);
    SAFERELEASE(_tabbarItemThree);
    SAFERELEASE(_mScrollView);
    SAFERELEASE(_tabBar);
    SAFERELEASE(recomdLineTableView)
    SAFERELEASE(tableViewThree)
    [_routeSpotBtn release];
    [_routeSpotImgView release];
    [_routeSpotLabel release];
    [_chosenLabel release];
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
    [self setRouteSpotBtn:nil];
    [self setRouteSpotImgView:nil];
    [self setRouteSpotLabel:nil];
    [self setChosenLabel:nil];
    [super viewDidUnload];
}
@end
