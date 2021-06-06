//
//  RouteOneView.m
//  ZSTravelerAssistant
//
//  Created by 梁谢超 on 13-8-5.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "RouteOneView.h"

@implementation RouteOneView
@synthesize delegate;
@synthesize m_IVBg,m_BtnStart,m_LbBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        m_IVBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
        [m_IVBg setImage:[UIImage imageNamed:@"Route-one-bg.png"]];
        m_IVBg.backgroundColor = [UIColor clearColor];
        [self addSubview:m_IVBg];
        
        m_BtnStart = [[UIButton alloc] initWithFrame:CGRectMake(95, 370, 130, 40)];
        if(!iPhone5)
        {
            m_BtnStart.frame = CGRectMake(95, 310, 130, 40);
        }
        m_BtnStart.backgroundColor = [UIColor clearColor];
        [m_BtnStart setBackgroundImage:[UIImage imageNamed:@"Route-button-on.png"] forState:UIControlStateNormal];
        [m_BtnStart setBackgroundImage:[UIImage imageNamed:@"Route-button-pressed.png"] forState:UIControlStateHighlighted];
        [self addSubview:m_BtnStart]; 
        [m_BtnStart addTarget:self action:@selector(startNavAction:) forControlEvents:UIControlEventTouchUpInside];
        
        m_LbBtn = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 130, 40)];
        m_LbBtn.backgroundColor = [UIColor clearColor];
        m_LbBtn.textAlignment = UITextAlignmentCenter;
        m_LbBtn.textColor = [UIColor whiteColor];
        m_LbBtn.text = [Language stringWithName:START_TRAVEL];
        [m_BtnStart addSubview:m_LbBtn];

    }
    return self;
}

- (void)startNavAction:(id)sender
{
    if(delegate && [delegate respondsToSelector:@selector(routeOneViewAction)])
    {
        [delegate routeOneViewAction];
    }
}

- (void)dealloc
{
    SAFERELEASE(m_IVBg);
    SAFERELEASE(m_BtnStart);
    SAFERELEASE(m_LbBtn);
    [super dealloc];
}
         
@end
