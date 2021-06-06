//
//  CommonCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-12.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "AroundCell.h"

@implementation AroundCell
@synthesize imageView,nameLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *tmpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 5, 45, 35)];
        tmpImgView.backgroundColor = [UIColor clearColor];
        self.imageView = tmpImgView;
        [self addSubview:tmpImgView];
        SAFERELEASE(tmpImgView)
        
        UILabel     *tmpNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(29, 53, 50, 15)];
        tmpNameLabel.backgroundColor = [UIColor clearColor];
        tmpNameLabel.textColor = [UIColor blackColor];
        tmpNameLabel.font = [UIFont systemFontOfSize:13.0f];
        self.nameLabel = tmpNameLabel;
        [self addSubview:tmpNameLabel];
        SAFERELEASE(tmpNameLabel)
        
        
    }
    return self;
}

-(void)dealloc
{
    SAFERELEASE(imageView)
    SAFERELEASE(nameLabel)
    [super dealloc];
}

@end
