//
//  SpotViewController.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-15.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "SpotViewController.h"
#import "SpotManager.h"
//#define TABLEVIEW_TAG 100

@interface SpotViewController ()

@end

@implementation SpotViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
//        self.topTitleLabel.text = [Language stringWithName:SPOT_INFO];
        self.backLabel.text = [Language stringWithName:BACK];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    spotDic = [[NSMutableDictionary alloc] init];

    RouteThirdTableView *tmpTableView = [[RouteThirdTableView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44 )];
    if (!iPhone5)
    {
        tmpTableView.frame = CGRectMake(0,44, 320, 480 - 65) ;
    }
    self.mTableView = tmpTableView;
    self.mTableView.RouteDelegate = self;
    NSArray *allSpots = [[DataAccessManager sharedDataModel] getAllSpot];
    ZS_CustomizedSpot_entity *zsl = [[DataAccessManager sharedDataModel] getSpotBySpotID:[NSString stringWithFormat:@"%d",SCENIC_ZSL]];
    ZS_CustomizedSpot_entity *mxl = [[DataAccessManager sharedDataModel] getSpotBySpotID:[NSString stringWithFormat:@"%d",SCENIC_MXL]];
    ZS_CustomizedSpot_entity *lgs = [[DataAccessManager sharedDataModel] getSpotBySpotID:[NSString stringWithFormat:@"%d",SCENIC_LGS]];
    NSMutableArray *lgsSpots = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *zslSpots = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *mxlSpots = [[[NSMutableArray alloc] init] autorelease];
    NSMutableArray *jqjSpots = [[[NSMutableArray alloc] init] autorelease];
    
    for (ZS_CustomizedSpot_entity *entity in allSpots)
    {
        switch ([entity.SpotParentID intValue])
        {
            case SCENIC_LGS:
            {
                entity.SpotTickets = lgs.SpotTickets;
                entity.SpotStar = lgs.SpotStar;
                [lgsSpots addObject:entity];
                break;
            }
            case SCENIC_ZSL:
            {
                entity.SpotTickets = zsl.SpotTickets;
                entity.SpotStar = zsl.SpotStar;
                [zslSpots addObject:entity];
                break;
            }
            case SCENIC_MXL:
            {
                entity.SpotTickets = mxl.SpotTickets;
                entity.SpotStar = mxl.SpotStar;
                [mxlSpots addObject:entity];
                break;
            }
            case 0:    //景区间 数据 需要 修改 parentID
            {
                if([entity.SpotType isEqualToString:@"1"])
                [jqjSpots addObject:entity];
                break;
            }
            default:
                break;
        }
    }
    
    [spotDic setObject:lgsSpots forKey:INTTOOBJ(SCENIC_LGS)];
    [spotDic setObject:zslSpots forKey:INTTOOBJ(SCENIC_ZSL)];
    [spotDic setObject:mxlSpots forKey:INTTOOBJ(SCENIC_MXL)];
    [spotDic setObject:jqjSpots forKey:INTTOOBJ(SCENIC_IN)];
    selectedType = [MapManager sharedInstanced].currentScenic;
    switch (selectedType)
    {
        case SCENIC_LGS:
        {
            
            [self.topTitle setTitle:[Language stringWithName:LGS_SPOT] forState:UIControlStateNormal];
            break;
        }
        case SCENIC_ZSL:
        {
            [self.topTitle setTitle:[Language stringWithName:ZSL_SPOT] forState:UIControlStateNormal];
            break;
        }
        case SCENIC_MXL:
        {
            [self.topTitle setTitle:[Language stringWithName:MXL_SPOT] forState:UIControlStateNormal];
            break;
        }
        default:
        {
            [self.topTitle setTitle:[Language stringWithName:ZSFJQ_SPOT] forState:UIControlStateNormal];
            break;
        }
    }
    if(selectedType == SCENIC_OUT || selectedType == SCENIC_UNKNOW || selectedType == SCENIC_IN)
    tmpTableView.data = [spotDic objectForKey:INTTOOBJ(SCENIC_IN)];
    else
    tmpTableView.data = [spotDic objectForKey:INTTOOBJ(selectedType)];
    [self.view addSubview:tmpTableView];
    SAFERELEASE(tmpTableView)
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- routeNavAction
- (void)routeNavAction:(int)index withType:(int)type
{
    BOOL isSimulation = type;
    NAV_TYPE nav_type = (NAV_TYPE)index;
    
    PoiPoint *poiPoint = [PoiPoint pointWithName:spotData.SpotName withLongitude:spotData.SpotLng.doubleValue withLatitude:spotData.SpotLat.doubleValue withPoiID:spotData.SpotID.intValue];
    [[MapManager sharedInstanced] startNavByOne:poiPoint withType:nav_type simulation:isSimulation withBarriers:@""];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)topTitleAction:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:[Language stringWithName:CANCEL]
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:[Language stringWithName:ZSFJQ_SPOT], [Language stringWithName:ZSL_SPOT],[Language stringWithName:MXL_SPOT],[Language stringWithName:LGS_SPOT],nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            selectedType = SCENIC_IN;
            [self.topTitle setTitle:[Language stringWithName:ZSFJQ_SPOT] forState:UIControlStateNormal];
            self.mTableView.data = [spotDic objectForKey:INTTOOBJ(SCENIC_IN)];
            [self.mTableView reloadData];
            break;
        }
        case 1:
        {
            selectedType = SCENIC_ZSL;
            [self.topTitle setTitle:[Language stringWithName:ZSL_SPOT] forState:UIControlStateNormal];
            self.mTableView.data = [spotDic objectForKey:INTTOOBJ(SCENIC_ZSL)];
            [self.mTableView reloadData];
            break;
        }
        case 2:
        {
            selectedType = SCENIC_MXL;
            [self.topTitle setTitle:[Language stringWithName:MXL_SPOT] forState:UIControlStateNormal];
            self.mTableView.data = [spotDic objectForKey:INTTOOBJ(SCENIC_MXL)];
            [self.mTableView reloadData];
            break;
        }
        case 3:
        {
            selectedType = SCENIC_LGS;
            [self.topTitle setTitle:[Language stringWithName:LGS_SPOT] forState:UIControlStateNormal];
            self.mTableView.data = [spotDic objectForKey:INTTOOBJ(SCENIC_LGS)];
            [self.mTableView reloadData];
            break;
        }
        default:
            break;
    }
}

