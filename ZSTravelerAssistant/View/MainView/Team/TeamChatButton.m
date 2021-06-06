//
//  TeamChatButton.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-22.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "TeamChatButton.h"

@implementation TeamChatButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *tmpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
        tmpImgView.backgroundColor = [UIColor clearColor];
        self.smallImgView = tmpImgView;
        [self addSubview:tmpImgView];
        SAFERELEASE(tmpImgView)
        
        UILabel *tmpLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 10, 60, 20)];
        tmpLabel.textColor = [UIColor blueColor];
        tmpLabel.backgroundColor = [UIColor clearColor];
        tmpLabel.font = [UIFont  boldSystemFontOfSize:15.0f];
        self.nameLabel = tmpLabel;
        [self addSubview:tmpLabel];
        SAFERELEASE(tmpLabel)

        [self setImage:[UIImage imageNamed:@"Route-Menu-pressed.png"] forState:UIControlStateHighlighted];
    }
    return self;
}

-(void)dealloc
{
    SAFERELEASE(_smallImgView)
    SAFERELEASE(_nameLabel)
    [super dealloc];
}

@end
