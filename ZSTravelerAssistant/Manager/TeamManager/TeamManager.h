//
//  TeamManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-10-27.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TeamManagerDelegate.h"
#import "AsyncSocket.h"
#import "TeamMatesInfo_entity.h"
#import "TeamList_entity.h"
#import "TeamUser.h"
@interface TeamManager : NSObject<TeamManagerInterface>
{
    NSMutableArray *teamManagerNotifications;
    
    AsyncSocket *socketClient;
    BOOL fromUserDisConnect;
    
    NSMutableArray *teamList;
    // 消息
    NSMutableDictionary *messageData;
}
@property(nonatomic,readonly)BOOL isConnected;
@property(nonatomic,assign)BOOL  isConnecting;
@property(nonatomic,assign)BOOL  isJoinTeam;
@property(nonatomic,readonly) TeamList_entity *currentTeamEntity;
+(TeamManager *)sharedInstanced;

- (NSString *) encryptUseDES:(NSString *)plainText;
// 注册观察者
- (void)registerTeamManagerNotification:(id<TeamManagerDelegate>)delegate;
// 注销观察者
- (void)unRegisterTeamMapManagerNotification:(id<TeamManagerDelegate>)delegate;
// 连接 套接字服务
- (void)connectSocketServer;
// 断开 套接字服务
- (void)disConnectSocketServer;

// 查看与某人/某群的消息
- (NSArray*)getMessageData:(TeamUser *)user;

//读取 团队列表
- (NSMutableArray*)getTeamList;
// 获取人员资料
- (TeamMatesInfo_entity*)getTeamMaterInfo:(NSString*)userID;
@end
