//
//  TeamServiceViewController.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-12.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "TeamServiceViewController.h"
#import "TeamManager.h"
#import "ChatDetailViewController.h"
#import "TTSPlayer.h"
#import "UIViewController+ProgressSheet.h"

//#import "<#header#>"
#define CELLHEIGHT 100
#define CELLHIGHTSHOW 140
#define HEADERHEIGHT 30


@interface TeamServiceViewController ()

@end

@implementation TeamServiceViewController
@synthesize data, filteredListContent, savedSearchTerm, searchWasActive,savedScopeButtonIndex;
//@synthesize savedScopeButtonIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
//        stretchableImageWithLeftCapWidth
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    selectIndex = -1;
    
    self.filteredListContent = [NSMutableArray array];
    
    gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismisskeyBoard:)];
    gesture.numberOfTapsRequired = 1;
    gesture.delegate = self;
    [self.view addGestureRecognizer:gesture];
    
    [self.createTeamBtn setBackgroundImage:[[UIImage imageNamed:@"Route-nav-pop-item-f.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.createTeamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.joinTeamBtn setBackgroundImage:[[UIImage imageNamed:@"Route-nav-pop-item-f.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.joinTeamBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    [self.view sendSubviewToBack:self.mScrollerView];
    if (iPhone5)
    {
        self.teamServiceImgView.frame = CGRectMake(110, 70, 100, 100);
    }
    self.mScrollerView.delegate = self;
    self.nameTextFiled.tag = 1;
    self.pwordTextFiled.tag = 2;
    
    self.nameTextFiled.frame = CGRectMake(self.nameTextFiled.frame.origin.x, self.nameTextFiled.frame.origin.y, self.nameTextFiled.frame.size.width, self.nameTextFiled.frame.size.height + 10);
    self.pwordTextFiled.frame = CGRectMake(self.pwordTextFiled.frame.origin.x, self.pwordTextFiled.frame.origin.y + 10, self.pwordTextFiled.frame.size.width, self.pwordTextFiled.frame.size.height + 10);
    self.nameTextFiled.delegate = self;
    self.pwordTextFiled.delegate = self;
    self.mTeamDisplayTableView.showsVerticalScrollIndicator = NO;
    self.mTeamDisplayTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    self.animationBtn.backgroundColor = [UIColor grayColor];
    

    
    //设置显示
    firstUIisHidden = NO;
    displayTableHidden = NO;
    currentTable = NO;
    
    self.mTeamDisplayTableView.delegate = self;
    self.mTeamDisplayTableView.dataSource = self;
    
    //searchbar
    self.searchDisplayController.delegate = self;
    self.mSearchBar.delegate = self;
    self.mSearchDisplayController.delegate = self;
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];


    [self.mRefresh setBackgroundImage:[[UIImage imageNamed:@"Route-nav-pop-item-f.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.mRefresh setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [[TeamManager sharedInstanced] registerTeamManagerNotification:self];
    
    self.nameTextFiled.text = @"szmap0123456";
    self.pwordTextFiled.text = @"111111";
}
- (IBAction)animationAction:(id)sender
{
    //隐藏第一个UI
    if (!firstUIisHidden)
    {
        self.teamServiceImgView.hidden = YES;
        self.nameTextFiled.hidden = YES;
        self.pwordTextFiled.hidden = YES;
        self.createTeamBtn.hidden = YES;
        self.joinTeamBtn.hidden = YES;
        self.teamServiceImgView.hidden = YES;
        firstUIisHidden = YES;
        [self.view removeGestureRecognizer:gesture];

        self.searchDisplayController.searchResultsTableView.hidden = NO;
        self.mSearchBar.hidden = NO;
        self.mTeamDisplayTableView.hidden = NO;
        self.mRefresh.hidden = NO;
        [[TeamManager sharedInstanced] teamRequestQueryAllTeam:REQUEST_TEAMLIST_TYPE_REFRESH lastID:0];     //刷新团队列表
    }
    //隐藏第二个UI
    else
    {
        [self.view addGestureRecognizer:gesture];
        self.teamServiceImgView.hidden = NO;
        self.nameTextFiled.hidden = NO;
        self.pwordTextFiled.hidden = NO;
        self.createTeamBtn.hidden = NO;
        self.joinTeamBtn.hidden = NO;
        self.teamServiceImgView.hidden = NO;
        self.searchDisplayController.searchResultsTableView.hidden = YES;
        self.mSearchBar.hidden = YES;
        self.mTeamDisplayTableView.hidden = YES;
        self.mRefresh.hidden = YES;
        firstUIisHidden = NO;
    }
    
//    CATransition *animation = [CATransition animation];
//    animation.duration = 1.0f;
//    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
//    animation.fillMode = kCAFillModeForwards;
//    animation.type = @"rippleEffect";//suckEffect rippleEffect pageCurl pageUnCurl oglFlip
//    animation.subtype = kCATransitionFromRight;
//    [self.view.layer addAnimation:animation forKey:@"animation"];
    [UIView beginAnimations:@"FlipToSideBySide" context:nil];
    [UIView setAnimationCurve:1.25];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1];
    if (firstUIisHidden == YES)
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    }
    else
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    }
    
    [UIView commitAnimations];
}

#pragma mark- tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return [self.filteredListContent count];
    }
    else
        return [self.data count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectIndex == indexPath.row)
    {
        return CELLHIGHTSHOW;
    }
    else
    {
        return CELLHEIGHT;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    TeamInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[[TeamInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier]autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.selected = UITableViewCellSelectionStyleBlue;
    //TODO 给cell赋值
    if (selectIndex == indexPath.row)
    {
        cell.bIsShow = YES;
    }
    else
    {
        cell.bIsShow = NO;
    }
    cell.tag = indexPath.row;
    cell.delegate = self;
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        TeamList_entity *entity = [self.filteredListContent objectAtIndex:indexPath.row];
        cell.teamNameLabel.text = entity.teamName;
        cell.teamCreatorLabel.text = [NSString stringWithFormat:@"%@ %@",[Language stringWithName:TEAM_CREATER],entity.teamCreator];
        cell.teamMatesCountLabel.text = [NSString stringWithFormat:@"%@ %@",[Language stringWithName:PEOPLECOUNT],entity.teamCounts];
        [cell.picImgView setImage:[UIImage imageNamed:@"TeamService.png"]]; 
    }
    else
    {
        cell.joinTeamBtn.tag = indexPath.row;
        TeamList_entity* entity = [self.data objectAtIndex:indexPath.row];
        cell.teamNameLabel.text = entity.teamName;
        cell.teamCreatorLabel.text = [NSString stringWithFormat:@"%@ %@",[Language stringWithName:TEAM_CREATER],entity.teamCreator];
        cell.teamMatesCountLabel.text = [NSString stringWithFormat:@"%@ %@",[Language stringWithName:PEOPLECOUNT],entity.teamCounts];
//        cell.teamCreatedTimeLabel.text = @"2013/11/8 11:20";
        [cell.picImgView setImage:[UIImage imageNamed:@"TeamService.png"]];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TeamInfoCell *cell = (TeamInfoCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (selectIndex == indexPath.row)
    {
        cell.bIsShow = !cell.bIsShow;
        if (!cell.bIsShow)
        {
            selectIndex = -1;
        }
    }
    else
    {
        if(selectIndex != -1)
        {
            TeamInfoCell *lastOpenCell = (TeamInfoCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0]];
            if(lastOpenCell.bIsShow)
            {
                lastOpenCell.bIsShow = NO;
            }
        }
        cell.bIsShow = YES;
        selectIndex = indexPath.row;
    }
    CGRect cellRect = [self.mTeamDisplayTableView rectForRowAtIndexPath:indexPath];
    if (cellRect.origin.y - self.mTeamDisplayTableView.contentOffset.y + CELLHIGHTSHOW > self.mTeamDisplayTableView.frame.size.height)
    {
    float needScrolOffset = CELLHIGHTSHOW - (self.mTeamDisplayTableView.frame.size.height - cellRect.origin.y + self.mTeamDisplayTableView.contentOffset.y);
    [self.mTeamDisplayTableView setContentOffset:CGPointMake(0, needScrolOffset + self.mTeamDisplayTableView.contentOffset.y) animated:YES];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        currentTable = NO;
        [self dismisskeyBoard:nil];
    }
    else
    {
        currentTable = YES;
    }
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return 0;
    else
        return HEADERHEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 65, 30)];
    titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    titleLabel.text = @"当前团队";
    [view addSubview:titleLabel];
    [titleLabel release];
    UILabel *countLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 0, 100, 30)];
    countLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    countLabel.text = [NSString stringWithFormat:@": %d",self.data.count];
    [view addSubview:countLabel];
    [countLabel release];
    return view;
}

