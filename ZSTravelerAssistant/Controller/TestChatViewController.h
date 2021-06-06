//
//  TestChatViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-4.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OthersChatCell.h"
#import "MyselfChatCell.h"

@interface TestChatViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{

}
@property (retain, nonatomic) UILabel *showTimeView;
@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) IBOutlet UITableView *m_chatTableView;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;

@property (nonatomic, assign) BOOL  isSingleChat;
//@property (retain, nonatomic) OthersChatCell *othersChatCell;
//@property (retain, nonatomic) MyselfChatCell *myselfChatCell;
//@property (retain, nonatomic) ShowTimeCell   *showTimeCell;
@end
