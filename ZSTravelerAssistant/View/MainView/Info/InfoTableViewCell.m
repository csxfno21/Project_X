//
//  InfoTableViewCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "InfoTableViewCell.h"

@implementation InfoTableViewCell
@synthesize m_IVBg;
@synthesize m_IVIcon;
@synthesize m_LbHot;
@synthesize m_IVArrow;
@synthesize m_IVImg;
@synthesize m_LbTitle;
@synthesize m_LbContent;
@synthesize loadingView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *tmpBg = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 310, 155)];
        [tmpBg setImage:[[UIImage imageNamed:@"info-cell-bg.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        self.m_IVBg = tmpBg;
        SAFERELEASE(tmpBg)
        [self addSubview:self.m_IVBg];
        
        UIImageView *tmpIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 10, 25, 25)];
        [tmpIcon setImage:[[UIImage imageNamed:@"info-cell-hot.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
        self.m_IVIcon = tmpIcon;
        SAFERELEASE(tmpIcon)
        [self addSubview:self.m_IVIcon];
        
        UILabel *tmpLbHot = [[UILabel alloc]initWithFrame:CGRectMake(17, 7, 30, 30)];
        tmpLbHot.backgroundColor = [UIColor clearColor];
        tmpLbHot.textColor = [UIColor whiteColor];
        tmpLbHot.font = [UIFont systemFontOfSize:15];
        tmpLbHot.textAlignment = UITextAlignmentLeft;
        tmpLbHot.text = [Language stringWithName:INFO_CELL_HOT];
        self.m_LbHot = tmpLbHot;
        SAFERELEASE(tmpLbHot)
        [self addSubview:self.m_LbHot];
        
        UIImageView *tmpArrow = [[UIImageView alloc] initWithFrame:CGRectMake(292, 13, 18, 18)];
        [tmpArrow setImage:[UIImage imageNamed:@"info-cell-arr.png"]];
        self.m_IVArrow = tmpArrow;
        SAFERELEASE(tmpArrow)
        [self addSubview:self.m_IVArrow];
        
        UILabel *tmpLbTitle = [[UILabel alloc]initWithFrame:CGRectMake(45, 13, 240, 20)];
        tmpLbTitle.backgroundColor = [UIColor clearColor];
        tmpLbTitle.textColor = [UIColor blackColor];
        tmpLbTitle.font = [UIFont systemFontOfSize:16];
        tmpLbTitle.textAlignment = UITextAlignmentLeft;
        self.m_LbTitle = tmpLbTitle;
        SAFERELEASE(tmpLbTitle);
        [self addSubview:self.m_LbTitle];
        
        UIImageView *tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(14, 38, 292, 70)];
        tmpImg.layer.masksToBounds = YES;
        tmpImg.layer.cornerRadius = 2.0f;
        self.m_IVImg = tmpImg;
        SAFERELEASE(tmpImg);
        [self addSubview:self.m_IVImg];
        
        UIActivityIndicatorView *tloadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        tloadingView.frame = self.m_IVImg.frame;
        self.loadingView = tloadingView;
        [self addSubview:self.loadingView];
        SAFERELEASE(tloadingView)
        
        UILabel *tmpLbContent = [[UILabel alloc]initWithFrame:CGRectMake(14, 113, 292, 32)];
        tmpLbContent.backgroundColor = [UIColor clearColor];
        tmpLbContent.textColor = [UIColor blackColor];
        tmpLbContent.font = [UIFont systemFontOfSize:13];
        tmpLbContent.textAlignment = UITextAlignmentLeft;
        tmpLbContent.lineBreakMode = UILineBreakModeWordWrap;
        [tmpLbContent setNumberOfLines:0];
        self.m_LbContent = tmpLbContent;
        SAFERELEASE(tmpLbContent);
        [self addSubview:m_LbContent];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void)dealloc
{
    SAFERELEASE(loadingView)
    SAFERELEASE(m_IVBg)
    SAFERELEASE(m_IVIcon);
    SAFERELEASE(m_LbHot);
    SAFERELEASE(m_IVArrow);
    SAFERELEASE(m_IVImg);
    SAFERELEASE(m_LbTitle);
    SAFERELEASE(m_LbContent);
    [super dealloc];
}
@end
