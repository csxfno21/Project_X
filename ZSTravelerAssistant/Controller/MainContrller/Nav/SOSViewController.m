//
//  SOSViewController.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-7.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "SOSViewController.h"
#import "UIViewController+ProgressSheet.h"
#import "TTSPlayer.h"
#define CELLHIGHT 50.0f

@interface SOSViewController ()

@end

@implementation SOSViewController
//@synthesize mTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        dictionary = [[NSDictionary alloc]initWithObjects:
                      @[
                      @[[Language stringWithName:TOURIST_BE_INJURED],
                      [Language stringWithName:GOODS_BE_STOLEN],
                      [Language stringWithName:DISPUTE],
                      [Language stringWithName:RELATIVES_AND_FRIENDS_LOST],
                      [Language stringWithName:TOURIST_SINK],
                      [Language stringWithName:OTHER_CONDITION]],
                      @[[Language stringWithName:SCENIC_ZONE_PHONE_ONE],
                        [Language stringWithName:SCENIC_ZONE_PHONE_TWO]]
                      ]
                    forKeys:
                      @[[Language stringWithName:ONEKEY_ALARM]
                      ,[Language stringWithName:EMERGENCY_CALL]]];
        self.titileArray = [NSArray arrayWithObjects:[Language stringWithName:TOURIST_BE_INJURED],[Language stringWithName:GOODS_BE_STOLEN],[Language stringWithName:DISPUTE],[Language stringWithName:RELATIVES_AND_FRIENDS_LOST],[Language stringWithName:TOURIST_SINK],[Language stringWithName:OTHER_CONDITION], nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _backLabel.text = [Language stringWithName:BACK];
    _topTitleLabel.text = [Language stringWithName:SEEK_HELP];
    [[TeamManager sharedInstanced] registerTeamManagerNotification:self];
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 40.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)]autorelease];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
    if(section == 0)
    {
        title.text = [Language stringWithName:ONEKEY_ALARM];
    }
    else if(section == 1)
    {
        title.text = [Language stringWithName:EMERGENCY_CALL];
    }
    title.backgroundColor = [UIColor clearColor];
    title.font = [UIFont boldSystemFontOfSize:15.0f];
    [view addSubview:title];
    [title autorelease];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dictionary.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHIGHT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = @"";
    if(section == 0)
    {
        key = [Language stringWithName:ONEKEY_ALARM];
    }
    else if(section == 1)
    {
        key = [Language stringWithName:EMERGENCY_CALL];
    }
    int number = [(NSArray*)[dictionary objectForKey:key] count];
    return number;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        CGFloat xWidth = self.view.bounds.size.width - 15.0f;
        CGFloat yHeight = 150.0f;
        CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
        SOSPopView *popView = [SOSPopView instanceSOSPopView];
        popView.frame = CGRectMake(15, yOffset, xWidth, yHeight);
        popView.mGoodsStolenLabel.text = [self.titileArray objectAtIndex:indexPath.row];
        popView.tag = indexPath.row;
        popView.delegate = self;
        [popView show];
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SOSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[SOSTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.tag = indexPath.row;
    
    NSString *key = @"";
    if(indexPath.section == 0)
    {
        key = [Language stringWithName:ONEKEY_ALARM];
        cell.alarmLabel.text = [Language stringWithName:ONEKEY_ALARM];
        cell.phoneNumLabel.hidden = YES;
    }
    else if(indexPath.section == 1)
    {
        key = [Language stringWithName:EMERGENCY_CALL];
        if (indexPath.row == 0)
        {
            cell.phoneNumLabel.text = [Language stringWithName:PHONE_NUMBER_1];
        }
        else if(indexPath.row == 1)
        {
            cell.phoneNumLabel.text = [Language stringWithName:PHONE_NUMBER_2];
        }
    }
    NSArray *array = (NSArray*)[dictionary objectForKey:key];
    cell.contentLabel.text = [array objectAtIndex:indexPath.row];
    
    if(indexPath.section == 0)
    {
        cell.celldelegate = nil;
        cell.imgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"SOSImg%d",indexPath.row+1]];
    }
    else if(indexPath.section == 1)
    {
        cell.celldelegate = self;
        cell.imgView.image = [UIImage imageNamed:@"SOSImg7"];
    }
    
    return cell;
}
#pragma mark- sostableview delegate
- (void)sOSCellAction:(int)index
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language stringWithName:CALL_TEL] message:index == 0 ? [Language stringWithName:PHONE_NUMBER_1] : [Language stringWithName:PHONE_NUMBER_2] delegate:self cancelButtonTitle:[Language stringWithName:STR_NO] otherButtonTitles:[Language stringWithName:STR_YES], nil];
    alert.delegate = self;
    alert.tag = index;
    [alert show];
    SAFERELEASE(alert)
}
#pragma mark- sospopdelegate
-(void)sosPopAction:(int)index
{
    [self startCenterAndNonBlockBusyViewWithTitle:@"请稍等..." needUserInteraction:NO];
    CLLocationCoordinate2D location = [MapManager sharedInstanced].oldLocation2D;
    ALARM_TYPE type = -1;
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatterSys = [[[NSDateFormatter alloc] init] autorelease];
    [dateformatterSys setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *sysTime = [dateformatterSys stringFromDate:senddate];
    switch (index)
    {
        case 0:
        {
            type = ALARM_TYPE_INJURED;
            break;
        }
        case 1:
        {
            type = ALARM_TYPE_STOLEN;
            break;
        }
        case 2:
        {
            type = ALARM_TYPE_DISPUTE;
            break;
        }
        case 3:
        {
            type = ALARM_TYPE_DISMISS;
            break;
        }
        case 4:
        {
            type = ALARM_TYPE_SINK;
            break;
        }
        case 5:
        {
            type = ALARM_TYPE_OTHERS;
            break;
        }
        default:
            break;
    }
    [[TeamManager sharedInstanced] teamRequestSendEmergency:location toType:type withTime:sysTime];
}

#pragma mark - alertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        if(alertView.tag == 0)[PublicUtils actionForTel:[Language stringWithName:PHONE_NUMBER_1]];
        else if(alertView.tag == 1)[PublicUtils actionForTel:[Language stringWithName:PHONE_NUMBER_2]];
    }
}

-(void)receivedEmergencyAction
{
    [self stopCenterAndNonBlockBusyViewWithTitle];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[Language stringWithName:ALERT] message:[Language stringWithName:ALERTSUCCESS] delegate:nil cancelButtonTitle:[Language stringWithName:CONFIRM] otherButtonTitles:nil, nil];
    [alertView show];
    SAFERELEASE(alertView)
}
-(void)receiveRequestFailed
{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[TeamManager sharedInstanced] unRegisterTeamMapManagerNotification:self];
    SAFERELEASE(dictionary)
    SAFERELEASE(titleArray)
    [_topImgView release];
    [_topTitleLabel release];
    [_backBtn release];
    [_backLabel release];
    [_mTableView release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setTopImgView:nil];
    [self setTopTitleLabel:nil];
    [self setBackBtn:nil];
    [self setBackLabel:nil];
    [self setMTableView:nil];
    [super viewDidUnload];
}
@end
