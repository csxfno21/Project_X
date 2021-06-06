//
//  TeamFriendShowViewController.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-21.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "TeamFriendShowViewController.h"
#import "ChatDetailViewController.h"
#import "TTSPlayer.h"
#import "TeamManager.h"
#import "UIViewController+ProgressSheet.h"
#import "TeamServiceViewController.h"
@interface TeamFriendShowViewController ()

@end

@implementation TeamFriendShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.selfNameLabel.text = [Config getTeamSelfName];
    self.myselfSexLabel.text = [Config getTeamSelfSex];
    self.myselfLocalLabel.text = [Config getTeamSelfWhere];
    self.myselfImgView.image = [[Config getTeamSelfSex] intValue] == 0 ? [UIImage imageNamed:@"head-pic-myself-boy.png"] :[UIImage imageNamed:@"head-pic-myself.png"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[TeamManager sharedInstanced] registerTeamManagerNotification:self];
    self.view.backgroundColor = [UIColor clearColor];
    TeamFriendTableView *tmptableViewOne = [[TeamFriendTableView alloc]initWithFrame:CGRectMake(0, self.topBackgroundImgView.frame.size.height - 15, 320, [UIScreen mainScreen].bounds.size.height - self.topBackgroundImgView.frame.size.height - 32)];
    self.tableViewOne = tmptableViewOne;
    self.tableViewOne.teamDelegate = self;
    [self.view addSubview:tmptableViewOne];
    [self.view sendSubviewToBack:tmptableViewOne];
    SAFERELEASE(tmptableViewOne)
    
    TeamBottomButtonView *tmpTeamViewOne = [[TeamBottomButtonView alloc]initWithFrame:CGRectMake(0,self.tableViewOne.frame.origin.y + self.tableViewOne.frame.size.height - 17, 80, 60)];
    tmpTeamViewOne.backgroundColor = [UIColor blackColor];
    tmpTeamViewOne.tag = 1000;
    tmpTeamViewOne.btnImageView.image = [UIImage imageNamed:@"back-team.png"];
    tmpTeamViewOne.btnLabel.text = [Language stringWithName:BACK];
    self.teamBottomViewOne = tmpTeamViewOne;
    [self.view addSubview:tmpTeamViewOne];
    SAFERELEASE(tmpTeamViewOne)
    
    TeamBottomButtonView *tmpTeamViewTwo = [[TeamBottomButtonView alloc]initWithFrame:CGRectMake(80, self.tableViewOne.frame.origin.y + self.tableViewOne.frame.size.height - 17, 80, 60)];
    tmpTeamViewTwo.backgroundColor = [UIColor blackColor];
    tmpTeamViewTwo.tag = 1001;
    tmpTeamViewTwo.btnImageView.image = [UIImage imageNamed:@"mylocation-pressed.png"];
    tmpTeamViewTwo.btnLabel.text = [Language stringWithName:GATHER];
    self.teamBottomViewTwo = tmpTeamViewTwo;
    [self.view addSubview:tmpTeamViewTwo];
    SAFERELEASE(tmpTeamViewTwo)
    
    TeamBottomButtonView *tmpTeamViewThree = [[TeamBottomButtonView alloc]initWithFrame:CGRectMake(160, self.tableViewOne.frame.origin.y + self.tableViewOne.frame.size.height - 17, 80, 60)];
