//
//  MyselfChatCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-4.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "MyselfChatCell.h"

@implementation MyselfChatCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(270, 12, 40, 40)];
        self.headImgView = tmpImgView;
        [self addSubview:tmpImgView];
        SAFERELEASE(tmpImgView)
        
        UIImageView *tmpChatBackgroundImgView = [[UIImageView alloc] init];
        tmpChatBackgroundImgView.image = [UIImage imageNamed:@"chat_send.png"];
        tmpChatBackgroundImgView.backgroundColor = [UIColor clearColor];
        self.chatBackgroundImgView = tmpChatBackgroundImgView;
        [self addSubview:tmpChatBackgroundImgView];
        SAFERELEASE(tmpChatBackgroundImgView)
        
        HTEmotionView *tmpLabel = [[HTEmotionView alloc] initWithFrame:CGRectMake(60, 40, 200 , 50)];
        self.chatContentLabel = tmpLabel;
        [self addSubview:tmpLabel];
        SAFERELEASE(tmpLabel)

        
        UIButton *tmpButton = [[UIButton alloc] init];
        tmpButton.hidden = YES;
        [tmpButton setImage:[UIImage imageNamed:@"SOS-pop-i.png"] forState:UIControlStateNormal];
        [tmpButton addTarget:self action:@selector(sendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
        self.warningBtn = tmpButton;
        [self addSubview:tmpButton];
        SAFERELEASE(tmpButton)
        
        
        UIActivityIndicatorView *tmpActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        tmpActivityIndicatorView.backgroundColor = [UIColor clearColor];
        tmpActivityIndicatorView.hidesWhenStopped = YES;
        self.refreshSpinner = tmpActivityIndicatorView;
        [self addSubview:self.refreshSpinner];
        SAFERELEASE(tmpActivityIndicatorView)
        
        
        UIButton *tmpLocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 0, 160, 50)];
        tmpLocationBtn.hidden = YES;
        [tmpLocationBtn setBackgroundColor:[UIColor blueColor]];
        [tmpLocationBtn setImage:[UIImage imageNamed:@"team-sex-girl.png"] forState:UIControlStateNormal];
        [tmpLocationBtn addTarget:self action:@selector(locationAction:)  forControlEvents:UIControlEventTouchUpInside];
        self.locationBtn = tmpLocationBtn;
        [self addSubview:tmpLocationBtn];
        SAFERELEASE(tmpLocationBtn)
    }
    return self;
}

-(void)setHeadImage:(NSString *)image
{
    if (!image)
    {
        //使用默认头像
    }
    else
    {
        [self.headImgView setImage:[UIImage imageNamed:image]];
    }
}

-(void)setChatContentText:(NSString *)chatContent
{
    self.chatContentLabel.hidden = NO;
    self.locationBtn.hidden = YES;
    if (!chatContent)
    {
        return;
    }
    else
    {
        CGSize size = [HTEmotionView sizeWithMessage:chatContent];
        self.chatContentLabel.emotionString = chatContent;
        self.chatContentLabel.frame = CGRectMake(260 - size.width - 5, 16, size.width, size.height);
        self.chatBackgroundImgView.frame = CGRectMake(245 - size.width - 5, 10, self.chatContentLabel.frame.size.width + 25 , self.chatContentLabel.frame.size.height + 20);
        self.chatBackgroundImgView.image = [[UIImage imageNamed:@"chat_send.png"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        self.warningBtn.frame = CGRectMake(260 - size.width - 40 - 5, 16, 25, 25);
        self.refreshSpinner.frame = self.warningBtn.frame;
        [self.refreshSpinner startAnimating];
        [self addSubview:self.refreshSpinner];
    }
}
//发送聊天内容为图片
-(void)setChatContentImageWithPoint:(CLLocationCoordinate2D)point
{
    self.chatContentLabel.hidden = YES;
    self.locationBtn.hidden = NO;
    if (point.longitude == 0.0 || point.latitude == 0.0)
    {
        //使用默认图片
        return;
    }
    else
    {
        [self.locationBtn setImage:[UIImage imageNamed:@"team-sex-girl.png"] forState:UIControlStateNormal];
        self.warningBtn.frame = CGRectMake(115 , 16, 25, 25);
        self.refreshSpinner.frame = self.warningBtn.frame;
        [self.refreshSpinner startAnimating];
        [self addSubview:self.refreshSpinner];
    }
}

-(void)sendMessageAction:(NSString*)emotionString
{
    if (delegate && [delegate respondsToSelector:@selector(reSendMessage:)])
    {
        [delegate reSendMessage:emotionString];
    }
}
-(void)locationAction:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(location)])
    {
        [delegate location];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [_headImgView release];
    [_chatContentLabel release];
    [_chatBackgroundImgView release];
    [_warningBtn release];
    [_locationBtn release];
    [super dealloc];
}

@end
