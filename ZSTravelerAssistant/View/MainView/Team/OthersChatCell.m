//
//  OthersChatCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-4.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "OthersChatCell.h"

@implementation OthersChatCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.isSingleChat = NO;
        
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 8, 40, 40)];
        self.headImgView = tmpImgView;
        [self addSubview:tmpImgView];
        SAFERELEASE(tmpImgView)
        
        UILabel *tmpChatPeopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 8, 50, 8)];
        tmpChatPeopleLabel.textColor = [UIColor lightGrayColor];
        tmpChatPeopleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.chatPeopleLabel = tmpChatPeopleLabel;
        [self addSubview:tmpChatPeopleLabel];
        SAFERELEASE(tmpChatPeopleLabel)
        
        UIImageView *tmpChatBackgroundImgView = [[UIImageView alloc] init];
        tmpChatBackgroundImgView.image = [UIImage imageNamed:@"chat_recive_nor.png"];
        tmpChatBackgroundImgView.backgroundColor = [UIColor clearColor];
        self.chatBackgroundImgView = tmpChatBackgroundImgView;
        [self addSubview:tmpChatBackgroundImgView];
        SAFERELEASE(tmpChatBackgroundImgView)
        
        HTEmotionView *tmpChatContentLabel = [[HTEmotionView alloc] initWithFrame:CGRectMake(80, 40, 200 , 50)];
        tmpChatContentLabel.backgroundColor = [UIColor clearColor];
        self.chatContentLabel = tmpChatContentLabel;
        [self addSubview:tmpChatContentLabel];
        SAFERELEASE(tmpChatContentLabel)
        
        
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
        ;//使用默认头像
    }
    else
    {
        [self.headImgView setImage:[UIImage imageNamed:image]];
    }
}

-(void)setChatPeopleText:(NSString *)chatPeople
{
    if (!chatPeople)
    {
        return;
    }
    else
    {
        CGSize size = [chatPeople sizeWithFont:self.chatPeopleLabel.font constrainedToSize:CGSizeMake(30, 8) lineBreakMode:NSLineBreakByWordWrapping];
        self.chatPeopleLabel.frame = CGRectMake(55, 8, size.width, size.height);
        self.chatPeopleLabel.text = chatPeople;
    }
}

-(void)setChatContentText:(NSString *)chatContent
{
    
    if (!chatContent)
    {
        return;
    }
    else
    {
        CGSize size = [HTEmotionView sizeWithMessage:chatContent];
        self.chatContentLabel.emotionString = chatContent;
        if (self.isSingleChat == NO)
        {
            self.chatBackgroundImgView.frame = CGRectMake(55, 30, size.width + 40, size.height + 25);
            self.chatBackgroundImgView.image = [[UIImage imageNamed:@"chat_recive_nor.png"] stretchableImageWithLeftCapWidth:32 topCapHeight:28];
        }
        else
        {
            self.chatContentLabel.frame = CGRectMake(self.chatContentLabel.frame.origin.x, 17, self.chatContentLabel.frame.size.width, self.chatContentLabel.frame.size.height);
            self.chatBackgroundImgView.frame = CGRectMake(55, 5, size.width + 40, size.height + 25);
            self.chatBackgroundImgView.image = [[UIImage imageNamed:@"chat_recive_nor.png"] stretchableImageWithLeftCapWidth:32 topCapHeight:28];
        }
    }
}
//发送聊天内容为图片
-(void)setChatContentImageWithPoint:(CLLocationCoordinate2D)point
{
    if (point.longitude == 0.0 || point.latitude == 0.0)
    {
        //使用默认图片
    }
    else
    {
        [self.locationBtn setImage:[UIImage imageNamed:@"team-sex-girl.png"] forState:UIControlStateNormal];
    }
}

-(void)locationAction:(id)sender
{
    if (delegate && [delegate respondsToSelector:@selector(othersLocation)])
    {
        [delegate othersLocation];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [_locationBtn release];
    [_headImgView release];
    [_chatBackgroundImgView release];
    [_chatPeopleLabel release];
    [_chatContentLabel release];
    [super dealloc];
}

@end
