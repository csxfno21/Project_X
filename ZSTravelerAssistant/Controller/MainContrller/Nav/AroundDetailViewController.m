//
//  AroundDetailViewController.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "AroundDetailViewController.h"
#define CELLHIGHT 70
#define CELLHIGHTSHOWN 110

@interface AroundDetailViewController ()

@end

@implementation AroundDetailViewController
@synthesize titleArray,picArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.titleArray = [NSArray arrayWithObjects:[Language stringWithName:PARK],[Language stringWithName:TICKET_OFFICE],[Language stringWithName:MEDICAL_CENTER],[Language stringWithName:TOILET],[Language stringWithName:SHOP],[Language stringWithName:CATERING],[Language stringWithName:TOUR_BUS],[Language stringWithName:BUS_STATION],[Language stringWithName:CALLBOX], nil];
        self.picArray = [NSArray arrayWithObjects:@"Around1.png",@"Around2.png",@"Around3.png",@"Around4.png",@"Around5.png",@"Around6.png",@"Around7.png",@"Around8.png",@"Around9.png", nil];
        openIndex = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.topTitleLabel.text = [titleArray objectAtIndex:self.index];
    self.backLabel.text = [Language stringWithName:BACK];
    
    if (self.data)
    {
        if (self.index == 0)
        {
            NSMutableArray *parkData = [[[NSMutableArray alloc]init]autorelease];
            for (ZS_CommonNav_entity *entity in self.data)
            {
                [parkData addObject:entity];
            }
            //        self.mTableView = parkData;

        }else if(self.index == 1)
        {
            NSMutableArray *ticketData = [[[NSMutableArray alloc]init]autorelease];
            for (ZS_CommonNav_entity *entity in self.data)
            {
                [ticketData addObject:entity];
            }
            
        }else if(self.index == 2)
        {
            NSMutableArray *medicalData = [[[NSMutableArray alloc]init]autorelease];
            for (ZS_CommonNav_entity *entity in self.data)
            {
                [medicalData addObject:entity];
            }
            
        }else if(self.index == 3)
        {
            NSMutableArray *toiletData = [[[NSMutableArray alloc]init]autorelease];
            for (ZS_CommonNav_entity *entity in self.data)
            {
                [toiletData addObject:entity];
            }
            
        }else if(self.index == 6)
        {
            NSMutableArray *sightseeData = [[[NSMutableArray alloc]init]autorelease];
            for (ZS_CommonNav_entity *entity in self.data)
            {
                [sightseeData addObject:entity];
            }
            
        }else if(self.index == 7)
        {
            NSMutableArray *busData = [[[NSMutableArray alloc]init]autorelease];
            for (ZS_CommonNav_entity *entity in self.data)
            {
                [busData addObject:entity];
            }
            
        }else if(self.index == 8)
        {
            NSMutableArray *callboxData = [[[NSMutableArray alloc]init]autorelease];
            for (ZS_CommonNav_entity *entity in self.data)
            {
                [callboxData addObject:entity];
            }
            
        }
        
    }

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
    AroundDetailTableCell *aroundTableCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (aroundTableCell == nil)
    {
        aroundTableCell = [[[AroundDetailTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        aroundTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    aroundTableCell.arounDelegate = self;
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
    if(entity)
    {
        aroundTableCell.typeImgView.image = [UIImage imageNamed:[picArray objectAtIndex:self.index]] ;
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
        aroundTableCell.contentLabel.text = entity.NavContent;
    }
    return  aroundTableCell;
}
#pragma mark- aroundDetailViewController delegate
-(void)aroundTableViewCellAction:(COMMON_NAV_TYPE)menuType withIndex:(int)index
{
    switch (menuType) {
        case COMMON_NAV_TYPE_LOCATION:
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
        case COMMON_NAV_TYPE_HERE:
        {
            selectEntity = [_data objectAtIndex:index];
            CGFloat xWidth = self.view.bounds.size.width - 16.f;
            CGFloat yHeight = 300.0f;
            CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
            RouteNavPopView *popView = [RouteNavPopView instanceRouteNavPopView];
            popView.frame = CGRectMake(8, yOffset, xWidth, yHeight);
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


- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    SAFERELEASE(_data)
    [titleArray release];
    [picArray release];
//    SAFERELEASE(selectedtIndex)
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
