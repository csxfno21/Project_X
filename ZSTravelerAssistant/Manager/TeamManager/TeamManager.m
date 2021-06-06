
//  TeamManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-10-27.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "TeamManager.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"
#import "OpenUDID.h"
#import "Config.h"


#define  TEAM_TIME_OUT          10
#define  DESKEY                 @"ABCDEFGHIJKLMNOPjameking"

#define MESSAGE_DATA_KEY_GROUP   @"MESSAGE_DATA_KEY_GROUP"
#define MESSAGE_DATA_KEY_SINGLE  @"MESSAGE_DATA_KEY_SINGLE"
static TeamManager *manager;
@interface TeamManager(Private)

@end
@implementation TeamManager
 
- (id)init
{
    if(self = [super init])
    {
        teamManagerNotifications = [[NSMutableArray alloc] init];
        [self connectSocketServer];
        
        teamList = [[NSMutableArray alloc] init];
        
        messageData = [[NSMutableDictionary alloc] init];
        [messageData setObject:[[[NSMutableDictionary alloc] init] autorelease] forKey:MESSAGE_DATA_KEY_GROUP];
        [messageData setObject:[[[NSMutableDictionary alloc] init] autorelease] forKey:MESSAGE_DATA_KEY_SINGLE];
        //读数据库
        [self loadHistoryMessage];
    }
    return self;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (manager == nil)
        {
            manager = [super allocWithZone:zone];
            return manager;
        }
    }
    return nil;
}

//类调用函数,释放团队管理者来释放长连接 ;此函数非必要不要调用.
+(void)freeInstance
{
    SAFERELEASE(manager)
}
// 返回 manager对象指针
+(TeamManager *)sharedInstanced
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[TeamManager alloc] init];
        }
    }
    return manager;
}

#pragma mark ********************* 内部 SOCKET 开始*******************************
- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    //物理连接后 
    _isConnected = YES;
    _isConnecting = NO;
    //连接成功
    NSLog(@"socket connect success");
    //连接成功后 等待接收数据 保持长连接
    [sock readDataWithTimeout:-1 tag:0];
    
   [self teamRequestLogin:[OpenUDID value] withPwd:SOCKTE_LOGIN_PSW];
}

// 接收 服务端 返回数据
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF16BigEndianStringEncoding];
    [self classificationInfo:msg];
    SAFERELEASE(msg)
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//    [alert show];
//    SAFERELEASE(alert)
    //接收到数据后 继续等待接收数据 保持长连接
    [sock readDataWithTimeout:-1 tag:tag];
}

// 套接字 断开前
- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    //判断错误原因  断开连接  超时等
    if(err == nil)return;
    if(err.code == E_SOCKETERR_TIMEOUT)
    {
        //超时
        //判断是 登录超时
        if(sock.isConnected)
        {
            //接口请求超时
        }
        else
        {
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if(delegate && [delegate respondsToSelector:@selector(receivedConnectError:)])
                {
                    [delegate receivedConnectError:E_SOCKETERR_TIMEOUT];
                }
            }
        }
    }
    else
    {
        if(sock.isConnected)
        {
            //接口请求其它错误
            
        }
        else
        {
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if(delegate && [delegate respondsToSelector:@selector(receivedConnectError:)])
                {
                    [delegate receivedConnectError:err.code];
                }
            }
        }
    }
}
// 套接字 断开
- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    if(!socketClient.isConnected)//如果是套接字断开了 自动连接
    {
        _isConnecting = NO;
        _isConnected = NO;
        if (!fromUserDisConnect)
        {
            //自动连接 ,判断当前 的错误原因 ，如是网络错误，等待网络重新连接再次连接
            NetworkStatus netWorkStatus = [PublicUtils getNetState];
            if(netWorkStatus == kNotReachable)//当前网络错误，等待网络重新连接
            {
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netConnect:) name:NOTIFY_NETCONNECT object:nil];
                return;
            }
            else
            {
                [self connectSocketServer];
            }

        }
    }
}

-(void) encrypAndSendMsg:(NSString*)strMsg
{
    strMsg = [self encryptUseDES:strMsg];       //加密后的数据
    strMsg = [NSString stringWithFormat:@"[length=%d]%@",[strMsg length],strMsg];       //添加长度信息
    NSData * msgData = [strMsg dataUsingEncoding:NSUTF16BigEndianStringEncoding];
    
    if(socketClient && socketClient.isConnected)
    {
        [socketClient writeData:msgData withTimeout:TEAM_TIME_OUT tag:0];
    }
    else
    {
        [self connectSocketServer];
    }
}
- (void)encrypAndSendMsg:(NSString*)strMsg withTag:(long)tag
{
    strMsg = [self encryptUseDES:strMsg];       //加密后的数据
    strMsg = [NSString stringWithFormat:@"[length=%d]%@",[strMsg length],strMsg];       //添加长度信息
    NSData * msgData = [strMsg dataUsingEncoding:NSUTF16BigEndianStringEncoding];
    
    if(socketClient && socketClient.isConnected)
    {
        [socketClient writeData:msgData withTimeout:TEAM_TIME_OUT tag:tag];
    }
    else
    {
        [self connectSocketServer];
    }
}

