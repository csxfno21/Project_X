//
//  TeamChatCell.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-22.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamChatButton.h"

typedef enum
{
    TEAM_ACTION_TYPE_SENDMESSAGE = 0,
    TEAM_ACTION_TYPE_LOCATION,
    TEAM_ACTION_TYPE_GUIDE,
}TEAM_ACTION_TYPE;

@protocol TeamChatCellDelegate <NSObject>

-(void)teamChatMessageAction:(int)index withType:(TEAM_ACTION_TYPE)type;

@end


@interface TeamChatCell : UITableViewCell
{
    id<TeamChatCellDelegate> delegate;
}
@property (assign, nonatomic) id<TeamChatCellDelegate> delegate;
@property (nonatomic, retain) UIImageView *cellImgView;
@property (nonatomic, retain) UIImageView *headImgView;
@property (nonatomic, retain) UILabel     *nameLabel;
@property (nonatomic, retain) UILabel     *stateOnlineLabel;
@property (nonatomic, retain) UILabel     *disLabel;
@property (nonatomic, retain) UILabel     *disValueLabel;
@property (nonatomic, retain) UILabel     *disUnitLabel;
@property (nonatomic, retain) UIImageView    *backgroundImgView;
@property (nonatomic, retain) TeamChatButton *locationChatBtn;
@property (nonatomic, retain) TeamChatButton *guideChatBtn;
@property (nonatomic, retain) TeamChatButton    *sendMessageBtn;
@property(assign, nonatomic)BOOL bIsShow;
@end
