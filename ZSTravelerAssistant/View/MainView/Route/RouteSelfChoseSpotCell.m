//
//  RouteSelfChoseSpotCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "RouteSelfChoseSpotCell.h"

@implementation RouteSelfChoseSpotCell
@synthesize cellImgView,cellRecomdImgView,cellTitle,cellContent,disImgView,disLabel,disValueLabel,disUnitLabel,priceImgView,priceLabel,priceValueLabel,priceUnitLabel,loadingView;
@synthesize downUpImgView;

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)init
{
    if (self = [super init])
    {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *tmpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
        tmpImgView.backgroundColor = [UIColor clearColor];
        self.cellImgView = tmpImgView;
        [self addSubview:tmpImgView];
        SAFERELEASE(tmpImgView)
        
        UIImageView *tmpRecomdImgView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 10, 70, 70)];
        tmpRecomdImgView.backgroundColor = [UIColor clearColor];
        self.cellRecomdImgView = tmpRecomdImgView;
        [self addSubview:tmpRecomdImgView];
        SAFERELEASE(tmpRecomdImgView)
        
        UIActivityIndicatorView *tloadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        tloadingView.frame = self.cellRecomdImgView.frame;
        self.loadingView = tloadingView;
        [self addSubview:self.loadingView];
        SAFERELEASE(tloadingView)
        
        UILabel *tmpTitle = [[UILabel alloc]initWithFrame:CGRectMake(90, 10, 200, 20)];
        tmpTitle.textColor = [UIColor blueColor];
        tmpTitle.backgroundColor = [UIColor clearColor];
        tmpTitle.font = [UIFont boldSystemFontOfSize:17];
        self.cellTitle = tmpTitle;
        [self addSubview:tmpTitle];
        SAFERELEASE(tmpTitle)
        
        UILabel *tmpContent = [[UILabel alloc]initWithFrame:CGRectMake(90, 38, 180, 30)];
        tmpContent.textColor = [UIColor blackColor];
        tmpContent.font = [UIFont systemFontOfSize:12.0f];
        tmpContent.backgroundColor = [UIColor clearColor];
        tmpContent.numberOfLines = 0;
        self.cellContent = tmpContent;
        [self addSubview:tmpContent];
        SAFERELEASE(tmpContent)
        
        UIImageView *tmpDisImgView = [[UIImageView alloc]initWithFrame:CGRectMake(85, 73, 18, 18)];
        tmpDisImgView.backgroundColor = [UIColor clearColor];
        tmpDisImgView.image = [UIImage imageNamed:@"Route-dis.png"];
        self.disImgView = tmpDisImgView;
        [self addSubview:tmpDisImgView];
        SAFERELEASE(tmpDisImgView)
        
        UILabel *tmpDisLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 75, 55, 15)];
        tmpDisLabel.textColor = [UIColor blackColor];
        tmpDisLabel.font = [UIFont systemFontOfSize:13.0f];
        tmpDisLabel.backgroundColor = [UIColor clearColor];
        tmpDisLabel.text = [Language stringWithName:ROUTE_TRIP];
        self.disLabel = tmpDisLabel;
        [self addSubview:tmpDisLabel];
        SAFERELEASE(tmpDisLabel)
        
        UILabel *tmpDisValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 71, 35, 20)];
        tmpDisValueLabel.textColor = [UIColor orangeColor];
        tmpDisValueLabel.font = [UIFont systemFontOfSize:17.0f];
        tmpDisValueLabel.textAlignment = UITextAlignmentCenter;
        tmpDisValueLabel.backgroundColor = [UIColor clearColor];
        self.disValueLabel = tmpDisValueLabel;
        [self addSubview:tmpDisValueLabel];
        SAFERELEASE(tmpDisValueLabel)
        
        UILabel *tmpDisUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(178, 75, 20, 15)];
        tmpDisUnitLabel.textColor = [UIColor orangeColor];
        tmpDisUnitLabel.backgroundColor = [UIColor clearColor];
        tmpDisUnitLabel.text = @"km";
        tmpDisUnitLabel.font = [UIFont systemFontOfSize:12.0f];
        self.disUnitLabel = tmpDisUnitLabel;
        [self addSubview:tmpDisUnitLabel];
        SAFERELEASE(tmpDisUnitLabel)
        
        UIImageView *tmpPriceImgView = [[UIImageView alloc]initWithFrame:CGRectMake(205, 73, 18, 18)];
        tmpPriceImgView.backgroundColor = [UIColor clearColor];
        tmpPriceImgView.image = [UIImage imageNamed:@"Route-Price.png"];
        self.priceImgView = tmpPriceImgView;
        [self addSubview:tmpPriceImgView];
        SAFERELEASE(tmpPriceImgView)
        
        UILabel *tmpPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(226, 75, 30, 15)];
        tmpPriceLabel.textColor = [UIColor blackColor];
        tmpPriceLabel.font = [UIFont systemFontOfSize:13.0f];
        tmpPriceLabel.backgroundColor = [UIColor clearColor];
        tmpPriceLabel.text = [Language stringWithName:PRICE];
        self.priceLabel = tmpPriceLabel;
        [self addSubview:tmpPriceLabel];
        SAFERELEASE(tmpPriceLabel)
        
        UILabel *tmpPriceValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(251, 71, 28, 20)];
        tmpPriceValueLabel.textColor = [UIColor orangeColor];
        tmpPriceValueLabel.font = [UIFont systemFontOfSize:16.0f];
        tmpPriceValueLabel.textAlignment = UITextAlignmentCenter;
        tmpPriceValueLabel.backgroundColor = [UIColor clearColor];
        self.priceValueLabel = tmpPriceValueLabel;
        [self addSubview:tmpPriceValueLabel];
        SAFERELEASE(tmpPriceValueLabel)
        
        UILabel *tmpPriceUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(275, 75, 20, 15)];
        tmpPriceUnitLabel.textColor = [UIColor orangeColor];
        tmpPriceUnitLabel.text = [Language stringWithName:YUAN];
        tmpPriceUnitLabel.font = [UIFont systemFontOfSize:13.0f];
        tmpPriceUnitLabel.backgroundColor = [UIColor clearColor];
        self.priceUnitLabel = tmpPriceUnitLabel;
        [self addSubview:tmpPriceUnitLabel];
        SAFERELEASE(tmpPriceUnitLabel)
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 99, 310, .7)];
        lineView.alpha = .7;
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        SAFERELEASE(lineView)
        
        UIImageView *tmpDownUpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(282, 10, 20, 20)];
        tmpDownUpImgView.backgroundColor = [UIColor clearColor];
        tmpDownUpImgView.image = [UIImage imageNamed:@"Route-edit.png"];
        self.downUpImgView = tmpDownUpImgView;
        [self addSubview:tmpDownUpImgView];
        SAFERELEASE(tmpDownUpImgView)

    }
    return self;

}
- (void)menuAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    ROUTE_MENU_TYPE currentType = ROUTE_MENU_TYPE_DETAIL;
    switch (btn.tag)
    {
        case 10:
        {
            currentType = ROUTE_MENU_TYPE_DETAIL;
            break;
        }
        case 11:
        {
            currentType = ROUTE_MENU_TYPE_LOCATION;
            break;
        }
        case 12:
        {
            currentType = ROUTE_MENU_TYPE_NAVIGATION;
            break;
        }
        default:
        {
            currentType = ROUTE_MENU_TYPE_DETAIL;
            break;
        }
    }
    if(delegate && [delegate respondsToSelector:@selector(routeSelfChoseCellAction:withIndex:)])
    {
        [delegate routeSelfChoseCellAction:currentType withIndex:self.tag];
    }
}




- (void)dealloc
{
    [cellImgView release];
    [cellRecomdImgView release];
    [cellTitle release];
    [cellContent release];
    [disImgView release];
    [disLabel release];
    [disValueLabel release];
    [disUnitLabel release];
    [priceImgView release];
    [priceLabel release];
    [priceValueLabel release];
    [priceUnitLabel release];
    [downUpImgView release];

    [super dealloc];
}
@end
