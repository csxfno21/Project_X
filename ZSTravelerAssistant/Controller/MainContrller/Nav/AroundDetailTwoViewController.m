//
//  AroundDetailTwoViewController.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-21.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "AroundDetailTwoViewController.h"
#define CELLHIGHT 90
#define CELLHIGHTSHOWN 130

@interface AroundDetailTwoViewController ()

@end

@implementation AroundDetailTwoViewController

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
    openIndex = -1;
    
    self.backLabel.text = [Language stringWithName:BACK];
    ZS_CommonNav_entity *entity = [_data lastObject];
    if(entity.NavType.intValue == POI_SHOP)
    {
        self.topTitleLabel.text = [Language stringWithName:SHOP];
    }
    else if(entity.NavType.intValue == POI_REPAST)
    {
        self.topTitleLabel.text = [Language stringWithName:CATERING];
    }
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setData:(NSArray *)data
{
    SAFERELEASE(_data)
    _data = [data retain];
    [self.mTableView reloadData];
}
#pragma mark- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (openIndex == indexPath.row)
    {
        return CELLHIGHTSHOWN;
    }
    else
    {
        return CELLHIGHT;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int number = _data.count;
    if (number == 0)
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return number;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AroundDetailTableCell *cell = (AroundDetailTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(openIndex == indexPath.row)
    {
        cell.bIsShow = !cell.bIsShow;
        if(!cell.bIsShow)openIndex = -1;
    }
    else
    {
        if(openIndex != -1)
        {
            AroundDetailTableCell *lastOpenCell = (AroundDetailTableCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:openIndex inSection:0]];
            if(lastOpenCell.bIsShow)
            {
                lastOpenCell.bIsShow = NO;
            }
        }
        cell.bIsShow = YES;
        openIndex = indexPath.row;
    }
    CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
    if (cellRect.origin.y - tableView.contentOffset.y + CELLHIGHTSHOWN > tableView.frame.size.height)
    {
        float needScrolOffset = CELLHIGHTSHOWN - (tableView.frame.size.height - cellRect.origin.y + tableView.contentOffset.y);
        [tableView setContentOffset:CGPointMake(0, needScrolOffset + tableView.contentOffset.y) animated:YES];
    }

    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    AroundDetailTableCell2 *aroundTableCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (aroundTableCell == nil)
    {
        aroundTableCell = [[[AroundDetailTableCell2 alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        aroundTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    aroundTableCell.aroun2Delegate = self;
    aroundTableCell.tag = indexPath.row;
    
    if(indexPath.row == openIndex)
    {
        aroundTableCell.bIsShow = YES;
    }
    else
    {
        aroundTableCell.bIsShow = NO;
    }
    
    ZS_CommonNav_entity *entity = [_data objectAtIndex:indexPath.row];
    if(entity.NavType.intValue == POI_SHOP)
    {
        aroundTableCell.typeImgView.image = [UIImage imageNamed:@"Around5.png"] ;
    }
    else if(entity.NavType.intValue == POI_REPAST)
    {
        aroundTableCell.typeImgView.image = [UIImage imageNamed:@"Around6.png"] ;
    }
    aroundTableCell.titleLabel.text = entity.NavTitle;
    double distance = [PublicUtils GetDistanceS:[entity.NavLng doubleValue] withlat1:[entity.NavLat doubleValue] withlng2:[MapManager sharedInstanced].oldLocation2D.longitude withlat2:[MapManager sharedInstanced].oldLocation2D.latitude];
    if (distance < MAXVIEWDISTANCE)
    {
        aroundTableCell.disLabel.text = [NSString stringWithFormat:@"%d%@",(int)distance,[Language stringWithName:DISTANCE_M]];
    }
    else
    {
        aroundTableCell.disLabel.text = [Language stringWithName:DIS_UNKNOWN];
    }
    aroundTableCell.contentLabel.text = entity.NavPosition;
    aroundTableCell.bottomLabel.text = entity.NavRemark;
    
    return  aroundTableCell;
}

#pragma mark- aroundDetailTwoViewController delegate
-(void)aroundTableViewCellTwoAction:(ROUTE_MENU_TYPE)menuType withIndex:(int)index
{
    switch (menuType) {
        case ROUTE_MENU_TYPE_DETAIL:
        {
            DetialViewController *controller = [[DetialViewController alloc]initWithNibName:@"DetialViewController" bundle:nil];
            controller.entity = [_data objectAtIndex:index];
            selectEntity = controller.entity;
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller)
            break;
        }
        case ROUTE_MENU_TYPE_LOCATION:
        {
            if (self.data == nil)
            {
                return;
            }
            selectEntity = [self.data objectAtIndex:index];
            AGSPoint *point = [AGSPoint pointWithX:[selectEntity.NavLng doubleValue] y:[selectEntity.NavLat doubleValue] spatialReference:[AGSSpatialReference spatialReferenceWithWKID:4326 WKT:nil]];
            [[MapManager sharedInstanced] didShowCallout2POI:selectEntity.NavTitle withPoint:point];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
        case ROUTE_MENU_TYPE_NAVIGATION:
        {
            selectEntity = [_data objectAtIndex:index];
            CGFloat xWidth = self.view.bounds.size.width - 30.f;
            CGFloat yHeight = 300.0f;
            CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
            RouteNavPopView *popView = [RouteNavPopView instanceRouteNavPopView];
            popView.frame = CGRectMake(15, yOffset, xWidth, yHeight);
            [popView setTitleText:selectEntity.NavTitle];
            popView.delegate = self;
            [popView show];
            break;
        }
        default:
            break;
    }

}

-(void)routeNavAction:(int)index withType:(int)type
{
    BOOL isSimulation = type;
    NAV_TYPE nav_type = (NAV_TYPE)index;
    
    PoiPoint *poiPoint = [PoiPoint pointWithName:selectEntity.NavTitle withLongitude:selectEntity.NavLng.doubleValue withLatitude:selectEntity.NavLat.doubleValue withPoiID:selectEntity.NavIID.intValue];
    [[MapManager sharedInstanced] startNavByOne:poiPoint withType:nav_type simulation:isSimulation withBarriers:@""];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    SAFERELEASE(_data)
    [_topTitleImgView release];
    [_topTitleLabel release];
    [_backBtn release];
    [_backLabel release];
    [_mTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTopTitleImgView:nil];
    [self setTopTitleLabel:nil];
    [self setBackBtn:nil];
    [self setBackLabel:nil];
    [self setMTableView:nil];
    [super viewDidUnload];
}
@end
