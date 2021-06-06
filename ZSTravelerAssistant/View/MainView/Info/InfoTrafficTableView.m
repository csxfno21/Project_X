//
//  InfoTrafficTableView.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "InfoTrafficTableView.h"
#import "InfoTrafficTableViewCell.h"

#define CELLHIGHE 100.0

@implementation InfoTrafficTableView
@synthesize trafficdelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //
        self.separatorColor = [UIColor clearColor];
        //去除线
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.dataSource = self;
        self.delegate = self;
        loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:loadingView];
        if(self.trafficData == nil || self.trafficData.count == 0)
        [loadingView startAnimating];
    }
    return self;
}
- (void)setTrafficData:(NSArray *)trafficData
{
    _trafficData = trafficData;
    if(_trafficData && _trafficData.count > 0)
    {
        [refreshFooterView setFrame:CGRectMake(0, _trafficData.count * CELLHIGHE, 320, REFRESH_HEADER_HEIGHT)];
        [loadingView stopAnimating];
        [self reloadData];
    }
    else
    {
        [loadingView stopAnimating];
    }
}

#pragma mark - getMore
- (void)refresh
{
    if(self.trafficData.count == 0)
    {
        [self stopLoading];
        return;
    }
    if(_trafficData)
    {
        lastDataCount = self.trafficData.count;
        
        if(self.type == TRAFFICTYPE_BUS)
        {
            ZS_Traffic_entity *entity = (ZS_Traffic_entity*)[self.trafficData lastObject];
            [[TrafficManager sharedInstance] requestGetBusInfo:self withMoreID:entity.ID];
        }
        else
        {
            ZS_Traffic_entity *entity = (ZS_Traffic_entity*)[self.trafficData lastObject];
            [[TrafficManager sharedInstance] requestGetTourisCarInfo:self withMoreID:entity.ID];
        }
    }

}
#pragma mark - uitableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHIGHE;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trafficData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    InfoTrafficTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[InfoTrafficTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ZS_Traffic_entity *entity = [self.trafficData objectAtIndex:indexPath.row];
    cell.cellTime.text = [NSString stringWithFormat:@"%@-%@",entity.TrafficStartTime,entity.TrafficEndTime];
    cell.cellTitle.text = entity.TrafficName;
    cell.cellContent.text = entity.TrafficDetail;
    NSArray *array = [entity.TrafficDetail componentsSeparatedByString:@"-"];
    if(array.count > 1)
    [cell setTrafficStart:[array objectAtIndex:0] withEnd:[array lastObject]];

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(trafficdelegate && [trafficdelegate respondsToSelector:@selector(cellDidSelected:withType:)])
    {
        [trafficdelegate cellDidSelected:indexPath.row withType:self.type];
    }
    
}

#pragma mark - callBack
- (void)callBackToUI:(HttpBaseResponse *)response
{
    switch (response.cc_cmd_code)
    {
        case CC_GET_BUSS_INFO_MORE:
        case CC_GET_TOURISCAR_INFO_MORE:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                if(lastDataCount == self.trafficData.count)
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
        default:
            break;
    }
    
}
-(void)dealloc
{
    [[NetFileLoadManager sharedInstanced] cancelRequest:self];
    [[TrafficManager sharedInstance] cancelRequest:self];
    SAFERELEASE(loadingView)
    trafficdelegate = nil;
    [super dealloc];
}
@end