#pragma mark - 读取历史聊天
- (void)loadHistoryMessage
{
    NSArray * historyMessage = [[DataAccessManager sharedDataModel] quaryAllGroupChat];//历史群消息
    NSMutableDictionary *groupMessages = [messageData objectForKey:MESSAGE_DATA_KEY_GROUP];
    for (ZS_TeamGroupChat_entity *entity in historyMessage)
    {
        NSMutableArray *array = [groupMessages objectForKey:entity.TeamID];
        if(array == nil)
        {
            NSMutableArray * messages = [[NSMutableArray alloc] init];
            [messages addObject:entity];
            [groupMessages setObject:messages forKey:entity.TeamID];
            SAFERELEASE(messages)
        }
        else
        {
           [array addObject:entity]; 
        }
    }
    
    NSArray *historySingelMessage = [[DataAccessManager sharedDataModel] quaryAllSingleChat];//历史单对单聊天
    NSMutableDictionary *singleMessages = [messageData objectForKey:MESSAGE_DATA_KEY_SINGLE];
    for (ZS_TeamSingleChat_entity *entity in historySingelMessage)
    {
        NSString *key= @"";
        NSMutableArray *array = nil;
        if([@"-1" isEqualToString:entity.ReceiveID])
        {
            key = entity.SenderID;
        }
        else
        {
            key = entity.ReceiveID;
        }
        array = [singleMessages objectForKey:key];
        if(array == nil)
        {
            NSMutableArray * messages = [[NSMutableArray alloc] init];
            [messages addObject:entity];
            [singleMessages setObject:messages forKey:key];
            SAFERELEASE(messages)
        }
        else
        {
            [array addObject:entity];
        }
    }
}

#pragma mark - 登录  userName:登录名   pwd:登录密码
- (void)teamRequestLogin:(NSString*)userName withPwd:(NSString*)pwd
{
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",REQUEST_HEAD_ANYONE_T0_SERVER,STRSPLITER,FC_USERLOGIN,STRSPLITER,userName,STRSPLITER,pwd];
    [self encrypAndSendMsg:strRequest];
    
}
#pragma mark -  登出
- (void)teamRequestLogout
{
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_USERLOGOUT];
    [self encrypAndSendMsg:strRequest];
}