- (void)dismisskeyBoard:(id)sender
{
    [self.nameTextFiled resignFirstResponder];
    [self.pwordTextFiled resignFirstResponder];
    [self.mSearchBar resignFirstResponder];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    UIView *touchView = touch.view;
    if([touchView isKindOfClass:[UIButton class]] || [touchView.superview isKindOfClass:[UITextField class]])
    {
        return NO;
    }
    return YES;
}
- (IBAction)backAction:(id)sender
{
    [self dismisskeyBoard:sender];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createAction:(id)sender
{
    if(ReplaceNULL2Empty(self.nameTextFiled.text).length == 0 || ReplaceNULL2Empty(self.pwordTextFiled.text).length == 0)
    {
        // 输入内容不能为空
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"抱歉,输入内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        SAFERELEASE(alert)
    }
    else if([PublicUtils getNetState] == NotReachable)
    {
        // 无网络
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"抱歉,当前网络不佳,请查看网络配置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        SAFERELEASE(alert)
    }
    else if(![TeamManager sharedInstanced].isConnected)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"抱歉,当前未连接上服务器,请查看网络配置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        SAFERELEASE(alert)
    }
    else
    {
        [self startCenterAndNonBlockBusyViewWithTitle:@"创建团队..." needUserInteraction:NO];
        [[TeamManager sharedInstanced] teamrequestCreateTeam:self.nameTextFiled.text withPsw:self.pwordTextFiled.text];
    }
}

