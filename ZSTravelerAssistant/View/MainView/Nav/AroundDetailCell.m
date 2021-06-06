//
//  AroundDetailCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "AroundDetailCell.h"

@implementation AroundDetailCell
@synthesize smallImgView,smallLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *tmpSmallImgView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 10, 20, 20)];
        tmpSmallImgView.backgroundColor = [UIColor clearColor];
        self.smallImgView = tmpSmallImgView;
        [self addSubview:tmpSmallImgView];
        SAFERELEASE(tmpSmallImgView)
        
        UILabel *tmpSmallLabel = [[UILabel alloc]initWithFrame:CGRectMake(65, 10, 60, 20)];
        tmpSmallLabel.backgroundColor = [UIColor clearColor];
        tmpSmallLabel.font = [UIFont systemFontOfSize:13.0f];
        tmpSmallLabel.textColor = [UIColor blackColor];
        self.smallLabel = tmpSmallLabel;
        [self addSubview:tmpSmallLabel];
        SAFERELEASE(tmpSmallLabel)
        
    }
    return self;
}

-(void)dealloc
{
    SAFERELEASE(smallLabel)
    SAFERELEASE(smallImgView)
    [super dealloc];
}
@end
