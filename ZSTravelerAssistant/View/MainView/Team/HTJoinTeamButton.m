//
//  HTJoinTeamButton.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-9.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "HTJoinTeamButton.h"

@implementation HTJoinTeamButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setBackgroundImage:[UIImage imageNamed:@"join_team_backgr.png"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"join_team_pressed.png"] forState:UIControlStateHighlighted];
        
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(120, 10, 20, 20)];
        [tmpImgView setImage:[UIImage imageNamed:@"join_team.png"]];
        self.joinImgView = tmpImgView;
        [self addSubview:tmpImgView];
        SAFERELEASE(tmpImgView)
        
        UILabel *tmpLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 10, 100, 20)];
        tmpLabel.backgroundColor = [UIColor clearColor];
        tmpLabel.text = [Language stringWithName:JOINTEAM];
        tmpLabel.textColor = [UIColor blueColor];
        tmpLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        self.joinLabel = tmpLabel;
        [self addSubview:tmpLabel];
        SAFERELEASE(tmpLabel)
    }
    return self;
}

-(void)dealloc
{
    [_joinImgView release];
    [_joinLabel release];
    [super dealloc];
}

@end