// 对消息进行分类
-(void)classificationInfo:(NSString*)msg
{
    if(msg == nil)return;
    NSString *message = [msg retain];
    NSString *desMsg = @"";
    int fromIndex = [message rangeOfString:@"]"].location+1;
    if(message.length <= fromIndex)
    {
        NSLog(@"______Socket recive msg is wrong,the message is %@",msg);
        for(int i = 0;i<teamManagerNotifications.count;i++)
        {
            id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
            if(delegate && [delegate respondsToSelector:@selector(receiveRequestFailed)])
            {
                [delegate receiveRequestFailed];
            }
        }
        SAFERELEASE(message)
        return;
    }
    desMsg = [message substringFromIndex:fromIndex];       //去除[length=..]
    desMsg = [desMsg stringByReplacingOccurrencesOfString:@"%" withString:@""];     //去除%%%%
    desMsg = [self decryptUseDES:desMsg];     //解密信息
    NSArray* msgArray = [desMsg componentsSeparatedByString:STRSPLITER];
    SAFERELEASE(message)
    if (!ISARRYCLASS(msgArray) || msgArray.count < 1)
    {
        NSLog(@"______Socket recive msg is wrong,the message is %@",msg);
        for(int i = 0;i<teamManagerNotifications.count;i++)
        {
            id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
            if(delegate && [delegate respondsToSelector:@selector(receiveRequestFailed)])
            {
                [delegate receiveRequestFailed];
            }
        }
        SAFERELEASE(message)
        return;
    }
    NSString* functionCode = ReplaceNULL2Empty([PublicUtils StringArry:msgArray atIndex:1]);
    switch ([functionCode intValue])
    {
        case FC_RECEIVE_RECEIVEALARMHANDLE:   // 已接警提示（已有工作人员处理）
            
            break;
        case FC_RECEIVE_SENDSTUFFPOSITION:   // 接警工作人员目前位置
        {
            
            break;
        }
        case FC_RECEIVE_SENDANNOUNCEMENT:   // 发布景区公告
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if(delegate && [delegate respondsToSelector:@selector(receivedMsgFromScenic:withTime:)])
                {
                    [delegate receivedMsgFromScenic:[PublicUtils StringArry:msgArray atIndex:2] withTime:[PublicUtils StringArry:msgArray atIndex:3]];
                }
            }
            break;
        case FC_RECEIVE_SENDMSGTOUSER:   // 指定用户发送
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if(delegate && [delegate respondsToSelector:@selector(receivedMsgFromTeammat:withContent:withTime:)])
                {
                    [delegate receivedMsgFromTeammat:[PublicUtils StringArry:msgArray atIndex:2] withContent:[PublicUtils StringArry:msgArray atIndex:3] withTime:[PublicUtils StringArry:msgArray atIndex:4]];
                }
            }
            break;
        case FC_RECEIVE_RECEIVEALARMUNHANDLE:   // 已接警提示（暂未有工作人员处理）
        {
            for (int i = 0; i<teamManagerNotifications.count; i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if (delegate && [delegate respondsToSelector:@selector(receivedEmergencyAction)])
                {
                    [delegate receivedEmergencyAction];
                }
            }
            break;
        }
        case FC_RECEIVE_NOTIFYRESUCEED:   // 通知救援完成
            
            break;
        case FC_RECEIVE_ALARMFAILED :   // 接收求救请求失败信息
            
            break;
        case FC_RECEIVE_SENDMEMBERINFOS:   // 接收队伍内成员资料
        {
            NSMutableArray *arryTeammatInfo = [[[NSMutableArray alloc] init] autorelease];     //团队成员资料
            [teamList removeAllObjects];
            for (int i = 2; i < msgArray.count;i++)        //构造团队成员资料
            {
                TeamMatesInfo_entity *entity = [[TeamMatesInfo_entity alloc] init];
                entity.ID = [PublicUtils StringArry:msgArray atIndex:i];
                entity.nickName = [PublicUtils StringArry:msgArray atIndex:++i];
                entity.sex = [PublicUtils StringArry:msgArray atIndex:++i];
                entity.longitude = [PublicUtils StringArry:msgArray atIndex:++i];
                entity.latitude = [PublicUtils StringArry:msgArray atIndex:++i];
                entity.state = [PublicUtils StringArry:msgArray atIndex:++i];
                
                [arryTeammatInfo addObject:entity];
                SAFERELEASE(entity)
            }
            [teamList addObjectsFromArray:arryTeammatInfo];
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if(delegate && [delegate respondsToSelector:@selector(receiveTeammatInfo:)])
                {
                    [delegate receiveTeammatInfo:teamList];
                }
            }
            
        }
            break;
        case FC_RECEIVE_SENDCREATETEAMRESULT:   // 接收新建团队结果
        {
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                NSString *errorCode = ReplaceNULL2Empty([PublicUtils StringArry:msgArray atIndex:2]);
                if(delegate && [delegate respondsToSelector:@selector(receivedCreateTeamResult:)])
                {
                    [delegate receivedCreateTeamResult:errorCode];
                }
                if ([errorCode intValue] == REQUEST_TEAMLIST_TYPE_REFRESH)
                {
                    _isJoinTeam = YES;
                }
            }
            break;
        }
        #pragma mark -  接收加入团队结果
        case FC_RECEIVE_SENDADDTOTEAMRESULT:
        {
            if ([PublicUtils StringArry:msgArray atIndex:2])
            {
                NSMutableArray *arryTeammatInfo = [[[NSMutableArray alloc] init] autorelease];     //团队成员资料
                [teamList removeAllObjects];
                // TODO  设置 当前 加入的团队
                SAFERELEASE(_currentTeamEntity)
                _currentTeamEntity = [[TeamList_entity alloc] init];
                _currentTeamEntity.teamID = [PublicUtils StringArry:msgArray atIndex:3];
                _currentTeamEntity.teamName = [PublicUtils StringArry:msgArray atIndex:4];
                _currentTeamEntity.teamCreator = [PublicUtils StringArry:msgArray atIndex:5];
                
                for (int i = 6; i < msgArray.count;i++)        //构造团队成员资料
                {
                    TeamMatesInfo_entity *entity = [[TeamMatesInfo_entity alloc] init];
                    entity.ID = [PublicUtils StringArry:msgArray atIndex:i];
                    entity.nickName = [PublicUtils StringArry:msgArray atIndex:++i];
                    entity.sex = [PublicUtils StringArry:msgArray atIndex:++i];
                    entity.longitude = [PublicUtils StringArry:msgArray atIndex:++i];
                    entity.latitude = [PublicUtils StringArry:msgArray atIndex:++i];
                    entity.state = [PublicUtils StringArry:msgArray atIndex:++i];
                    if([@"-1" isEqualToString:entity.ID])
                    {
                        [Config setTeamSelfName:entity.nickName];
                        [Config setTeamSelfSex:entity.sex];
                        [Config setTeamSelfWhere:entity.where];
                        SAFERELEASE(entity)
                        continue;
                    }
                    [arryTeammatInfo addObject:entity];
                    SAFERELEASE(entity)
                }
                [teamList addObjectsFromArray:arryTeammatInfo];
                NSString *errorCode = ReplaceNULL2Empty([PublicUtils StringArry:msgArray atIndex:2]);
                for(int i = 0;i<teamManagerNotifications.count;i++)
                {
                    id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                    if(delegate && [delegate respondsToSelector:@selector(receivedJoinToTeamResult:withList:)])
                    {
                        [delegate receivedJoinToTeamResult:errorCode withList:teamList];
                    }
                }
                if ([errorCode intValue] == CREATETEAM_ERRORCODE_OK)
                {
                    _isJoinTeam = YES;
                }
                
            }
            else
            {
                for(int i = 0;i<teamManagerNotifications.count;i++)
                {
                    id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                    if(delegate && [delegate respondsToSelector:@selector(receiveRequestFailed)])
                    {
                        [delegate receiveRequestFailed];
                    }
                }
            }
            break;
        }
        case FC_RECEIVE_MODIFIINFORESULT:       //修改个人资料后推送消息
            {
                if ([[PublicUtils StringArry:msgArray atIndex:2] intValue] == REQUEST_ERRORCODE_OK)
                {
                    for(int i = 0;i<teamManagerNotifications.count;i++)
                    {
                        id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                        if(delegate && [delegate respondsToSelector:@selector(receiveModifiInfo:sex:where:)])
                        {
                            [delegate receiveModifiInfo:[PublicUtils StringArry:msgArray atIndex:3] sex:[PublicUtils StringArry:msgArray atIndex:4] where:[PublicUtils StringArry:msgArray atIndex:5]];
                        }
                    }
                }
            break;
        }
        #pragma mark -  接收团队内消息
        case FC_RECEIVE_SENDTEAMMSG:   
        {
        
            NSString *user = [PublicUtils StringArry:msgArray atIndex:3];
            NSString *msg = [PublicUtils StringArry:msgArray atIndex:4];
            NSString *time = [PublicUtils StringArry:msgArray atIndex:5];
            REQUEST_SENDMSG_TYPE sendMsgType = [[PublicUtils StringArry:msgArray atIndex:2] intValue];
            if (sendMsgType == REQUEST_SENDMSG_SIMGLE) //单聊
            {
                NSMutableDictionary *messageDic = [messageData objectForKey:MESSAGE_DATA_KEY_SINGLE];
                NSMutableArray *messages = [messageDic objectForKey:user];

                ZS_TeamSingleChat_entity *message = [[ZS_TeamSingleChat_entity alloc] init];
                message.messageState = MESSAGE_STATE_SUCCESS;
                message.TeamID = _currentTeamEntity.teamID;
                message.SenderID = user;
                message.ChatContent = msg;
                message.ChatTime = time;
                message.ReceiveID = @"-1";
                message.ReceiveName = [Config getTeamSelfName];
                if(messages != nil)
                {
                    [messages addObject:message];
                }
                else
                {
                    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
                    [array addObject:message];
                    [messageDic setObject:array forKey:user];
                }
                // 存数据库
                [[DataAccessManager sharedDataModel] updateSingleChat:@[message]];
                SAFERELEASE(message)
            }
            else if(sendMsgType == REQUEST_SENDMSG_GROUP)
            {
                NSMutableDictionary *messageDic = [messageData objectForKey:MESSAGE_DATA_KEY_GROUP];
                NSMutableArray *messages = [messageDic objectForKey:_currentTeamEntity.teamID];
                ZS_TeamGroupChat_entity *message = [[ZS_TeamGroupChat_entity alloc] init];
                TeamMatesInfo_entity *mateInfo = [self getTeamMaterInfo:user];
                NSString *nickName = user;
                if(mateInfo!=nil)
                {
                    nickName = mateInfo.nickName;
                }
                message.messageState = MESSAGE_STATE_SUCCESS;
                message.TeamID = _currentTeamEntity.teamID;
                message.SenderID = user;
                message.SenderName = nickName;
                message.ChatContent = msg;
                message.ChatTime = time;
                if(messages != nil)
                {
                    [messages addObject:message];
                }
                else
                {
                    NSMutableArray *array = [[[NSMutableArray alloc] init] autorelease];
                    [array addObject:message];
                    [messageDic setObject:array forKey:_currentTeamEntity.teamID];
                }
                // 存数据库
                [[DataAccessManager sharedDataModel] updateGroupChat:@[message]];
                SAFERELEASE(message)
            }
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if ([[PublicUtils StringArry:msgArray atIndex:2] intValue] == REQUEST_SENDMSG_SIMGLE) //单聊
                {
                    if(delegate && [delegate respondsToSelector:@selector(receivedMsgFromTeammat:withContent:withTime:)])
                    {
                      [delegate receivedMsgFromTeammat:user withContent:msg withTime:time];
                    }
                }
                else if ([[PublicUtils StringArry:msgArray atIndex:2] intValue] == REQUEST_SENDMSG_GROUP)   //群聊
                {
                    if(delegate && [delegate respondsToSelector:@selector(receivedMsgFromTeam:withContent:withTime:)])
                    {
                        [delegate receivedMsgFromTeam:user withContent:msg withTime:time];
                    }
                }
                else
                {
                    NSLog(@"_______error! 接收团队内消息错误，不知道消息的类型！！");
                }
            }
            break;
        }
            
        case FC_RECEIVE_QUITTEAMVISITORINFO:   // 接收队友退出团队消息
            {
                NSString *userID = ReplaceNULL2Empty([PublicUtils StringArry:msgArray atIndex:2]);
//                NSString *teamID = [PublicUtils StringArry:msgArray atIndex:3];
                
                int removeIndex = -1;
                for (int index = 0; index < teamList.count;index++)
                {
                    TeamMatesInfo_entity *entity = [teamList objectAtIndex:index];
                    if([userID isEqualToString:entity.ID])
                    {
                        removeIndex = index;
                        break;
                    }
                }
                if(removeIndex != -1)[teamList removeObjectAtIndex:removeIndex];
                for(int i = 0;i<teamManagerNotifications.count;i++)
                {
                    id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                    
                    if(delegate && [delegate respondsToSelector:@selector(receiveRefreshTeamListInfo)])
                    {
                        
                        [delegate receiveRefreshTeamListInfo];
                    }
                }
                break;
            }
            
        case FC_RECEIVE_QUITTEAMRESULT:     // 主动退出团队结果
            {
                NSString* isSussess = [PublicUtils StringArry:msgArray atIndex:2];
                if ([isSussess intValue] == REQUEST_ERRORCODE_OK)
                {
                    _isJoinTeam = NO;
                }
                for(int i = 0;i<teamManagerNotifications.count;i++)
                {
                    id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                    
                    if(delegate && [delegate respondsToSelector:@selector(receiveQuitTeamResult:)])
                    {
                        [delegate receiveQuitTeamResult:isSussess];
                    }
                }
                break;
            }
        case FC_RECEIVE_DISMISTEAMRESULT :   // 接收解散团队消息
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if(delegate && [delegate respondsToSelector:@selector(receiveDismisTeamResult:)])
                {
                    [delegate receiveDismisTeamResult:[PublicUtils StringArry:msgArray atIndex:2]];
                }
                break;
            }
        #pragma mark -  接收团队列表
        case FC_RECEIVE_FINDTEAMLIST: 
        {
            NSMutableArray *arryTeam = [[[NSMutableArray alloc] init] autorelease];     //团队列表
            NSString *isSussess = [PublicUtils StringArry:msgArray atIndex:2];
            if ([isSussess intValue] == REQUEST_ERRORCODE_FAIL) //获取失败
            {
                NSLog(@"接收团队列表失败");
                return;
            }
            else
            {
                for (int i = 3; i < msgArray.count;i++)//构造团队列表
                {
                    TeamList_entity *entity = [[[TeamList_entity alloc] init] autorelease];
                    entity.teamID = [PublicUtils StringArry:msgArray atIndex:i];
                    entity.teamName = [PublicUtils StringArry:msgArray atIndex:++i];
                    entity.teamCreator = [PublicUtils StringArry:msgArray atIndex:++i];
                    entity.onLineaPCount = [PublicUtils StringArry:msgArray atIndex:++i];
                    entity.teamCounts = [PublicUtils StringArry:msgArray atIndex:++i];
                    [arryTeam addObject:entity];
                }
                for(int i = 0;i<teamManagerNotifications.count;i++)
                {
                    id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                    if(delegate && [delegate respondsToSelector:@selector(receiveTeamList:)])
                    {
                        [delegate receiveTeamList:arryTeam];
                    }
                }
            }
             break;
        }
        #pragma mark -  推送团队团员的位置信息
        case FC_RECEIVE_SENDTEAMPOSITION:   
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if(delegate && [delegate respondsToSelector:@selector(receiveTeammatePosition:lon:lat:)])
                {
                    [delegate receiveTeammatePosition:[PublicUtils StringArry:msgArray atIndex:2] lon:[PublicUtils StringArry:msgArray atIndex:3] lat:[PublicUtils StringArry:msgArray atIndex:4]];
                }
                break;
            }
        #pragma mark -  推送队友状态
        case FC_RECEIVE_SENDTEAMINFO: 
        {
            NSMutableArray *arryTeammatInfo = [[[NSMutableArray alloc] init] autorelease];     //团队成员资料
//            [teamList removeAllObjects];
            for (int i = 2; i < msgArray.count;i++)        //构造团队成员资料
            {
                TeamMatesInfo_entity *entity = [[TeamMatesInfo_entity alloc] init];
                entity.ID = [PublicUtils StringArry:msgArray atIndex:i];
                entity.state = [PublicUtils StringArry:msgArray atIndex:++i];
                entity.nickName = [PublicUtils StringArry:msgArray atIndex:++i];
                entity.sex = [PublicUtils StringArry:msgArray atIndex:++i];
                entity.where = [PublicUtils StringArry:msgArray atIndex:++i];
                [arryTeammatInfo addObject:entity];
                SAFERELEASE(entity)
            }
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if(delegate && [delegate respondsToSelector:@selector(receiveTeammatesStatus:)])
                {
                    [delegate receiveTeammatesStatus:arryTeammatInfo];
                }
            }
        }
            break;
        case FC_RECEIVE_FAILDREFRESHMSG:   // 主动刷新信息失败
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if(delegate && [delegate respondsToSelector:@selector(receiveTeamList:)])
                {
                    [delegate receiveRefreshInfoStatus:[PublicUtils StringArry:msgArray atIndex:2]];
                }
            }
            break;
        case FC_RECEIVE_FAILDSENDTEAMMSG:   // 主动发送单人&&团队消息是否失败
            {
                NSString *errorCode = [PublicUtils StringArry:msgArray atIndex:2];
                NSString *type = [PublicUtils StringArry:msgArray atIndex:3];
                NSString *toWhoID = [PublicUtils StringArry:msgArray atIndex:4];
                long tag = [[PublicUtils StringArry:msgArray atIndex:5] longLongValue];
                if (tag == 0)
                {
                    NSLog(@"error！接收单人&&团队消息失败，tag为空！");
                    return;
                }
                if(ReplaceNULL2Empty(type).intValue == 0)//单发
                {
                    int count = tag - SC_SINGEL_MESSAGE;
                    NSDictionary *messageDic = [messageData objectForKey:MESSAGE_DATA_KEY_SINGLE];
                    NSMutableArray *msgList = [messageDic objectForKey:toWhoID];
                    if(msgList.count < --count)
                    {
                        NSLog(@"FC_RECEIVE_FAILDSENDTEAMMSG Error index out of bound! %d  %d",count ,msgList.count);
                        return;
                    }
                    ZS_TeamSingleChat_entity *message = [msgList objectAtIndex:count];
                    if(ReplaceNULL2Empty(errorCode).intValue == REQUEST_ERRORCODE_OK)       //发送消息成功
                    {
                        message.messageState = MESSAGE_STATE_SUCCESS;
                        
                        // 存数据库
                        [[DataAccessManager sharedDataModel] updateSingleChat:@[message]];
                    }else
                    {
                        message.messageState = MESSAGE_STATE_FAILED;        //发送消息失败
                    }
                    for(int i = 0;i<teamManagerNotifications.count;i++)
                    {
                        id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                        if(delegate && [delegate respondsToSelector:@selector(receiveSendSingleMsgStatus:msgIndex:)])
                        {
                            [delegate receiveSendSingleMsgStatus:toWhoID msgIndex:count];
                        }
                    }
                }
                else if(ReplaceNULL2Empty(type).intValue == 1)//群发
                {
                    int count = tag - SC_GROUP_MESSAGE;
                    NSDictionary *messageDic = [messageData objectForKey:MESSAGE_DATA_KEY_GROUP];
                    NSMutableArray *msgList = [messageDic objectForKey:_currentTeamEntity.teamID];
                    if(msgList.count < --count)
                    {
                        NSLog(@"FC_RECEIVE_FAILDSENDTEAMMSG Error index out of bound! %d  %d",count ,msgList.count);
                        return;
                    }
                    ZS_TeamGroupChat_entity *message = [msgList objectAtIndex:count];
                    if(ReplaceNULL2Empty(errorCode).intValue == 0)
                    {
                        message.messageState = MESSAGE_STATE_SUCCESS;
                        // 存数据库
                        [[DataAccessManager sharedDataModel] updateGroupChat:@[message]];
                    }else
                    {
                        message.messageState = MESSAGE_STATE_FAILED;        //发送消息失败
                    }
                    for(int i = 0;i<teamManagerNotifications.count;i++)
                    {
                        id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                        if(delegate && [delegate respondsToSelector:@selector(receiveSendGroupMsgStatus:msgIndex:)])
                        {
                            [delegate receiveSendGroupMsgStatus:toWhoID msgIndex:count];
                        }
                    }
                }
                break;
            }
        case FC_RECEIVE_NEWTEAMMAT:     //新增团队成员
            {
                TeamMatesInfo_entity *entity = [[TeamMatesInfo_entity alloc] init];
                entity.ID = [PublicUtils StringArry:msgArray atIndex:2];
                entity.nickName = [PublicUtils StringArry:msgArray atIndex:3];
                entity.sex = [PublicUtils StringArry:msgArray atIndex:4];
                entity.longitude = [PublicUtils StringArry:msgArray atIndex:5];
                entity.latitude = [PublicUtils StringArry:msgArray atIndex:6];
                entity.state = [PublicUtils StringArry:msgArray atIndex:7];
                if(entity.ID.intValue == -1)return;
                int sameInfoIndex = -1;
                for (int i = 0; i < teamList.count; i++)     //查看新增队员是否在已有队员列表里
                {
                    if ([entity.ID isEqualToString:((TeamMatesInfo_entity*)[teamList objectAtIndex:i]).ID])
                    {
                        sameInfoIndex = i;
                    }
                }
                if (sameInfoIndex == -1)        //没有重复信息
                {
                    [teamList addObject:entity];
                }
                else        //有重复信息
                {
                    TeamMatesInfo_entity * replaceEntity = [teamList objectAtIndex:sameInfoIndex];
                    replaceEntity.ID = entity.ID;
                    replaceEntity.nickName = entity.nickName;
                    replaceEntity.sex = entity.sex;
                    replaceEntity.longitude = entity.longitude;
                    replaceEntity.latitude = entity.latitude;
                    replaceEntity.state = entity.state;
                }
                
                for(int i = 0;i<teamManagerNotifications.count;i++)
                {
                    id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                    if(delegate && [delegate respondsToSelector:@selector(receiveRefreshTeamListInfo)])
                    {
                        [delegate receiveRefreshTeamListInfo];
                    }
                }
            }
            break;
        case FC_RECEIVE_HEARTCLIENT:   // 心跳检测结果
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if(delegate && [delegate respondsToSelector:@selector(receiveTeamList:)])
                {
                    [delegate receiveHeartTestMsg:[PublicUtils StringArry:msgArray atIndex:2]];
                }
            }
            break;
        case FC_RECEIVE_VERIFICATIONFROMSERVER:     // 服务器验证结果
            for(int i = 0;i<teamManagerNotifications.count;i++)
            {
                id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
                if(delegate && [delegate respondsToSelector:@selector(receiveLoginResult:)])
                {
                    [delegate receiveLoginResult:[PublicUtils StringArry:msgArray atIndex:2]];
                }
            }
            break;
        default:
            break;
    }
}