- (IBAction)joinAction:(id)sender
{

    if(ReplaceNULL2Empty(self.nameTextFiled.text).length == 0 || ReplaceNULL2Empty(self.pwordTextFiled.text).length == 0)
    {
        // 输入内容不能为空
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"抱歉,输入内容不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        SAFERELEASE(alert)
    }
    else if([PublicUtils getNetState] == NotReachable)
    {
        // 无网络
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"抱歉,当前网络不佳,请查看网络配置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        SAFERELEASE(alert)
    }
    else if(![TeamManager sharedInstanced].isConnected)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"抱歉,当前未连接上服务器,请查看网络配置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        SAFERELEASE(alert)
    }
    else
    {
        [self startCenterAndNonBlockBusyViewWithTitle:@"加入团队..." needUserInteraction:NO];
        [[TeamManager sharedInstanced] teamRequestAddToTeam:self.nameTextFiled.text withPsw:self.pwordTextFiled.text];
    }
}
#pragma mark- mScrollerView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{

    
}
#pragma mark- textfield delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint newPoint = CGPointMake(0, 40);
    [self.mScrollerView setContentOffset:newPoint animated:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGPoint newPoint = CGPointMake(0, 0);
    [self.mScrollerView setContentOffset:newPoint animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == self.nameTextFiled)
    {
        [self.pwordTextFiled becomeFirstResponder];
    }
    else if(textField == self.pwordTextFiled)
    {
        [self dismisskeyBoard:nil];
    }
    return NO;
}

#pragma mark- Content Filtering
-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString*)scope
{
    [self.filteredListContent removeAllObjects];
    for (TeamList_entity *entity in data)
    {
        if ([searchText length] >0)
        {
            if ([scope hasSuffix:entity.teamName] || [entity.teamName rangeOfString:searchText].location !=NSNotFound || [scope hasSuffix:entity.teamCreator] || [entity.teamCreator rangeOfString:searchText].location != NSNotFound || [scope hasSuffix:entity.teamCounts] || [entity.teamCounts rangeOfString:searchText].location != NSNotFound)
            {
                [self.filteredListContent addObject:entity];
            }
        }
    }
}

#pragma mark- search bar and search display delegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
    [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}
