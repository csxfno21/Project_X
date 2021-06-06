//
//  RouteThirdTableView.m
//  ZSTravelerAssistant
//
//  Created by 梁谢超 on 13-7-27.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "RouteThirdTableView.h"
#import "SpotManager.h"
@implementation RouteThirdTableView
@synthesize routeDelegate;

#define CELL_HEIGHT             100
#define CELL_HEIGHTBIG          142

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeSpot:) name:NOTIFICATION_REMOVE_SPOT object:nil];
        
        selectedSpot = [[NSMutableDictionary alloc] init];
        openIndex = -1;
        self.delegate = self;
        self.dataSource = self;
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:loadingView];
        if(self.data == nil || self.data.count == 0)
        [loadingView startAnimating];
    }
    return self;
}

- (void)removeSpot:(NSNotification*)notification
{
    int spotID = [notification.object intValue];
    for (int i = 0;i< _data.count;i++)
    {
        ZS_CustomizedSpot_entity *entity = [_data objectAtIndex:i];
        if(entity && (spotID == entity.SpotID.intValue))
        {
            [selectedSpot setObject:INTTOOBJ(0) forKey:INTTOOBJ(i)];
            RouteThirdTableViewCell *cell = (RouteThirdTableViewCell*)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell.m_AddButton setTitle:[Language stringWithName:ADD] forState:UIControlStateNormal];
            break;
        }
    }
    
}
- (void)setData:(NSArray *)data
{
    openIndex = -1;
    _data = data;
    if(_data && _data.count > 0)
    {
//        [refreshFooterView setFrame:CGRectMake(0, _data.count * CELL_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
        [loadingView stopAnimating];
        [self reloadData];
    }
    else
    {
        [loadingView stopAnimating];
    }
}
#pragma mark - tableViewDelegate/DataResource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(openIndex == indexPath.row)
		return CELL_HEIGHTBIG;
	else
        return CELL_HEIGHT;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RouteThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[[RouteThirdTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.type == SPOT_VIEW_CHOOSE)
        {
            cell.m_IVArrow.hidden = YES;
            cell.m_AddButton.hidden = NO;
            
        }
        else
        {
            cell.m_IVArrow.hidden = NO;
            cell.m_AddButton.hidden = YES;
        }
    }
    
    BOOL selected = [[selectedSpot objectForKey:INTTOOBJ(indexPath.row)] boolValue];
    if(selected)
    {
        [cell.m_AddButton setTitle:[Language stringWithName:DELETE] forState:UIControlStateNormal];
    }
    else
    {
        [cell.m_AddButton setTitle:[Language stringWithName:ADD] forState:UIControlStateNormal];
    }
    
    cell.cellDelgate = self;
    cell.tag = indexPath.row;
    
    if(indexPath.row == openIndex)
    {
        cell.bIsShow = YES;
    }
    else
    {
        cell.bIsShow = NO;
    }
    ZS_CustomizedSpot_entity *entity = [self.data objectAtIndex:indexPath.row];
    
    cell.m_LbTitle.text = entity.SpotName;
    cell.m_IVStar.image = [UIImage imageNamed:[NSString stringWithFormat:@"spot-%@.png",entity.SpotStar]];
    
    double distance = [PublicUtils GetDistanceS:[entity.SpotLng doubleValue] withlat1:[entity.SpotLat doubleValue] withlng2:[MapManager sharedInstanced].oldLocation2D.longitude withlat2:[MapManager sharedInstanced].oldLocation2D.latitude];
    if (distance < MAXVIEWDISTANCE)
    {
        if (distance < 1000)
        {
            cell.m_LbDisNum.text = [NSString stringWithFormat:@"%d",(int)distance];
            cell.m_LBDisUnit.hidden = NO;
            cell.m_LBDisUnit.text = [Language stringWithName:DISTANCE_M];
            cell.m_LbDisNum.frame = CGRectMake(123, 65, 70, 20);
            cell.m_LbDisNum.font = [UIFont systemFontOfSize:17];
        }
        else
        {
            double dis = distance / 1000;
            cell.m_LbDisNum.text = [NSString stringWithFormat:@"%.1f",dis];
            cell.m_LBDisUnit.text = [Language stringWithName:KM];
            cell.m_LBDisUnit.hidden = NO;
            cell.m_LbDisNum.frame = CGRectMake(118, 65, 70, 20);
            cell.m_LBDisUnit.frame = CGRectMake(167, 65, 70, 20);
            cell.m_LbDisNum.font = [UIFont systemFontOfSize:17];
        }
        
    }
    else
    {
        cell.m_LbDisNum.font = [UIFont systemFontOfSize:13];
        cell.m_LbDisNum.frame = CGRectMake(135, 65, 60, 20);
        cell.m_LbDisNum.text = [Language stringWithName:DIS_UNKNOWN];
        cell.m_LBDisUnit.hidden = YES;
    }
    NSString *price = entity.SpotTickets;
    if ([@"-1" isEqualToString:entity.SpotTickets] || [@"" isEqualToString:entity.SpotTickets])
    {
        price = [Language stringWithName:FREE];
        cell.m_LbPriceUnit.hidden = YES;
        cell.m_LbPriceNum.frame = CGRectMake(233, 65, 60, 20);
    }
    else
    {
        cell.m_LbPriceUnit.hidden = NO;
        cell.m_LbPriceNum.frame = CGRectMake(242, 65, 30, 20);
    }
    cell.m_LbPriceNum.text = price;
    
    
    UIImage *image = [[NetFileLoadManager sharedInstanced] loadImageByURL:entity.SpotSmallUrl withDelegate:self withID:entity.ID withImgName:entity.SpotSmallImgName withCmdcode:CC_DOWN_IMAGE_SPOT_SMALL];
    [cell.m_IVHead setImage:image];
    if(image)
    {
        
        [cell.loadingView stopAnimating];
    }
    else
    {
        [cell.loadingView startAnimating];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RouteThirdTableViewCell *cell = (RouteThirdTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(openIndex == indexPath.row)
    {
        cell.bIsShow = !cell.bIsShow;
        if(!cell.bIsShow)openIndex = -1;
    }
    else
    {
        if(openIndex != -1)
        {
            RouteThirdTableViewCell *lastOpenCell = (RouteThirdTableViewCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:openIndex inSection:0]];
            if(lastOpenCell.bIsShow)
            {
                lastOpenCell.bIsShow = NO;
            }
        }
        cell.bIsShow = YES;
        openIndex = indexPath.row;
        //判断点开后tableview是否向上移动
        CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
        if (cellRect.origin.y - self.contentOffset.y + CELL_HEIGHTBIG > self.frame.size.height)
        {
            float needScrolOffset = CELL_HEIGHTBIG - (self.frame.size.height - cellRect.origin.y + self.contentOffset.y);
            [self setContentOffset:CGPointMake(0, needScrolOffset + self.contentOffset.y) animated:YES];
        }
        
        
    }

    
    
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
//    [self setLoadingViewFram];
}
//- (void)setLoadingViewFram
//{
//    if (openIndex != -1)
//    {
//        [refreshFooterView setFrame:CGRectMake(0, _data.count * CELL_HEIGHT + CELL_HEIGHTBIG - CELL_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
//    }
//    else
//    {
//        [refreshFooterView setFrame:CGRectMake(0, _data.count * CELL_HEIGHT , 320, REFRESH_HEADER_HEIGHT)];
//    }
//}
#pragma mark - cell delegate
- (void)routeThirdTableViewCellAction:(ROUTE_MENU_TYPE)menuType withIndex:(int)index
{
    if(routeDelegate && [routeDelegate respondsToSelector:@selector(routeThirdItemDidSelected:withType:)])
    {
        [routeDelegate routeThirdItemDidSelected:index withType:menuType];
    }
}
- (void)routeThirdTableViewAdd:(int)index
{
    RouteThirdTableViewCell *cell = (RouteThirdTableViewCell*)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    if(cell)
    {
        BOOL needDelay = NO;
        CGRect cellRect = [self rectForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        if (cellRect.origin.y - self.contentOffset.y + cell.frame.size.height > self.frame.size.height)
        {
            float needScrolOffsetY = cellRect.size.height -  self.frame.size.height + (cellRect.origin.y - self.contentOffset.y);
            [self setContentOffset:CGPointMake(0, needScrolOffsetY + self.contentOffset.y) animated:YES];
            needDelay = YES;
        }
        BOOL selected = [[selectedSpot objectForKey:INTTOOBJ(index)] boolValue];
        if (selected)
        {
            [cell.m_AddButton setTitle:[Language stringWithName:ADD] forState:UIControlStateNormal];
            [selectedSpot setObject:INTTOOBJ(0) forKey:INTTOOBJ(index)];
            //删除 选中的 内容
            if(routeDelegate && [routeDelegate respondsToSelector:@selector(routeThirdItemDeleteSpot:withIndex:)])
            {
                if(index < _data.count)
                {
                    ZS_CustomizedSpot_entity *entity = [_data objectAtIndex:index];
                    [routeDelegate routeThirdItemDeleteSpot:entity withIndex:index];
                }
            }
        }
        else
        {
            [cell.m_AddButton setTitle:[Language stringWithName:DELETE] forState:UIControlStateNormal];
            [selectedSpot setObject:INTTOOBJ(1) forKey:INTTOOBJ(index)];
            //添加内容
            if(routeDelegate && [routeDelegate respondsToSelector:@selector(routeThirdItemAddSpot:withIndex:)])
            {
                if(index < _data.count)
                {
                    addAnimIndex = index;
                    
                    if(needDelay)
                    {
                        [self performSelector:@selector(addAnimDelay) withObject:nil afterDelay:.3];
                    }
                    else
                    {
                        [self addAnimDelay];
                    }
                    
                }
            }
        }
    }
}

- (void)addAnimDelay
{
    ZS_CustomizedSpot_entity *entity = [_data objectAtIndex:addAnimIndex];
    [routeDelegate routeThirdItemAddSpot:entity withIndex:addAnimIndex];
}
//#pragma mark - getMore
//- (void)refresh
//{
//    if(self.data.count == 0)
//    {
//        [self stopLoading];
//        return;
//    }
//    lastDataCount = self.data.count;
//    ZS_CustomizedSpot_entity *entity = (ZS_CustomizedSpot_entity*)[self.data lastObject];
//    [[SpotManager sharedInstance] requestGetViewSpot:self withMoreID:entity.ID];
//
//}

- (void)callBackToUI:(HttpBaseResponse *)response
{
    switch (response.cc_cmd_code)
    {
        case CC_GET_VIEW_SPOT_MORE:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                if(lastDataCount == self.data.count)
                {
                    UIToast *tost = [[UIToast alloc] init];
                    [tost show:[Language stringWithName:NODATA]];
                    SAFERELEASE(tost)
                }
            }
            else
            {
                UIToast *tost = [[UIToast alloc] init];
                [tost show:[Language stringWithName:REQUESTEFAILED]];
                SAFERELEASE(tost)
            }
//            [self stopLoading];
            break;
        }
        case CC_DOWN_IMAGE_SPOT_SMALL:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                DwonImgResponse *res = (DwonImgResponse*)response;
                for (int i = 0;i < self.data.count; i++)
                {
                    ZS_CustomizedSpot_entity *entity = [self.data objectAtIndex:i];
                    RouteThirdTableViewCell *cell = (RouteThirdTableViewCell*)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    if(entity.ID == res.imgID)
                    {
                        UIImage *image = [[NetFileLoadManager sharedInstanced] loadImageByURL:entity.SpotSmallUrl withDelegate:self withID:entity.ID withImgName:entity.SpotSmallImgName withCmdcode:response.cc_cmd_code];
                        
                        if(image)
                        {
                            [cell.m_IVHead setImage:image];
                            [cell.loadingView stopAnimating];
                        }
                        return;
                    }
                }
                
            }
            break;
        }
        default:
            break;
    }
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_REMOVE_SPOT object:nil];
    [[SpotManager sharedInstance] cancelRequest:self];
    [[NetFileLoadManager sharedInstanced] cancelRequest:self];
    SAFERELEASE(loadingView)
    SAFERELEASE(selectedSpot);
    routeDelegate = nil;
    [super dealloc];
}


@end
