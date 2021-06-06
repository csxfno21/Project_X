//
//  RecomdLineTableView.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-31.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "RecomdLineTableView.h"

#define CELLHIGHT 100
#define CELLHIGHTSHOWN 142

@implementation RecomdLineTableView
@synthesize recomdelegate,selectedtIndex;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        indexs = [[NSMutableDictionary alloc] init];
        [indexs setObject:[NSNumber numberWithInt:-1] forKey:[NSNumber numberWithInt:LINETYPE_THEME]];
        [indexs setObject:[NSNumber numberWithInt:-1] forKey:[NSNumber numberWithInt:LINETYPE_ROUTINE]];
        
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
- (void)setData:(NSArray *)data
{
    _data = data;
    if(_data && _data.count > 0)
    {
        [refreshFooterView setFrame:CGRectMake(0, _data.count * CELLHIGHT, 320, REFRESH_HEADER_HEIGHT)];
        [loadingView stopAnimating];
        [self reloadData];
    }
    else
    {
        [loadingView stopAnimating];
    }
}
- (void)setLoadingViewFram
{
    if ([[indexs objectForKey:[NSNumber numberWithInt:self.type]] intValue] != -1)
    {
        [refreshFooterView setFrame:CGRectMake(0, _data.count * CELLHIGHT + CELLHIGHTSHOWN - CELLHIGHT, 320, REFRESH_HEADER_HEIGHT)];
    }
    else
    {
        [refreshFooterView setFrame:CGRectMake(0, _data.count * CELLHIGHT , 320, REFRESH_HEADER_HEIGHT)];
    }
}
#pragma mark - getMore
- (void)refresh
{
    if(self.data.count == 0)
    {
        [self stopLoading];
        return;
    }
    if(_data)
    {
        lastDataCount = self.data.count;
        
        if(self.type == LINETYPE_THEME)
        {
            ZS_SpotRoute_entity *entity = (ZS_SpotRoute_entity*)[self.data lastObject];
           [[SpotRouteManager sharedInstance] requestGetThemRoute:self withMoreID:entity.ID];
        }
        else
        {
            ZS_SpotRoute_entity *entity = (ZS_SpotRoute_entity*)[self.data lastObject];
            [[SpotRouteManager sharedInstance] requestGetCommonRoute:self withMoreID:entity.ID];
        }
    }
    
}
#pragma mark- tableViewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int openIndex = [[indexs objectForKey:[NSNumber numberWithInt:self.type]] intValue];
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
    RecomdLineCell *cell = (RecomdLineCell *)[tableView cellForRowAtIndexPath:indexPath];
    int openIndex = [[indexs objectForKey:[NSNumber numberWithInt:self.type]] intValue];
    if(openIndex == indexPath.row)
    {
        cell.bIsShow = !cell.bIsShow;
        if(!cell.bIsShow)[indexs setObject:[NSNumber numberWithInt:-1] forKey:[NSNumber numberWithInt:self.type]];
//            openIndex = -1;
    }
    else
    {
        if(openIndex != -1)
        {
            RecomdLineCell *lastOpenCell = (RecomdLineCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:openIndex inSection:0]];
            if(lastOpenCell.bIsShow)
            {
                lastOpenCell.bIsShow = NO;
            }
        }
        cell.bIsShow = YES;
        [indexs setObject:[NSNumber numberWithInt:indexPath.row] forKey:[NSNumber numberWithInt:self.type]];
//        openIndex = indexPath.row;
    }
    CGRect cellRect = [self rectForRowAtIndexPath:indexPath];
    if (cellRect.origin.y - self.contentOffset.y + CELLHIGHTSHOWN > self.frame.size.height)
    {
        float needScrolOffset = CELLHIGHTSHOWN - (self.frame.size.height - cellRect.origin.y + self.contentOffset.y);
        [self setContentOffset:CGPointMake(0, needScrolOffset + self.contentOffset.y) animated:YES];
    }

    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self setLoadingViewFram];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    RecomdLineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell = [[[RecomdLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.recomdCellDelgate = self;
    
    int openIndex = [[indexs objectForKey:[NSNumber numberWithInt:self.type]] intValue];
    if(indexPath.row == openIndex)
    {
        cell.bIsShow = YES;
    }
    else
    {
        cell.bIsShow = NO;
    }
    
    ZS_SpotRoute_entity *entity = [self.data objectAtIndex:indexPath.row];
    cell.tag = indexPath.row;
    cell.cellTitle.text = entity.RouteTitle;
    cell.cellContent.text = entity.RouteContent;
    cell.disValueLabel.text = entity.RouteLength;
    cell.priceValueLabel.text = entity.RouteTicket;
    UIImage *image = nil;
    if(self.type == LINETYPE_THEME)
    {
        image = [[NetFileLoadManager sharedInstanced] loadImageByURL:entity.RouteSmallImgUrl withDelegate:self withID:entity.ID withImgName:entity.RouteSmallImgName withCmdcode:CC_DOWN_IMAGE_THEM_ROUTE_SMALL];
    }
    else
    {
        image = [[NetFileLoadManager sharedInstanced] loadImageByURL:entity.RouteSmallImgUrl withDelegate:self withID:entity.ID withImgName:entity.RouteSmallImgName withCmdcode:CC_DOWN_IMAGE_COMMON_ROUTE_SMALL];
    }
    [cell.cellRecomdImgView setImage:image];
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
#pragma mark- recomdLineTableView delegate
- (void)recomdLineCellAction:(ROUTE_MENU_TYPE)menuType withIndex:(int)index
{
    if(recomdelegate && [recomdelegate respondsToSelector:@selector(recomdLineItemDidSelectedMenuType:withLineType:withType:)])
    {
        [recomdelegate recomdLineItemDidSelectedMenuType:index withLineType:self.type withType:menuType];
    }
}

-(void)callBackToUI:(HttpBaseResponse *)response
{
    switch (response.cc_cmd_code)
    {
        case CC_GET_THEM_ROUTE_MORE:
        case CC_GET_COMMON_ROUTE_MORE:
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
            [self stopLoading];
            break;
        }
        case CC_DOWN_IMAGE_THEM_ROUTE_SMALL:
        case CC_DOWN_IMAGE_COMMON_ROUTE_SMALL:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                DwonImgResponse *res = (DwonImgResponse*)response;
                for (int i = 0;i < self.data.count; i++)
                {
                    ZS_SpotRoute_entity *entity = [self.data objectAtIndex:i];
                    RecomdLineCell *cell = (RecomdLineCell*)[self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                    
                    if(entity.ID == res.imgID)
                    {
                       UIImage *image = [[NetFileLoadManager sharedInstanced] loadImageByURL:entity.RouteSmallImgUrl withDelegate:self withID:entity.ID withImgName:entity.RouteSmallImgName withCmdcode:response.cc_cmd_code];
                        
                        if(image)
                        {
                            [cell.cellRecomdImgView setImage:image];
                            [cell.loadingView stopAnimating];
                        }
                        else
                        {
                            [cell.loadingView startAnimating];
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
-(void)dealloc
{
    [[NetFileLoadManager sharedInstanced] cancelRequest:self];
    [[SpotRouteManager sharedInstance] cancelRequest:self];
    SAFERELEASE(loadingView)
    SAFERELEASE(indexs)
    recomdelegate = nil;
    [selectedtIndex release];
    selectedtIndex = nil;
    [super dealloc];
}
@end