#pragma mark - RouteThirdTableView Delegate
- (void)routeThirdItemDidSelected:(int)index withType:(ROUTE_MENU_TYPE)type
{
    NSArray *spots = [spotDic objectForKey:INTTOOBJ(selectedType)];
    if(index >= spots.count)return;
    switch (type)
    {
        case ROUTE_MENU_TYPE_DETAIL:
        {
            SpotDetailViewController *controller = [[SpotDetailViewController alloc] init];
            controller.spotEntity = [spots objectAtIndex:index];
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller);
            break;
        }
        case ROUTE_MENU_TYPE_LOCATION:
        {
            ZS_CustomizedSpot_entity *entity = [spots objectAtIndex:index];
            AGSPoint *point = [AGSPoint pointWithX:[entity.SpotLng doubleValue] y:[entity.SpotLat doubleValue] spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
            [[MapManager sharedInstanced] didShowCallout2Spot:entity.SpotName withPoint:point];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case ROUTE_MENU_TYPE_NAVIGATION:
        {
            spotData = [spots objectAtIndex:index];
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
//#pragma mark- RecomdLineTableView Delegate
//- (void)recomdLineItemDidSelectedMenuType:(int)index withLineType:(LINETYPE)lineType withType:(ROUTE_MENU_TYPE)type
//{
//    switch (lineType)
//    {
//        case LINETYPE_THEME:
//        {
//            if(type == ROUTE_MENU_TYPE_DETAIL)
//            {
//                RouteDetailViewController *detail = [[RouteDetailViewController alloc] initWithNibName:@"RouteDetailViewController" bundle:nil];
//                [self.navigationController pushViewController:detail animated:YES];
//                SAFERELEASE(detail)
//            }
//            else if(type == ROUTE_MENU_TYPE_LOCATION)
//            {
//                
//            }
//            else if (type == ROUTE_MENU_TYPE_NAVIGATION)
//            {
//                CGFloat xWidth = self.view.bounds.size.width - 30.0f;
//                CGFloat yHeight = 300.0f;
//                CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
//                RouteNavPopView *popView = [RouteNavPopView instanceRouteNavPopView];
//                popView.frame = CGRectMake(15, yOffset, xWidth, yHeight);
//                [popView setTitleText:@"全线·钟山印象"];
//                popView.delegate = self;
//                [popView show];
//            }
//            break;
//        }
//        case LINETYPE_ROUTINE:
//        {
//            if(type == ROUTE_MENU_TYPE_DETAIL)
//            {
//                RouteDetailViewController *detail = [[RouteDetailViewController alloc] initWithNibName:@"RouteDetailViewController" bundle:nil];
//                [self.navigationController pushViewController:detail animated:YES];
//                SAFERELEASE(detail)
//            }
//            else if(type == ROUTE_MENU_TYPE_LOCATION)
//            {
//                
//            }
//            else if (type == ROUTE_MENU_TYPE_NAVIGATION)
//            {
//                CGFloat xWidth = self.view.bounds.size.width - 30.0f;
//                CGFloat yHeight = 300.0f;
//                CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
//                RouteNavPopView *popView = [RouteNavPopView instanceRouteNavPopView];
//                popView.frame = CGRectMake(15, yOffset, xWidth, yHeight);
//                [popView setTitleText:@"全线·钟山印象"];
//                popView.delegate = self;
//                [popView show];
//            }
//            break;
//        }
//        default:
//            break;
//    }
//}
#pragma mark - routeOneViewAction
- (void)routeOneViewAction
{
//    MyNavController *controller = [[MyNavController alloc] initWithNibName:@"MyNavController" bundle:nil];
//    [self.navigationController pushViewController:controller animated:YES];
//    SAFERELEASE(controller)
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    SAFERELEASE(spotDic)
    [_topTitleImgView release];
//    [_topTitleLabel release];
    [_backBtn release];
    [_backLabel release];
    SAFERELEASE(_mTableView)
    [_topTitle release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTopTitleImgView:nil];
    [self setBackBtn:nil];
    [self setBackLabel:nil];
    [self setTopTitle:nil];
    [super viewDidUnload];
}
@end