#pragma mark- teamInfoCell delegate  加入团队  密码
-(void)teamInfoJoinAction:(int)index withCellTag:(int)tag
{
    TeamList_entity *entity = [[TeamList_entity alloc] init];
    //如果当前的表是self.searchDisplayController.searchResultsTableView
    if (currentTable)
    {
        entity = [self.data objectAtIndex:tag];
    }
    else //如果当前的表是self.mTeamDisplayTableView
    {
        entity = [self.filteredListContent objectAtIndex:tag];
    }
    self.nameTextFiled.text = entity.teamName;
    self.pwordTextFiled.text = @"";
    [self animationAction:nil];
}

// 接收登录验证结果
- (void)receiveLoginResult:(NSString*)result
{
    if ([result intValue] != LOGINERRORCODE_OK)     // 登录socket不成功
    {
        NSString* str = [NSString stringWithFormat:@"Login result is %@",result];
        NSLog(@"%@",str);
    }
}
// 接收新建团队结果
- (void)receivedCreateTeamResult:(NSString*)isSuccess
{
    [self stopCenterAndNonBlockBusyViewWithTitle];
    
    if ([isSuccess intValue] == CREATETEAM_ERRORCODE_FAILD)
    {
        NSString* result = @"创建团队失败";
        [[TTSPlayer shareInstance] play:result playMode:TTS_DEFAULT];
    }
    else
    {
        if ([isSuccess intValue] == CREATETEAM_ERRORCODE_HAVEREPEATTEAM)
        {
            NSString* result = @"有重复团队";
            [[TTSPlayer shareInstance] play:result playMode:TTS_DEFAULT];
        }
        else
        {
//            NSString* result = @"加入团队成功";
//            [[TTSPlayer shareInstance] play:result playMode:TTS_DEFAULT];
            TeamFriendShowViewController *friendShowViewController = [[TeamFriendShowViewController alloc]initWithNibName:@"TeamFriendShowViewController" bundle:nil];
            [self.navigationController pushViewController:friendShowViewController animated:YES];
            SAFERELEASE(friendShowViewController)
        }
    }
}
// 接收加入团队结果
-(void)receivedJoinToTeamResult:(NSString *)isSuccess withList:(NSMutableArray *)list
{
    [self stopCenterAndNonBlockBusyViewWithTitle];
    if ([isSuccess intValue] == REQUEST_ERRORCODE_FAIL)
    {
        NSString* result = @"加入团队失败";
        [[TTSPlayer shareInstance] play:result playMode:TTS_DEFAULT];
    }
    else
    {
//        NSString* result = @"加入团队成功";
//        [[TTSPlayer shareInstance] play:result playMode:TTS_DEFAULT];
        [TeamManager sharedInstanced].isJoinTeam = YES;
        
        TeamFriendShowViewController *friendShowViewController = [[TeamFriendShowViewController alloc]initWithNibName:@"TeamFriendShowViewController" bundle:nil];
        [self.navigationController pushViewController:friendShowViewController animated:YES];
        friendShowViewController.tableViewOne.data = list;
        SAFERELEASE(friendShowViewController)
    }
}
- (void)receiveTeamList:(NSMutableArray *)teamList
{
    self.data = teamList;
    [self.mTeamDisplayTableView reloadData];
    
}
- (void)receiveRequestFailed
{
    [self stopCenterAndNonBlockBusyViewWithTitle];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc
{
    [[TeamManager sharedInstanced] unRegisterTeamMapManagerNotification:self];
    SAFERELEASE(gesture)
    [_topTitleImgView release];
    [_topTitleLabel release];
    [_backBtn release];
    [_backLabel release];
    [_teamServiceImgView release];
    [_nameTextFiled release];
    [_pwordTextFiled release];
    [_createTeamBtn release];
    [_joinTeamBtn release];
    [_mScrollerView release];
    [_mTeamDisplayTableView release];
    [_mRefresh release];
    [_animationBtn release];
    [_mSearchBar release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [self setTopTitleImgView:nil];
    [self setTopTitleLabel:nil];
    [self setBackBtn:nil];
    [self setBackLabel:nil];
    [self setTeamServiceImgView:nil];
    [self setNameTextFiled:nil];
    [self setPwordTextFiled:nil];
    [self setCreateTeamBtn:nil];
    [self setJoinTeamBtn:nil];
    [self setMScrollerView:nil];
    [self setMTeamDisplayTableView:nil];
    [self setMRefresh:nil];
    [self setMSearchBar:nil];
    [super viewDidUnload];
}
@end