#pragma mark ********************* 内部 SOCKET 结束*******************************



#pragma mark ********************* 外部 调用 接口 开始*******************************

#pragma mark - 获取人员资料
- (TeamMatesInfo_entity*)getTeamMaterInfo:(NSString*)userID
{
    if (userID == nil)
    {
        return nil;
    }
    for(TeamMatesInfo_entity *entity in teamList)
    {
        if([ReplaceNULL2Empty(userID) isEqualToString:entity.ID])return entity;
    }
    return nil;
}

#pragma mark - 获取 聊天 纪录
- (NSArray*)getMessageData:(TeamUser *)user
{
    if(!user)
    return nil;
    switch (user.userType)
    {
        case TEAM_USER_RECEIVE://单聊的消息
        {
            NSDictionary *singleDic = [messageData objectForKey:MESSAGE_DATA_KEY_SINGLE];
            if(ISDICTIONARYCLASS(singleDic))
            {
                return [singleDic objectForKey:user.userID];
            }
            break;
        }
        case TEAM_USER_TEAM://群聊的消息
        {
            NSDictionary *groupDic = [messageData objectForKey:MESSAGE_DATA_KEY_GROUP];
            if(ISDICTIONARYCLASS(groupDic))
            {
                return [groupDic objectForKey:user.userID];
            }
            break;
        }
        default:
            break;
    }
    return nil;
}
#pragma mark - 获取 团队列表
- (NSMutableArray *)getTeamList
{
    return teamList;
}
#pragma mark - 连接 套接字 注意:正常情况下不要主动去连接，manager 会主动连接 
- (void)connectSocketServer
{
    if(_isConnecting)return;
    if(!socketClient)socketClient = [[AsyncSocket alloc]initWithDelegate:self];
    if(!socketClient.isConnected)
    {
        NSError *error = nil;
        _isConnecting = YES;
        [socketClient connectToHost:TEAM_HOST onPort:TEAM_PORT withTimeout:TEAM_TIME_OUT error:&error];
    }
}