//    tmpTeamViewThree.btnImageView.frame = CGRectMake(10, 15, 20, 20);
//    tmpTeamViewThree.btnLabel.frame = CGRectMake(30, 10, 70, 30);
    tmpTeamViewThree.tag = 1002;
    tmpTeamViewThree.backgroundColor = [UIColor blackColor];
    tmpTeamViewThree.btnImageView.image = [UIImage imageNamed:@"sendmessage-pressed.png"];
    tmpTeamViewThree.btnLabel.text = [Language stringWithName:GROUPMESSAGE];
    self.teamBottomViewThree = tmpTeamViewThree;
    [self.view addSubview:tmpTeamViewThree];
    SAFERELEASE(tmpTeamViewThree)
    
    TeamBottomButtonView *tmpTeamViewFour = [[TeamBottomButtonView alloc]initWithFrame:CGRectMake(240, self.tableViewOne.frame.origin.y + self.tableViewOne.frame.size.height - 17, 80, 60)];
    tmpTeamViewFour.backgroundColor = [UIColor blackColor];
    tmpTeamViewFour.tag = 1003;
    tmpTeamViewFour.btnImageView.image = [UIImage imageNamed:@"quiteam-pressed.png"];
    tmpTeamViewFour.btnLabel.text = [Language stringWithName:QUITTEAM];
    self.teamBottomViewFour = tmpTeamViewFour;
    [self.view addSubview:tmpTeamViewFour];
    SAFERELEASE(tmpTeamViewFour)
    
    [self.teamBottomViewOne addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.teamBottomViewTwo addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.teamBottomViewThree addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.teamBottomViewFour addTarget:self action:@selector(goAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark- goAction --按钮事件
-(void)goAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag)
    {
        case 1000: //返回
        {
            //已经加入团队
            if ([TeamManager sharedInstanced].isJoinTeam)
            {
                int count = [self.navigationController.viewControllers count];
                NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                if(array.count > count - 2)
                {
                    UIViewController *c = [array objectAtIndex:count - 2];
                    if([c isKindOfClass:[TeamServiceViewController class]])
                    {
                        [array removeObjectAtIndex:count - 2];
                        self.navigationController.viewControllers = array;
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }
            }
            else
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
        }
        case 1001: //定位
        {
            MyNavController *controller = [[MyNavController alloc] init];
            controller.clickMapType = CLICK_MAP_GATHER;
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller)
            break;
        }
        case 1002: //群发消息
        {
            ChatDetailViewController *controller = [[ChatDetailViewController alloc] initWithNibName:@"ChatDetailViewController" bundle:nil];
            
            TeamUser *teamUser = [[[TeamUser alloc] init] autorelease];
            teamUser.userID = [TeamManager sharedInstanced].currentTeamEntity.teamID;
            teamUser.userName = [TeamManager sharedInstanced].currentTeamEntity.teamName;
            teamUser.userType = TEAM_USER_TEAM;
            controller.receive = teamUser;
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller)
            break;
        }
        case 1003: //退团
        {
            [self startCenterAndNonBlockBusyViewWithTitle:@"请稍等..." needUserInteraction:NO];
            [[TeamManager sharedInstanced] teamRequestQuitTeam];
            break;
        }
        default:
            break;
    }
}

