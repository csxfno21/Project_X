//
//  TeamChatCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-22.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "TeamChatCell.h"

@implementation TeamChatCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *tmpHeadImgView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 54, 54)];
        tmpHeadImgView.backgroundColor = [UIColor clearColor];
        tmpHeadImgView.image = [UIImage imageNamed:@"head-pic-other.png"];
        self.headImgView = tmpHeadImgView;
        [self addSubview:tmpHeadImgView];
        SAFERELEASE(tmpHeadImgView)
        
        UILabel *tmpNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 10, 150, 20)];
        tmpNameLabel.textColor = [UIColor blackColor];
        tmpNameLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        self.nameLabel = tmpNameLabel;
        [self addSubview:tmpNameLabel];
        SAFERELEASE(tmpNameLabel)
        
        UILabel *tmpOnlineLabel = [[UILabel alloc]initWithFrame:CGRectMake(280, 10, 30, 20)];
        tmpOnlineLabel.textColor = [UIColor grayColor];
        tmpOnlineLabel.font = [UIFont systemFontOfSize:14.0f];
        self.stateOnlineLabel = tmpOnlineLabel;
        [self addSubview:tmpOnlineLabel];
        SAFERELEASE(tmpOnlineLabel)
        
        UILabel *tmpDisLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 45, 30, 15)];
        tmpDisLabel.text = [Language stringWithName:DISTANCE];
        tmpDisLabel.textColor = [UIColor blackColor];
        tmpDisLabel.font = [UIFont systemFontOfSize:14.0f];
        self.disLabel = tmpDisLabel;
        [self addSubview:tmpDisLabel];
        SAFERELEASE(tmpDisLabel)
        
        UILabel *tmpDisValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 45, 80, 15)];
        tmpDisValueLabel.textColor = [UIColor orangeColor];
        tmpDisValueLabel.textAlignment = NSTextAlignmentLeft;
        tmpDisValueLabel.font = [UIFont systemFontOfSize:17.0f];
        self.disValueLabel = tmpDisValueLabel;
        [self addSubview:tmpDisValueLabel];
        SAFERELEASE(tmpDisValueLabel)
        
        UILabel *tmpDisUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 45, 30, 15)];
        tmpDisUnitLabel.text = @"km";
        tmpDisUnitLabel.textColor = [UIColor orangeColor];
        tmpDisUnitLabel.font = [UIFont systemFontOfSize:14.0f];
        self.disUnitLabel = tmpDisUnitLabel;
        [self addSubview:tmpDisUnitLabel];
        SAFERELEASE(tmpDisUnitLabel)
        
        ///////////菜单控件
        UIImageView *tmpIVMenuBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, 320, 40)];
        tmpIVMenuBg.image = [UIImage imageNamed:@"Route-Menu-bg.png"];
        self.backgroundImgView = tmpIVMenuBg;
        SAFERELEASE(tmpIVMenuBg);
        [self addSubview:self.backgroundImgView];

        TeamChatButton *tmpLocationBtn = [[TeamChatButton alloc]initWithFrame:CGRectMake(0, 70, 100, 40)];
        tmpLocationBtn.smallImgView.image = [UIImage imageNamed:@"location-team.png"];
        tmpLocationBtn.nameLabel.text = [Language stringWithName:ROUTE_MENU_LOCATION];
        self.locationChatBtn = tmpLocationBtn;
        self.locationChatBtn.tag = 2;
        [self.locationChatBtn addTarget:self action:@selector(messagePopViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tmpLocationBtn];
        SAFERELEASE(tmpLocationBtn)
        
        TeamChatButton *tmpGuideBtn = [[TeamChatButton alloc]initWithFrame:CGRectMake(100, 70, 100, 40)];
        tmpGuideBtn.smallImgView.image = [UIImage imageNamed:@"guide.png"];
        tmpGuideBtn.nameLabel.text = [Language stringWithName:GUIDE];
        self.guideChatBtn = tmpGuideBtn;
        self.guideChatBtn.tag = 3;
        [self.guideChatBtn addTarget:self action:@selector(messagePopViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tmpGuideBtn];
        SAFERELEASE(tmpGuideBtn)
        
        TeamChatButton *tmpSendMessageBtn = [[TeamChatButton alloc]initWithFrame:CGRectMake(200, 70, 120, 40)];
        tmpSendMessageBtn.smallImgView.image = [UIImage imageNamed:@"team-sendSingleMsg.png"];
        tmpSendMessageBtn.nameLabel.text = [Language stringWithName:SENDMESSAGE];
        tmpSendMessageBtn.titleLabel.textColor = [UIColor whiteColor];
        tmpSendMessageBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.sendMessageBtn = tmpSendMessageBtn;
        self.sendMessageBtn.tag = 1;
        [self.sendMessageBtn addTarget:self action:@selector(messagePopViewAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:tmpSendMessageBtn];
        SAFERELEASE(tmpSendMessageBtn)
        
        ///////////菜单控件
        
    }
    return self;
}

- (void)setMenuAlpha:(CGFloat)fAlpha
{
    self.backgroundImgView.alpha = fAlpha;
    self.sendMessageBtn.alpha = fAlpha;
    self.locationChatBtn.alpha = fAlpha;
    self.guideChatBtn.alpha = fAlpha;
}

- (void)setBIsShow:(BOOL)bIsShow
{
    
    if(_bIsShow == bIsShow)
    {
        if(_bIsShow == NO)
        {
            [self setMenuAlpha:0.0f];
        }
        else
        {
            [self setMenuAlpha:1.0f];
        }
        return;
    }
    _bIsShow = bIsShow;
    if(bIsShow)
    {
        [self setMenuAlpha:0.0f];
    }
    else
    {
        [self setMenuAlpha:1.0f];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        if(bIsShow)
        {
            [self setMenuAlpha:1.0f];
        }
        else
        {
            [self setMenuAlpha:0.0f];
        }
        
    } completion:^(BOOL finished) {
    }];
    
}

-(void)messagePopViewAction:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    TEAM_ACTION_TYPE type = TEAM_ACTION_TYPE_SENDMESSAGE;
    switch (btn.tag) {
        case 1:
        {
            type = TEAM_ACTION_TYPE_SENDMESSAGE;
            break;
        }
        case 2:
        {
            type = TEAM_ACTION_TYPE_LOCATION;
            break;
        }
        case 3:
        {
            type = TEAM_ACTION_TYPE_GUIDE;
            break;
        }
        default:
        {
            type = TEAM_ACTION_TYPE_SENDMESSAGE;
            break;
        }
    }
    if (delegate && [delegate respondsToSelector:@selector(teamChatMessageAction:withType:)])
    {
        [delegate teamChatMessageAction:self.tag withType:type];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