#pragma mark -  断开套接字 注意:正常情况下不要主动断开, 正常断开后会自动连接,主动断开后 需要手动连接
- (void)disConnectSocketServer
{
    if(socketClient && socketClient.isConnected)
    {
        fromUserDisConnect = YES;
        [socketClient disconnect];
        _isConnecting = NO;
    }
}


// 修改个人信息
- (void)teamRequestModifyInfo:(NSString*) alis withSex:(NSString*)sex withWhere:(NSString*) where
{
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_MODIFYUSERINFO,STRSPLITER,alis,STRSPLITER,sex,STRSPLITER,where];
    [self encrypAndSendMsg:strRequest];
}
#pragma mark - 创建团队
- (void)teamrequestCreateTeam:(NSString*)teamName withPsw:(NSString*) teamPsw
{
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_CRATETEAM,STRSPLITER,teamName,STRSPLITER,teamPsw];
    [self encrypAndSendMsg:strRequest];
}
#pragma mark - 加入团队
- (void)teamRequestAddToTeam:(NSString*) teamName withPsw:(NSString*) teamPsw
{
    if(_isJoinTeam)return;
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_ADDTOTEAM,STRSPLITER,teamName,STRSPLITER,teamPsw];
    [self encrypAndSendMsg:strRequest];
}
#pragma mark - 发文本消息  msg:发送的消息  who:发给谁
- (void)teamRequestSendMessage:(NSString*)msg toWho:(id)who
{
    ZS_TeamSingleChat_entity *message = [[ZS_TeamSingleChat_entity alloc] init];
    
    NSMutableDictionary *messagesDic = [messageData objectForKey:MESSAGE_DATA_KEY_SINGLE];
    //找到 这个人的消息记录，如果没有 则添加
    TeamUser *whoUser = who;
    
    message.messageState = MESSAGE_STATE_SENDDING;//设置为等待状态
    message.TeamID = _currentTeamEntity.teamID;
    message.SenderID = @"-1";
    message.ChatContent = msg;
    message.ChatTime = [PublicUtils currentDetatilTime];
    message.ReceiveID = whoUser.userID;
    message.ReceiveName = whoUser.userName;
    NSMutableArray *array = [messagesDic objectForKey:whoUser.userID];
    int index = 1;
    if(array != nil)
    {
        [array addObject:message];
        index = array.count;
    }
    else
    {
        NSMutableArray *messages = [[[NSMutableArray alloc] init] autorelease];
        [messages addObject:message];
        [messagesDic setObject:messages forKey:whoUser.userID];
    }
    SAFERELEASE(message)
    
    for(int i = 0;i<teamManagerNotifications.count;i++)
    {
        id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
        if(delegate && [delegate respondsToSelector:@selector(receiveSendSingleMsgStatus:msgIndex:)])
        {
            [delegate receiveSendSingleMsgStatus:whoUser.userID msgIndex:index - 1];
        }
    }
    
    long tag = SC_SINGEL_MESSAGE + index;

    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%ld",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_SENDMSGTOTEAM,STRSPLITER,whoUser.userID,STRSPLITER,msg,STRSPLITER,tag];

    [self encrypAndSendMsg:strRequest];
}
#pragma mark -  发送群组消息 msg 发送到群组的消息
- (void)teamRequestSendGroupMessage:(NSString*)msg
{
    ZS_TeamGroupChat_entity *message = [[ZS_TeamGroupChat_entity alloc] init];
    NSMutableDictionary *messagesDic = [messageData objectForKey:MESSAGE_DATA_KEY_GROUP];
    message.TeamID = _currentTeamEntity.teamID;
    message.SenderID = @"-1";
    message.ChatContent = msg;
    message.ChatTime = [PublicUtils currentDetatilTime];
    message.messageState = MESSAGE_STATE_SENDDING;
    NSMutableArray *array = [messagesDic objectForKey:_currentTeamEntity.teamID];
    int index = 1;
    if(array != nil)
    {
        [array addObject:message];
        index = array.count;
    }
    else
    {
        NSMutableArray *messages = [[[NSMutableArray alloc] init] autorelease];
        [messages addObject:message];
        [messagesDic setObject:messages forKey:_currentTeamEntity.teamID];
    }
    
    SAFERELEASE(message)
    
    for(int i = 0;i<teamManagerNotifications.count;i++)
    {
        id<TeamManagerDelegate> delegate = (id)[[teamManagerNotifications objectAtIndex:i] longValue];
        if(delegate && [delegate respondsToSelector:@selector(receiveSendGroupMsgStatus:msgIndex:)])
        {
            [delegate receiveSendGroupMsgStatus:@"-1" msgIndex:index - 1];
        }
    }
    long tag = SC_GROUP_MESSAGE + index;
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@%@%@%ld",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_SENDMSGTOGROUP,STRSPLITER,msg,STRSPLITER,tag];

    [self encrypAndSendMsg:strRequest];
}
#pragma mark -  发送报警消息到信息中心 location:报警的内容 (看接口) type:报警的类别
- (void)teamRequestSendEmergency:(CLLocationCoordinate2D)location toType:(int)type withTime:(NSString *)time
{
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@%f%@%f%@%d%@%@",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_USERASKHELP,STRSPLITER,location.longitude,STRSPLITER,location.latitude,STRSPLITER,type,STRSPLITER,time];
    [self encrypAndSendMsg:strRequest];
}
#pragma mark - 获取当前所有的在线团队
- (void)teamRequestQueryOnLineTeam
{
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_VISITORONLINETEAN];
    [self encrypAndSendMsg:strRequest];
}
#pragma mark - 获取数据库中游客团队
- (void)teamRequestQueryAllTeam:(REQUEST_TEAMLIST_TYPE)type lastID:(int)id
{
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@%d%@%d",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_VISITORTEAM,STRSPLITER,type,STRSPLITER,id];
    [self encrypAndSendMsg:strRequest];
}
#pragma mark- 游客请求退出团队
-(void)teamRequestQuitTeam
{
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_QUITETEAM];
    [self encrypAndSendMsg:strRequest];
}

