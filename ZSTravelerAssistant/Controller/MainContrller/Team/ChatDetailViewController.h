//
//  ChatDetailViewController.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-10-30.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "ChatDetailBottomView.h"
#import "OthersChatCell.h"
#import "MyselfChatCell.h"
#import "TeamUser.h"
#import "TeamManager.h"
#import "TeamManagerDelegate.h"
#import "MyselfChatCell.h"

@interface ChatDetailViewController : BaseViewController<ChatDetailBottomViewDelegate,UITableViewDataSource,UITableViewDelegate,TeamManagerDelegate,MyselfChatCellDelegate>
{
    IBOutlet UILabel *_Title;

    IBOutlet ChatDetailBottomView *m_bottomView;
    IBOutlet UITableView *m_chatTableView;
    NSArray *messageData;
}
@property (retain, nonatomic) UILabel *showTimeView;
@property (retain, nonatomic) TeamUser *receive;  //接受人
@end