#pragma mark- TeamFriendTableView Delegate
-(void)teamFriendItemDidSelected:(int)index withType:(TEAM_ACTION_TYPE)type withTeamUser:(TeamUser *)teamUser
{
    switch (type)
    {
        case TEAM_ACTION_TYPE_SENDMESSAGE:
        {
            ChatDetailViewController *controller = [[ChatDetailViewController alloc] initWithNibName:@"ChatDetailViewController" bundle:nil];
            controller.receive = teamUser;
            [self.navigationController pushViewController:controller animated:YES];
            SAFERELEASE(controller)
            break;
        }
        case TEAM_ACTION_TYPE_LOCATION:
        {
            //TODO  进入到定位controller
//            MyNavController *controller = [[MyNavController alloc] initWithNibName:@"MyNavController" bundle:nil];
//            TeamMatesInfo_entity *entity = [[[TeamMatesInfo_entity alloc] init] autorelease];
//            entity = [self.tableViewOne.data objectAtIndex:index];
//            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([entity.latitude doubleValue], [entity.longitude doubleValue]);
           
            
            
            
            break;
        }
        case TEAM_ACTION_TYPE_GUIDE:
        {
            //TODO  进入到引导controller
            break;
        }
        default:
            break;
    }
    
}
- (void)sendMessagePopViewAction:(int)index
{
    CGFloat xWidth = self.view.bounds.size.width - 15.0f;
    CGFloat yHeight = 150.0f;
    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    TeamSendMessagePopView *popView = [TeamSendMessagePopView instanceSendMessagePopView];
    popView.frame = CGRectMake(15, yOffset, xWidth, yHeight);
    popView.tag = index;
    popView.delegate = self;
    [popView show];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma nark - 接收团队成员资料
//- (void)receiveTeammatInfo:(NSMutableArray*)infoList
//{
//    self.tableViewOne.data = infoList;
//    
//}
- (void)receiveRequestFailed
{
    [self stopCenterAndNonBlockBusyViewWithTitle];
}
-(void)receivedMsgFromTeammat:(NSString *)name withContent:(NSString *)content withTime:(NSString *)time
{
    NSLog(@"%@%@%@",name,content,time);
}

- (void)receiveTeammatesStatus:(NSMutableArray*)infoList;
{
    for (int i = 0; i < self.tableViewOne.data.count; i++)
    {
        TeamMatesInfo_entity *tableEntity = [self.tableViewOne.data objectAtIndex:i];
        for (TeamMatesInfo_entity *entity in infoList)
        {
            if ([tableEntity.ID isEqualToString:entity.ID])
            {
                tableEntity.nickName = entity.nickName;
                tableEntity.sex = entity.sex;
                tableEntity.where = entity.where;
                tableEntity.longitude = entity.longitude;
                tableEntity.latitude = entity.latitude;
                tableEntity.state = entity.state;
            }
        }
    }
    [self.tableViewOne reloadData];
}
// 接收退团是否成功
-(void)receiveQuitTeamResult:(NSString*)isSuccess
{
    [self stopCenterAndNonBlockBusyViewWithTitle];
    if ([isSuccess intValue] == REQUEST_ERRORCODE_OK)
    {
        NSString* result = @"退团成功";
        [[TTSPlayer shareInstance] play:result playMode:TTS_DEFAULT];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSString* result = @"退出团队失败";
        [[TTSPlayer shareInstance] play:result playMode:TTS_DEFAULT];
    }
}
// 接收团队内消息
- (void)receivedMsgFromTeam:(NSString*)deviceID withContent:(NSString*)content withTime:(NSString*)time
{
    //TODO UI显示
    
    NSLog(@"%@ %@ %@",deviceID,content,time);
}
// 接收定位信息
-(void)receiveTeammatePosition:(NSString *)id lon:(NSString *)lon lat:(NSString *)lat
{
    NSLog(@"%@,%@",lon,lat);
    //TODO  UI实现显示位置信息
    
}
// 接收主动推送退团游客信息的返回值
- (void)receiveRefreshTeamListInfo
{
    [self.tableViewOne reloadData];
}

- (void)dealloc
{
    [[TeamManager sharedInstanced] unRegisterTeamMapManagerNotification:self];
    SAFERELEASE(_teamBottomViewOne)
    SAFERELEASE(_teamBottomViewTwo)
    SAFERELEASE(_teamBottomViewThree)
    SAFERELEASE(_teamBottomViewFour)
    [_tableViewOne release];
    [_topBackgroundImgView release];
    [_myselfImgView release];
    [_selfNameLabel release];
    [_myselfOnlineLabel release];
    [_myselfSexLabel release];
    [_myselfLocalLabel release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setTopBackgroundImgView:nil];
    [self setMyselfImgView:nil];
    [self setSelfNameLabel:nil];
    [self setMyselfOnlineLabel:nil];
    [self setMyselfSexLabel:nil];
    [self setMyselfLocalLabel:nil];
    [super viewDidUnload];
}
- (IBAction)onEditInfo:(id)sender
{
    TeamSaveInfoViewController* controller = [[TeamSaveInfoViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    SAFERELEASE(controller);
}
@end
