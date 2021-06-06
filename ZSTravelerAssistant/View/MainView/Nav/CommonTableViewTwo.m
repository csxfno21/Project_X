//
//  CommonTableViewTwo.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-15.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "CommonTableViewTwo.h"
#define CELLHIGHT 70.0f
#define CELLHIGHTSHOWN 110.0f

@implementation CommonTableViewTwo
@synthesize commonDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        openIndex = [[NSMutableDictionary alloc] init];
        [openIndex setObject:INTTOOBJ(-1) forKey:INTTOOBJ(TOUR_BUS_TYPE)];
        [openIndex setObject:INTTOOBJ(-1) forKey:INTTOOBJ(SPOT_BUS_TYPE)];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}
- (void)setData:(NSDictionary *)data
{
    SAFERELEASE(_data)
    _data = [data retain];
    [self reloadData];
}
#pragma mark- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int opIndex = [[openIndex objectForKey:INTTOOBJ(self.busType)] intValue];
    if (opIndex == indexPath.row)
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
    NSArray *array = [self.data objectForKey:INTTOOBJ(self.busType)];
    int number = array.count;
    if (number == 0)
    {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    else
    {
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return number;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    AroundDetailTableCell *aroundTableCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (aroundTableCell == nil)
    {
        aroundTableCell = [[[AroundDetailTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        aroundTableCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    aroundTableCell.tag = indexPath.row;
    aroundTableCell.arounDelegate = self;
    int opIndex = [[openIndex objectForKey:INTTOOBJ(self.busType)] intValue];
    if(indexPath.row == opIndex)
    {
        aroundTableCell.bIsShow = YES;
    }
    else
    {
        aroundTableCell.bIsShow = NO;
    }
    if(self.busType == TOUR_BUS_TYPE)
        aroundTableCell.typeImgView.image = [UIImage imageNamed:@"Around7.png"];
    else
        aroundTableCell.typeImgView.image = [UIImage imageNamed:@"Around8.png"];
    NSArray *array = [self.data objectForKey:INTTOOBJ(self.busType)];
    if(ISARRYCLASS(array))
    {
        ZS_CommonNav_entity *entity = [array objectAtIndex:indexPath.row];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AroundDetailTableCell *cell = (AroundDetailTableCell *)[tableView cellForRowAtIndexPath:indexPath];
    int opIndex = [[openIndex objectForKey:INTTOOBJ(self.busType)] intValue];
    if(opIndex == indexPath.row)
    {
        cell.bIsShow = !cell.bIsShow;
        if(!cell.bIsShow)[openIndex setObject:INTTOOBJ(-1) forKey:INTTOOBJ(self.busType)];
    }
    else
    {
        if(opIndex != -1)
        {
            AroundDetailTableCell *lastOpenCell = (AroundDetailTableCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:opIndex inSection:0]];
            if(lastOpenCell.bIsShow)
            {
                lastOpenCell.bIsShow = NO;
            }
        }
        cell.bIsShow = YES;
        [openIndex setObject:INTTOOBJ(indexPath.row) forKey:INTTOOBJ(self.busType)];
        
    }
    CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
    if (cellRect.origin.y - self.contentOffset.y + CELLHIGHTSHOWN > self.frame.size.height)
    {
        float needScrolOffset = CELLHIGHTSHOWN - (self.frame.size.height - cellRect.origin.y + self.contentOffset.y);
        [self setContentOffset:CGPointMake(0, needScrolOffset + self.contentOffset.y) animated:YES];
    }

    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -  arounDelegate
- (void)aroundTableViewCellAction:(COMMON_NAV_TYPE)menuType withIndex:(int)index
{
    if (commonDelegate && [commonDelegate respondsToSelector:@selector(commonItemDidSelected:withBusType:withType:withEntity:)])
    {
         NSArray *array = [self.data objectForKey:INTTOOBJ(self.busType)];
        if (index < array.count)
        {
            ZS_CommonNav_entity *entity = [array objectAtIndex:index];
            [commonDelegate commonItemDidSelected:index withBusType:self.busType withType:menuType withEntity:entity];
        }
    }
}

-(void)dealloc
{
    commonDelegate = nil;
    SAFERELEASE(openIndex)
    SAFERELEASE(_data)
    [super dealloc];
}
@end
