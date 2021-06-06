//
//  ChatDetailViewController.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-10-30.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "ChatDetailViewController.h"
#import "TTSPlayer.h"
#import "TeamManager.h"
#import "Config.h"
@interface ChatDetailViewController ()

@end

@implementation ChatDetailViewController

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
    
    m_bottomView.delegate = self;
    m_chatTableView.separatorStyle =UITableViewCellSeparatorStyleNone;//去掉cell边框线
    m_chatTableView.backgroundColor = [UIColor clearColor];
	m_chatTableView.separatorColor = [UIColor clearColor];
    m_chatTableView.delegate = self;
    m_chatTableView.dataSource = self;
    m_chatTableView.showsVerticalScrollIndicator = NO;
    m_chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if(self.receive && self.receive)
    {
        _Title.text = self.receive.userName;
    }
    else
    {
        _Title.text = self.receive.userName;
    }
    
    [[TeamManager sharedInstanced] registerTeamManagerNotification:self];
    m_bottomView.delegate = self;
    
    if(self.receive)
    {
      messageData = [[TeamManager sharedInstanced] getMessageData:self.receive];
    }
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*********************************************************************
 函数名称 : setToDisplayEmotionView
 函数描述 : 显示表情视图
 参数 N/A
 返回值 N/A
 作者 : csxfno21
 *********************************************************************/
- (void)setToDisplayEmotionViewCallBack
{
	[self setToDisplayEmotionViewInCtl];
}