//#pragma mark - 主动刷新 队友的状态
//- (void)teamRequestRefreshMemberState
//{
//    NSString *strRequest = [NSString stringWithFormat:@"%@%@%d",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_RECEIVE_SENDTEAMINFO];
//    [self encrypAndSendMsg:strRequest];
//}
#pragma mark - 获取当前团队的所有团员
- (void)teamRequestTeamMembers
{
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_REQUESTTEAMMEMBER];
    [self encrypAndSendMsg:strRequest];
}
#pragma mark - 游客位置上传
-(void)teamRequestLocation:(CLLocationCoordinate2D)location withSpeed:(double)speed withAltitude:(double)altitude withTime:(NSString *)time
{
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%f%@%f%@%f%@%f%@%@",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,location.longitude,STRSPLITER,location.latitude,STRSPLITER,speed,STRSPLITER,altitude,STRSPLITER,time];
    [self encrypAndSendMsg:strRequest];
}

#pragma mark - 上传头像
- (void)teamRequestPushHeadIcon:(id)icon
{
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@%@",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_UPVISITORPORTRAIT,STRSPLITER,icon];
    [self encrypAndSendMsg:strRequest];
}
#pragma mark -  下载头像
- (void)teamRequestDownloadHeadIcon:(id)request
{
    NSString *strRequest = [NSString stringWithFormat:@"%@%@%@%@%@",REQUEST_HEAD_VISITER_TO_SERVER,STRSPLITER,FC_SEND_DOWNVISITORPORTRAIT,STRSPLITER,request];
    [self encrypAndSendMsg:strRequest];
}

