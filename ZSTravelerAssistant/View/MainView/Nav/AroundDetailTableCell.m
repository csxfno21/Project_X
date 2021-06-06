//
//  AroundDetailTableCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "AroundDetailTableCell.h"

@implementation AroundDetailTableCell
@synthesize typeImgView,titleLabel,disLabel,contentLabel,bottomLabel,cell1,cell2,downUpArrowImgView;
@synthesize arounDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *tmpTypeImgView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 20, 20)];
        tmpTypeImgView.backgroundColor = [UIColor clearColor];
        self.typeImgView = tmpTypeImgView;
        [self addSubview:tmpTypeImgView];
        SAFERELEASE(tmpTypeImgView)
        
        UILabel *tmpTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 10, 200, 15)];
        tmpTitleLabel.textColor = [UIColor blueColor];
        tmpTitleLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        tmpTitleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel = tmpTitleLabel;
        [self addSubview:tmpTitleLabel];
        SAFERELEASE(tmpTitleLabel)
        
        UILabel *tmpDisLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 10, 60, 15)];
        tmpDisLabel.textColor = [UIColor orangeColor];
        tmpDisLabel.font = [UIFont systemFontOfSize:13.0f];
        tmpDisLabel.backgroundColor = [UIColor clearColor];
        self.disLabel = tmpDisLabel;
        [self addSubview:tmpDisLabel];
        SAFERELEASE(tmpDisLabel)
        
        UILabel *tmpContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 30, 250, 30)];
        tmpContentLabel.textColor = [UIColor blackColor];
        tmpContentLabel.font = [UIFont systemFontOfSize:12.0f];
        tmpContentLabel.numberOfLines = 0;
        tmpContentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel = tmpContentLabel;
        [self addSubview:tmpContentLabel];
        SAFERELEASE(tmpContentLabel)
        
                
        AroundDetailCell *tmpCell1 = [[AroundDetailCell alloc]initWithFrame:CGRectMake(0, 70, 160, 40)];
        tmpCell1.backgroundColor = [UIColor lightGrayColor];
        [tmpCell1 setImage:[UIImage imageNamed:@"Route-Menu-pressed.png"] forState:UIControlStateHighlighted];
        tmpCell1.tag = 10;
        tmpCell1.smallLabel.text = [Language stringWithName:VIEW_LOCATION];
        tmpCell1.smallImgView.image = [UIImage imageNamed:@"Route-detail.png"];
        self.cell1 = tmpCell1;
        [self addSubview:tmpCell1];
        SAFERELEASE(tmpCell1)
        
        AroundDetailCell *tmpCell2 = [[AroundDetailCell alloc]initWithFrame:CGRectMake(160, 70, 160, 40)];
        tmpCell2.backgroundColor = [UIColor lightGrayColor];
        [tmpCell2 setImage:[UIImage imageNamed:@"Route-Menu-pressed.png"] forState:UIControlStateHighlighted];
        tmpCell2.tag = 11;
        tmpCell2.smallLabel.text = [Language stringWithName:ROUTE_MENU_NAVIGATION];
        tmpCell2.smallImgView.image = [UIImage imageNamed:@"Route-Where.png"];
        self.cell2 = tmpCell2;
        [self addSubview:tmpCell2];
        SAFERELEASE(tmpCell2)
        
        UIImageView *tmpDownUpArrowImgView = [[UIImageView alloc]initWithFrame:CGRectMake(280 , 20, 20, 20)];
        tmpDownUpArrowImgView.backgroundColor = [UIColor clearColor];
        self.downUpArrowImgView = tmpDownUpArrowImgView;
        [self addSubview:tmpDownUpArrowImgView];
        SAFERELEASE(tmpDownUpArrowImgView)
        
    
        [self.cell1 addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cell2 addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

- (void)menuAction:(id)sender
{
    AroundDetailCell *btn = (AroundDetailCell *)sender;
    COMMON_NAV_TYPE currentType = COMMON_NAV_TYPE_LOCATION;
    switch (btn.tag)
    {
        case 10:
        {
            currentType = COMMON_NAV_TYPE_LOCATION;
            break;
        }
        case 11:
        {
            currentType = COMMON_NAV_TYPE_HERE;
            break;
        }
        default:
        {
            currentType = COMMON_NAV_TYPE_LOCATION;
            break;
        }
    }
    if(arounDelegate && [arounDelegate respondsToSelector:@selector(aroundTableViewCellAction:withIndex:)])
    {
        [arounDelegate aroundTableViewCellAction:currentType withIndex:self.tag];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMenuAlpha:(CGFloat)fAlpha
{
    cell1.alpha = fAlpha;
    cell2.alpha = fAlpha;
}

- (void)setBIsShow:(BOOL)bIsShow
{
    
    if(_bIsShow == bIsShow)
    {
        if(_bIsShow == NO)
        {
            [self setMenuAlpha:0.0f];
            downUpArrowImgView.image = [UIImage imageNamed:@"Route-arrow-down.png"];
        }
        else
        {
            [self setMenuAlpha:1.0f];
            downUpArrowImgView.image = [UIImage imageNamed:@"Route-arrow-up.png"];
        }
        return;
    }
    _bIsShow = bIsShow;
    if(bIsShow)
    {
        [self setMenuAlpha:0.0f];
        downUpArrowImgView.image = [UIImage imageNamed:@"Route-arrow-up.png"];
    }
    else
    {
        [self setMenuAlpha:1.0f];
        downUpArrowImgView.image = [UIImage imageNamed:@"Route-arrow-down.png"];
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

-(void)dealloc
{
    SAFERELEASE(typeImgView)
    SAFERELEASE(titleLabel)
    SAFERELEASE(disLabel)
    SAFERELEASE(contentLabel)
    SAFERELEASE(cell1)
    SAFERELEASE(cell2)
    SAFERELEASE(downUpArrowImgView)
    [super dealloc];
}
@end