- (void)setToDisplayEmotionViewInCtl
{
	m_bottomView.m_EmotionShowFlag = YES;
	m_bottomView.m_KeyBoardShowFlag = NO;
    [m_bottomView.m_chatTextView resignFirstResponder];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    NSInteger height = 105  + m_bottomView.m_chatTextView.frame.size.height + 10;
    if(iPhone5)
    {
        m_bottomView.frame = CGRectMake(0, 415 - height + 88, 320, m_bottomView.frame.size.height);
        m_bottomView.m_dismissButton.frame = CGRectMake(0, 44, 320, self.view.frame.size.height - 44 - m_bottomView.m_ChatImageView.frame.size.height - m_bottomView.frame.size.height);

        m_bottomView.m_ChatImageView.frame = CGRectMake(0.0f, 320 + 88, 320.0f, 140);
        m_chatTableView.frame = CGRectMake(0.0f, 44.0f, 320, self.view.frame.size.height - 44 - m_bottomView.m_ChatImageView.frame.size.height - m_bottomView.frame.size.height);
    }
    else
    {
        m_bottomView.frame = CGRectMake(0, 415 - height, 320, m_bottomView.frame.size.height);
        m_bottomView.m_dismissButton.frame = CGRectMake(0, 44, 320, self.view.frame.size.height - 44 - m_bottomView.m_ChatImageView.frame.size.height - 26 - m_bottomView.m_chatTextView.frame.size.height);
        m_bottomView.m_ChatImageView.frame = CGRectMake(0.0f, 320, 320.0f, 140);
        m_chatTableView.frame = CGRectMake(0.0f, 44.0f, 320, self.view.frame.size.height - 44 - m_bottomView.m_ChatImageView.frame.size.height - 26 - m_bottomView.m_chatTextView.frame.size.height);
    }
    [self.view addSubview:m_bottomView.m_ChatImageView];
    [self.view addSubview:m_bottomView.m_dismissButton];
    
	[UIView commitAnimations];
    
    [m_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageData.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}
/*********************************************************************
 函数名称 : setToDissmissEmotionView
 函数描述 : 隐藏表情视图
 参数 N/A
 返回值 N/A
 作者 : csxfno21
 *********************************************************************/
- (void)setToDissmissEmotionViewCallBack
{
    [self.view sendSubviewToBack:m_chatTableView];
	m_bottomView.m_KeyBoardShowFlag = NO;
	m_bottomView.m_EmotionShowFlag = NO;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    float changeH = m_bottomView.frame.size.height - 60;
    // 加上 放大的高度
    if (iPhone5)
    {
        m_bottomView.frame = CGRectMake(0, 400+88 - changeH, 320, m_bottomView.frame.size.height);
        m_bottomView.m_ChatImageView.frame = CGRectMake(0, 480 + 88, 320, 105);
        m_bottomView.m_dismissButton.frame = CGRectMake(0, 480 + 88, 320, 0);
        m_chatTableView.frame = CGRectMake(0.0, 44.0f, 320, self.view.frame.size.height - 44 - m_bottomView.frame.size.height);
    }
    else
    {
        m_bottomView.frame = CGRectMake(0, 400 - changeH , 320, m_bottomView.frame.size.height);
        m_bottomView.m_ChatImageView.frame = CGRectMake(0, 480, 320, 105);
        m_bottomView.m_dismissButton.frame = CGRectMake(0, 480, 320, 0);
        m_chatTableView.frame = CGRectMake(0.0, 44.0f, 320, self.view.frame.size.height - 44 - m_bottomView.frame.size.height);
    }

	[m_bottomView.m_chatTextView resignFirstResponder];
	
	[UIView commitAnimations];
}


-(void)textViewChanged:(float)height
{
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    if(m_bottomView.m_dismissButton.superview == self.view)[m_bottomView.m_dismissButton removeFromSuperview];
    [self.view addSubview:m_bottomView.m_dismissButton];
    
	if(m_bottomView.m_KeyBoardShowFlag)
    {
        //键盘 抬起
//        NSInteger height = m_bottomView.frame.origin.y;
        m_bottomView.m_dismissButton.frame = CGRectMake(0, 44, 320, m_bottomView.m_dismissButton.frame.size.height - height);
        if(iPhone5)
        {
            m_bottomView.m_ChatImageView.frame = CGRectMake(0, 480 + 88, 320, 105);
        }
        else
        {
            m_bottomView.m_ChatImageView.frame = CGRectMake(0, 480, 320, 105);
        }
        m_chatTableView.frame = CGRectMake(0.0f, 44.0f, 320, m_chatTableView.frame.size.height - height);
    }
    else if (m_bottomView.m_EmotionShowFlag)
    {
        //表情符号
        m_bottomView.m_dismissButton.frame = CGRectMake(0, 44, 320, m_bottomView.m_dismissButton.frame.size.height - height);
        m_chatTableView.frame = CGRectMake(0.0f, 44.0f, 320, m_chatTableView.frame.size.height - height);
    }
    [UIView commitAnimations];
}
- (void)keyboardWillShowCallBack:(float)height
{
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	if(m_bottomView.m_dismissButton.superview == self.view)[m_bottomView.m_dismissButton removeFromSuperview];
	[self.view addSubview:m_bottomView.m_dismissButton];

    NSInteger h = self.view.frame.size.height - height - m_bottomView.frame.size.height - 44;
    m_bottomView.m_dismissButton.frame = CGRectMake(0, 44, 320, h);
    if (iPhone5)
    {
        m_bottomView.m_ChatImageView.frame = CGRectMake(0, 480 + 88, 320, 105);
    }
    else
    {
        m_bottomView.m_ChatImageView.frame = CGRectMake(0, 480, 320, 105);
    }
    m_bottomView.frame = CGRectMake(0.0f, h+44,320, 26 + m_bottomView.m_chatTextView.frame.size.height);
    m_bottomView.m_bottomImage.frame = CGRectMake(0, 0, 320, m_bottomView.frame.size.height);
    
    m_chatTableView.frame = CGRectMake(0.0f, 44.0f, 320, h);
	[UIView commitAnimations];
    if (messageData != nil && messageData.count > 0)
    {
        [m_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageData.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }

    
}
#pragma mark - 发送消息
- (void)sendMessage:(NSString *)msgContent
{
    //TODO send request
    if(self.receive && self.receive.userType == TEAM_USER_TEAM)//接收者 为团队
    {
        [[TeamManager sharedInstanced] teamRequestSendGroupMessage:msgContent];
    }
    else if(self.receive && self.receive.userType == TEAM_USER_RECEIVE)//接收者 为个人
    {
        [[TeamManager sharedInstanced] teamRequestSendMessage:msgContent toWho:self.receive];
    }
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    float changeH = m_bottomView.m_chatTextView.frame.size.height - 34;
    m_bottomView.m_chatTextView.text = @"";
    m_bottomView.m_chatTextView.frame = CGRectMake(m_bottomView.m_chatTextView.frame.origin.x, m_bottomView.m_chatTextView.frame.origin.y,
                                                   m_bottomView.m_chatTextView.frame.size.width, 34);
    m_bottomView.m_sendButton.frame = CGRectMake(244, 12, 64, 34);
    m_bottomView.m_expressionButton.frame = CGRectMake(6, 15, 30, 30);
    m_bottomView.frame = CGRectMake(0, m_bottomView.frame.origin.y + changeH, 320, m_bottomView.frame.size.height - changeH);
    m_bottomView.m_dismissButton.frame = CGRectMake(0, 44, 320, m_bottomView.m_dismissButton.frame.size.height + changeH);
    m_chatTableView.frame = m_bottomView.m_dismissButton.frame;
    [UIView commitAnimations];
}

#pragma mark- tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messageData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *mySelfDdentifier = @"MySelfcell";
    static NSString *otherIdentifier = @"Othercell";
    
    OthersChatCell *othersChatCell = [tableView dequeueReusableCellWithIdentifier:otherIdentifier];
    if (othersChatCell == nil)
    {
        othersChatCell = [[[OthersChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherIdentifier] autorelease];
        othersChatCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [othersChatCell setHeadImage:@"topbar-bg.png"];
    }
    
    MyselfChatCell *mySelfChatcell = [tableView dequeueReusableCellWithIdentifier:mySelfDdentifier];
    if (mySelfChatcell == nil)
    {
        mySelfChatcell = [[[MyselfChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mySelfDdentifier] autorelease];
        mySelfChatcell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *sex = [Config getTeamSelfSex];
        if([@"0" isEqualToString:sex])
        {
            [mySelfChatcell setHeadImage:@"team-sex-boy.png"];
        }
        else if ([@"1" isEqualToString:sex])
        {
            [mySelfChatcell setHeadImage:@"team-sex-girl.png"];
        }
    }
    UITableViewCell *returnCell = nil;
    
    TEAM_USER_TYPE userType =  self.receive.userType;
    id data = [messageData objectAtIndex:indexPath.row];;
    if(userType == TEAM_USER_TEAM)
    {
        ZS_TeamGroupChat_entity *entity = data;
        if([@"-1" isEqualToString:entity.SenderID])
        {
            [mySelfChatcell setChatContentText:entity.ChatContent];
            switch (entity.messageState)
            {
                case MESSAGE_STATE_SUCCESS:
                {
                    [mySelfChatcell.refreshSpinner stopAnimating];
                    mySelfChatcell.warningBtn.hidden = YES;
                    break;
                }
                case MESSAGE_STATE_FAILED:
                {
                    [mySelfChatcell.refreshSpinner stopAnimating];
                    mySelfChatcell.warningBtn.hidden = NO;
                    break;
                }
                case MESSAGE_STATE_SENDDING:
                {
                    [mySelfChatcell.refreshSpinner startAnimating];
                    mySelfChatcell.warningBtn.hidden = YES;
                    break;
                }
                default:
                    break;
            }
            returnCell = mySelfChatcell;
        }
        else
        {
            othersChatCell.isSingleChat = NO;
            [othersChatCell setChatContentText:entity.ChatContent];
            [othersChatCell setChatPeopleText:entity.SenderName];
            returnCell = othersChatCell;
            TeamMatesInfo_entity *mateInfo = [[TeamManager sharedInstanced] getTeamMaterInfo:entity.SenderID];
            if([@"0" isEqualToString:mateInfo.sex])
            {
                [othersChatCell setHeadImage:@"team-sex-boy.png"];
            }
            else if ([@"1" isEqualToString:mateInfo.sex])
            {
                [othersChatCell setHeadImage:@"team-sex-girl.png"];
            }
        }
    }
    else if(userType == TEAM_USER_RECEIVE)
    {
        ZS_TeamSingleChat_entity *entity = data;
        if([@"-1" isEqualToString:entity.SenderID])
        {
//            [mySelfChatcell setChatContentText:entity.ChatContent];
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(32.603, 120.506);
            [mySelfChatcell setChatContentImageWithPoint:location];
            switch (entity.messageState)
            {
                case MESSAGE_STATE_SUCCESS:
                {
                    [mySelfChatcell.refreshSpinner stopAnimating];
                    mySelfChatcell.warningBtn.hidden = YES;
                    break;
                }
                case MESSAGE_STATE_FAILED:
                {
                    [mySelfChatcell.refreshSpinner stopAnimating];
                    mySelfChatcell.warningBtn.hidden = NO;
                    break;
                }
                case MESSAGE_STATE_SENDDING:
                {
                    [mySelfChatcell.refreshSpinner startAnimating];
                    mySelfChatcell.warningBtn.hidden = YES;
                    break;
                }
                default:
                    break;
            }

            returnCell = mySelfChatcell;
        }
        else
        {
            othersChatCell.isSingleChat = YES;
            [othersChatCell setChatContentText:entity.ChatContent];
            returnCell = othersChatCell;
            TeamMatesInfo_entity *mateInfo = [[TeamManager sharedInstanced] getTeamMaterInfo:entity.SenderID];
            if([@"0" isEqualToString:mateInfo.sex])
            {
                [othersChatCell setHeadImage:@"team-sex-boy.png"];
            }
            else if ([@"1" isEqualToString:mateInfo.sex])
            {
                [othersChatCell setHeadImage:@"team-sex-girl.png"];
            }
        }
    }
    returnCell.tag = indexPath.row;
    return returnCell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = @"";
    TEAM_USER_TYPE userType =  self.receive.userType;
    id data = [messageData objectAtIndex:indexPath.row];;
    if(userType == TEAM_USER_TEAM)
    {
        ZS_TeamGroupChat_entity *entity = data;
        str = entity.ChatContent;
    }
    else if(userType == TEAM_USER_RECEIVE)
    {
        ZS_TeamSingleChat_entity *entity = data;
        str = entity.ChatContent;
    }
    return [HTEmotionView sizeWithMessage:str].height + 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)] autorelease];
    UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, 320, 15)];
    tmpLabel.backgroundColor = [UIColor whiteColor];
    tmpLabel.font = [UIFont systemFontOfSize:12.0f];
    tmpLabel.textAlignment = NSTextAlignmentCenter;
    tmpLabel.backgroundColor = [UIColor clearColor];
    tmpLabel.textColor = [UIColor lightGrayColor];
    self.showTimeView = tmpLabel;
    NSDate *senddate = [NSDate date];
    [self setShowTimeText:senddate];
    [view addSubview:tmpLabel];
    view.backgroundColor = [UIColor whiteColor];
    SAFERELEASE(tmpLabel)

    m_chatTableView.tableHeaderView = view;
    return m_chatTableView.tableHeaderView;
}
-(void)setShowTimeText:(NSDate *)time
{
    //根据字符串获取时间  并与当前时间比较   -----刚刚  1分钟前  5分钟前
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatterSys = [[[NSDateFormatter alloc] init] autorelease];
    [dateformatterSys setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *sysString = [dateformatterSys stringFromDate:senddate];
    
    NSDateFormatter *dateformatterTime = [[[NSDateFormatter alloc] init] autorelease];
    [dateformatterTime setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSString *timeString = [dateformatterTime stringFromDate:time];
    
    //UI显示的时间格式
    NSDateFormatter *dateformatrerShowTime = [[[NSDateFormatter alloc] init] autorelease];
    [dateformatrerShowTime setDateFormat:@"HH:mm"];
    NSString *showTime = [dateformatrerShowTime stringFromDate:time];
    
    //截取前14位--HH
    NSString *subSysString = [sysString substringToIndex:14];
    NSString *subTimeString = [timeString substringToIndex:14];
    //截取 14-15字符串  取分钟进行比较
    NSString *subSysmmString = [sysString substringWithRange:NSMakeRange(14, 2)];
    NSString *subTimemmString = [timeString substringWithRange:NSMakeRange(14, 2)];
    int subSysmm = [subSysmmString intValue];
    int subTimemm = [subTimemmString intValue];
    
    if (![subSysString isEqualToString:subTimeString])
    {
        return;
    }
    else if (subSysmm - subTimemm <= 1)
    {
        self.showTimeView.text = @"刚刚";
    }
    else if (subSysmm - subTimemm >1 && subSysmm - subTimemm <= 5)
    {
        self.showTimeView.text = @"1分钟前";
    }
    else if(subSysmm - subTimemm > 5 && subSysmm - subTimemm < 10)
    {
        self.showTimeView.text = @"5分钟前";
    }
    else
    {
        self.showTimeView.text = showTime;
    }  
}

// 主动发送
- (void)receiveSendSingleMsgStatus:(NSString *)toWhoID msgIndex:(int)index
{
    // 单聊
    if(self.receive.userType == TEAM_USER_RECEIVE)
    {
        if(!messageData)
         messageData = [[TeamManager sharedInstanced] getMessageData:self.receive];
        [m_chatTableView reloadData];
        [m_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageData.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}
// 主动发送
- (void)receiveSendGroupMsgStatus:(NSString *)groupID msgIndex:(int)index
{
    // 群聊
    if(self.receive.userType == TEAM_USER_TEAM)
    {
        if(!messageData)
            messageData = [[TeamManager sharedInstanced] getMessageData:self.receive];
        [m_chatTableView reloadData];
        [m_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageData.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    }
}

// 接收 队友
- (void)receivedMsgFromTeammat:(NSString *)deviceID withContent:(NSString *)content withTime:(NSString *)time
{
    if(!messageData)
        messageData = [[TeamManager sharedInstanced] getMessageData:self.receive];
    [m_chatTableView reloadData];
    [m_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageData.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

// 接收 团队
- (void)receivedMsgFromTeam:(NSString *)deviceID withContent:(NSString *)content withTime:(NSString *)time
{
    if(!messageData)
        messageData = [[TeamManager sharedInstanced] getMessageData:self.receive];
    [m_chatTableView reloadData];
    [m_chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:messageData.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
}
//请求失败
- (void)receiveRequestFailed
{
    
}
//定位自己
-(void)location
{
    
}
//重新发送消息
-(void)reSendMessage:(NSString *)emotionString
{
    
}
//定位队友
-(void)othersLocation
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[TeamManager sharedInstanced] unRegisterTeamMapManagerNotification:self];
    [_Title release];
    [m_bottomView release];
    [m_chatTableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [_Title release];
    _Title = nil;
    [m_bottomView release];
    m_bottomView = nil;
    [m_chatTableView release];
    m_chatTableView = nil;
    [super viewDidUnload];
}
@end