- (void)registerTeamManagerNotification:(id<TeamManagerDelegate>)delegate
{
    if(delegate)
    {
        NSNumber *number = POINT2NUMBER(delegate);
        if (![teamManagerNotifications containsObject:number])
        {
            [teamManagerNotifications addObject:number];
        }
        
    }
}
- (void)unRegisterTeamMapManagerNotification:(id<TeamManagerDelegate>)delegate
{
    if(delegate)
    {
        NSNumber *number = POINT2NUMBER(delegate);
        [teamManagerNotifications removeObject:number];
    }
}
//阻止外部错误修改计数
- (id)retain
{
    return self;
}
//阻止外面错误释放
- (id)autorelease
{
    return self;
}
#pragma mark ********************* 外部 调用 接口 结束*******************************

/******************************************************************************
 函数名称  : encryptUseDES
 函数描述  : DES加密
 输入参数  : clearText 要加密的数据
 输出参数  : N/A
 返回值    : 返回加密后的数据
 备注     : 梁谢超
 ******************************************************************************/
#pragma mark -DES加密
-(NSString *) encryptUseDES:(NSString *)clearText
{
    NSString *ciphertext = nil;
    NSData *textData = [clearText dataUsingEncoding:NSUTF16StringEncoding];
    NSUInteger dataLength = [clearText length];
    dataLength = [textData length];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x12, 0x34, 0x56, 0x78};
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithm3DES,
                                          kCCOptionPKCS7Padding,
                                          [DESKEY UTF8String], kCCKeySize3DES,
                                          iv,
                                          [textData bytes]  , dataLength,
                                          buffer, 1024,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) NSLog(@"SUCCESS");
    else if (cryptStatus == kCCParamError) NSLog(@"PARAM ERROR");
    else if (cryptStatus == kCCBufferTooSmall) NSLog (@"BUFFER TOO SMALL");
    else if (cryptStatus == kCCMemoryFailure) NSLog (@"MEMORY FAILURE");
    else if (cryptStatus == kCCAlignmentError) NSLog (@"ALIGNMENT");
    else if (cryptStatus == kCCDecodeError) NSLog (@"DECODE ERROR");
    else if (cryptStatus == kCCUnimplemented) NSLog (@"UNIMPLEMENTED");
    if (cryptStatus == kCCSuccess)
    {
        NSLog(@"DES加密成功");
        NSData *data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        ciphertext = [GTMBase64 stringByEncodingData:data];
    }
    else{
        NSLog(@"DES加密失败");
    }
    return ciphertext;
}
/******************************************************************************
 函数名称  : decryptUseDES
 函数描述  : DES解密
 输入参数  : plainText 要解密的数据
 输出参数  : N/A
 返回值    : 返回解密后的数据
 备注     : 梁谢超
 ******************************************************************************/
