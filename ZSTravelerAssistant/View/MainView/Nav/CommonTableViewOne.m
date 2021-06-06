//
//  CommonTableViewOne.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-14.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "CommonTableViewOne.h"
#define CELLHIGHT 70.0f
#define CELLHIGHTSHOWN 110.0f

@implementation CommonTableViewOne
@synthesize commonDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = self;
        self.dataSource = self;
        openIndex = -1;
    }
    return self;
}
- (void)setData:(NSArray *)data
{
    SAFERELEASE(_data)
    _data = [data retain];
    [self reloadData];
}
#pragma mark- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
    int number = self.data.count;
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
    CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
    if (cellRect.origin.y - self.contentOffset.y + CELLHIGHTSHOWN > self.frame.size.height)
    {
        float needScrolOffset = CELLHIGHTSHOWN - (self.frame.size.height - cellRect.origin.y + self.contentOffset.y);
        [self setContentOffset:CGPointMake(0, needScrolOffset + self.contentOffset.y) animated:YES];
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
    ZS_CommonNav_entity *entity = [self.data objectAtIndex:indexPath.row];
    if(entity.NavType.intValue == POI_PARK)
        aroundTableCell.typeImgView.image = [UIImage imageNamed:@"Around1.png"];
    else
        aroundTableCell.typeImgView.image = [UIImage imageNamed:@"Around0.png"];
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
    return  aroundTableCell;

}

#pragma mark -  arounDelegate
- (void)aroundTableViewCellAction:(COMMON_NAV_TYPE)menuType withIndex:(int)index
{
    
    if (commonDelegate && [commonDelegate respondsToSelector:@selector(commontableViewAction:withAction:withEntity:)])
    {
        if (index < _data.count)
        {
            ZS_CommonNav_entity *entity = [_data objectAtIndex:index];
            [commonDelegate commontableViewAction:index withAction:menuType withEntity:entity];
        }
    }
}

-(void)dealloc
{
    commonDelegate = nil;
    SAFERELEASE(_data)
    [super dealloc];
}
@end