#pragma mark -DES解密
-(NSString *) decryptUseDES:(NSString *)plainText
{
    NSString *cleartext = nil;
    NSData *textData = [GTMBase64 decodeString:plainText];
    NSUInteger dataLength = [textData length];
    unsigned char buffer[1024 * 10];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x12, 0x34, 0x56, 0x78};
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithm3DES,
                                          kCCOptionPKCS7Padding,
                                          [DESKEY UTF8String], kCCKeySize3DES,
                                          iv,
                                          [textData bytes]  , dataLength,
                                          buffer, 1024 * 10,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) NSLog(@"SUCCESS");
    else if (cryptStatus == kCCParamError) NSLog(@"PARAM ERROR");
    else if (cryptStatus == kCCBufferTooSmall) NSLog (@"BUFFER TOO SMALL");
    else if (cryptStatus == kCCMemoryFailure) NSLog (@"MEMORY FAILURE");
    else if (cryptStatus == kCCAlignmentError) NSLog (@"ALIGNMENT");
    else if (cryptStatus == kCCDecodeError) NSLog (@"DECODE ERROR");
    else if (cryptStatus == kCCUnimplemented) NSLog (@"UNIMPLEMENTED");
    if (cryptStatus == kCCSuccess)
    {
        NSLog(@"DES解密成功");
        cleartext = [[NSString alloc] initWithBytes:buffer length:numBytesEncrypted encoding:NSUTF16StringEncoding];
    }
    else{
        NSLog(@"DES解密失败 the string is %@",plainText);
    }
    return cleartext;
}

// 网络重新连接后 自动连接
- (void)netConnect:(id)sender
{
    [self connectSocketServer];
}
-(void)dealloc
{
    SAFERELEASE(_currentTeamEntity)
    SAFERELEASE(teamList)
    SAFERELEASE(messageData)
    _isConnected = NO;
    if(socketClient.isConnected)
    {
        [socketClient disconnect];
    }
    SAFERELEASE(socketClient)
    SAFERELEASE(teamManagerNotifications)
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_NETCONNECT object:nil];
    [super dealloc];
}
@end
