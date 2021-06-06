//
//  RecomdLineCell.m
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-1.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "RecomdLineCell.h"

@implementation RecomdLineCell
@synthesize cellImgView,cellRecomdImgView,cellTitle,cellContent,disImgView,disLabel,disValueLabel,disUnitLabel,priceImgView,priceLabel,priceValueLabel,priceUnitLabel,downUpImgView,recomdCellDelgate,loadingView;
@synthesize IVBg;
@synthesize m_IVLocation;
@synthesize m_BtnMenuDetail;
@synthesize m_IVMenuDetail;
@synthesize m_LBMenuDetail;
@synthesize m_BtnMenuLocate;
@synthesize m_IVMenuLocate;
@synthesize m_LBMenuLocate;
@synthesize m_BtnMenuNavigation;
@synthesize m_IVMenuNavigation;
@synthesize m_LBMenuNavigation;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
        tmpTitle.font = [UIFont boldSystemFontOfSize:17];
        self.cellTitle = tmpTitle;
        [self addSubview:tmpTitle];
        SAFERELEASE(tmpTitle)
        
        UILabel *tmpContent = [[UILabel alloc]initWithFrame:CGRectMake(90, 38, 180, 30)];
        tmpContent.textColor = [UIColor blackColor];
        tmpContent.font = [UIFont systemFontOfSize:12.0f];
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
        tmpDisLabel.text = [Language stringWithName:ROUTE_TRIP];
        self.disLabel = tmpDisLabel;
        [self addSubview:tmpDisLabel];
        SAFERELEASE(tmpDisLabel)
        
        UILabel *tmpDisValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(159, 71, 20, 20)];
        tmpDisValueLabel.textColor = [UIColor orangeColor];
        tmpDisValueLabel.font = [UIFont systemFontOfSize:17.0f];
        tmpDisValueLabel.textAlignment = UITextAlignmentCenter;
        self.disValueLabel = tmpDisValueLabel;
        [self addSubview:tmpDisValueLabel];
        SAFERELEASE(tmpDisValueLabel)
        
        UILabel *tmpDisUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(182, 75, 18, 15)];
        tmpDisUnitLabel.textColor = [UIColor orangeColor];
        tmpDisUnitLabel.text = @"km";
        tmpDisUnitLabel.font = [UIFont systemFontOfSize:12.0f];
        self.disUnitLabel = tmpDisUnitLabel;
        [self addSubview:tmpDisUnitLabel];
        SAFERELEASE(tmpDisUnitLabel)
        
        UIImageView *tmpPriceImgView = [[UIImageView alloc]initWithFrame:CGRectMake(207, 73, 18, 18)];
        tmpPriceImgView.backgroundColor = [UIColor clearColor];
        tmpPriceImgView.image = [UIImage imageNamed:@"Route-Price.png"];
        self.priceImgView = tmpPriceImgView;
        [self addSubview:tmpPriceImgView];
        SAFERELEASE(tmpPriceImgView)
        
        UILabel *tmpPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(228, 75, 30, 15)];
        tmpPriceLabel.textColor = [UIColor blackColor];
        tmpPriceLabel.font = [UIFont systemFontOfSize:13.0f];
        tmpPriceLabel.text = [Language stringWithName:PRICE];
        self.priceLabel = tmpPriceLabel;
        [self addSubview:tmpPriceLabel];
        SAFERELEASE(tmpPriceLabel)
        //
        UILabel *tmpPriceValueLabel = [[UILabel alloc]initWithFrame:CGRectMake(255, 71, 28, 20)];
        tmpPriceValueLabel.textColor = [UIColor orangeColor];
        tmpPriceValueLabel.font = [UIFont systemFontOfSize:16.0f];
        tmpPriceValueLabel.textAlignment = UITextAlignmentCenter;
        self.priceValueLabel = tmpPriceValueLabel;
        [self addSubview:tmpPriceValueLabel];
        SAFERELEASE(tmpPriceValueLabel)
        
        UILabel *tmpPriceUnitLabel = [[UILabel alloc]initWithFrame:CGRectMake(286, 75, 17, 15)];
        tmpPriceUnitLabel.textColor = [UIColor orangeColor];
        tmpPriceUnitLabel.text = [Language stringWithName:YUAN];
        tmpPriceUnitLabel.font = [UIFont systemFontOfSize:13.0f];
        self.priceUnitLabel = tmpPriceUnitLabel;
        [self addSubview:tmpPriceUnitLabel];
        SAFERELEASE(tmpPriceUnitLabel)
        
        UIImageView *tmpDownUpImgView = [[UIImageView alloc]initWithFrame:CGRectMake(282, 40, 20, 20)];
        tmpDownUpImgView.backgroundColor = [UIColor clearColor];
        tmpDownUpImgView.image = [UIImage imageNamed:@"Route-arrow-down.png"];
        self.downUpImgView = tmpDownUpImgView;
        [self addSubview:tmpDownUpImgView];
        SAFERELEASE(tmpDownUpImgView)
        
        UIImageView *tmpIVMenuBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 42)];
        tmpIVMenuBg.image = [UIImage imageNamed:@"Route-Menu-bg.png"];
        tmpIVMenuBg.backgroundColor = [UIColor clearColor];
        self.IVBg = tmpIVMenuBg;
        SAFERELEASE(tmpIVMenuBg);
        [self addSubview:self.IVBg];
        
        //菜单1***
        UIButton *tmpBtnMenuDetail = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, 110, 42)];
        [tmpBtnMenuDetail setImage:[UIImage imageNamed:@"Route-Menu-pressed.png"] forState:UIControlStateHighlighted];
        tmpBtnMenuDetail.tag = 10;
        self.m_BtnMenuDetail = tmpBtnMenuDetail;
        SAFERELEASE(tmpBtnMenuDetail);
        [self addSubview:self.m_BtnMenuDetail];
        
        UIImageView *tmpIVMenuDetail = [[UIImageView alloc] initWithFrame:CGRectMake(15, 110, 25, 25)];
        tmpIVMenuDetail.image = [UIImage imageNamed:@"Route-detail.png"];
        tmpIVMenuDetail.backgroundColor = [UIColor clearColor];
        self.m_IVMenuDetail = tmpIVMenuDetail;
        SAFERELEASE(tmpIVMenuDetail);
        [self addSubview:self.m_IVMenuDetail];
        
        UILabel *tmpLbMenuDetail = [[UILabel alloc] initWithFrame:CGRectMake(41, 113, 70, 17)];
        tmpLbMenuDetail.backgroundColor = [UIColor clearColor];
        tmpLbMenuDetail.textColor = [UIColor blackColor];
        tmpLbMenuDetail.font = [UIFont systemFontOfSize:13];
        tmpLbMenuDetail.textAlignment = UITextAlignmentLeft;
        tmpLbMenuDetail.text = [Language stringWithName:ROUTE_MENU_INFODETAIL];
        self.m_LBMenuDetail = tmpLbMenuDetail;
        SAFERELEASE(tmpLbMenuDetail);
        [self addSubview:self.m_LBMenuDetail];
        //菜单1***
        
        //菜单2***
        UIButton *tmpBtnMenuLocate = [[UIButton alloc] initWithFrame:CGRectMake(110, 100, 100, 42)];
        [tmpBtnMenuLocate setImage:[UIImage imageNamed:@"Route-Menu-pressed.png"] forState:UIControlStateHighlighted];
        tmpBtnMenuLocate.tag = 11;
        self.m_BtnMenuLocate = tmpBtnMenuLocate;
        SAFERELEASE(tmpBtnMenuLocate);
        [self addSubview:self.m_BtnMenuLocate];
        
        UIImageView *tmpIVMenuLocate = [[UIImageView alloc] initWithFrame:CGRectMake(130, 108, 25, 25)];
        tmpIVMenuLocate.image = [UIImage imageNamed:@"Route-Locate.png"];
        tmpIVMenuLocate.backgroundColor = [UIColor clearColor];
        self.m_IVMenuLocate = tmpIVMenuLocate;
        SAFERELEASE(tmpIVMenuLocate);
        [self addSubview:self.m_IVMenuLocate];
        
        UILabel *tmpLbMenuLocate = [[UILabel alloc] initWithFrame:CGRectMake(160, 113, 60, 17)];
        tmpLbMenuLocate.backgroundColor = [UIColor clearColor];
        tmpLbMenuLocate.textColor = [UIColor blackColor];
        tmpLbMenuLocate.font = [UIFont systemFontOfSize:13];
        tmpLbMenuLocate.textAlignment = UITextAlignmentLeft;
        tmpLbMenuLocate.text = [Language stringWithName:ROUTE_MENU_VIEW];
        self.m_LBMenuLocate = tmpLbMenuLocate;
        SAFERELEASE(tmpLbMenuLocate);
        [self addSubview:self.m_LBMenuLocate];
        //菜单2***
        
        //菜单3导航***
        UIButton *tmpBtnMenuNavigation = [[UIButton alloc] initWithFrame:CGRectMake(210, 100, 110, 42)];
        [tmpBtnMenuNavigation setImage:[UIImage imageNamed:@"Route-Menu-pressed.png"] forState:UIControlStateHighlighted];
        tmpBtnMenuNavigation.tag = 12;
        self.m_BtnMenuNavigation = tmpBtnMenuNavigation;
        SAFERELEASE(tmpBtnMenuNavigation);
        [self addSubview:self.m_BtnMenuNavigation];
        
        UIImageView *tmpIVMenuNavigation = [[UIImageView alloc] initWithFrame:CGRectMake(215, 108, 25, 25)];
        tmpIVMenuNavigation.image = [UIImage imageNamed:@"Route-Where.png"];
        tmpIVMenuNavigation.backgroundColor = [UIColor clearColor];
        self.m_IVMenuNavigation = tmpIVMenuNavigation;
        SAFERELEASE(tmpIVMenuNavigation);
        [self addSubview:self.m_IVMenuNavigation];
        
        UILabel *tmpLbMenuNavigation = [[UILabel alloc] initWithFrame:CGRectMake(245, 113, 60, 17)];
        tmpLbMenuNavigation.backgroundColor = [UIColor clearColor];
        tmpLbMenuNavigation.textColor = [UIColor blackColor];
        tmpLbMenuNavigation.font = [UIFont systemFontOfSize:13];
        tmpLbMenuNavigation.textAlignment = UITextAlignmentLeft;
        tmpLbMenuNavigation.text = [Language stringWithName:ROUTE_MENU_NAVIGATION];
        self.m_LBMenuNavigation = tmpLbMenuNavigation;
        SAFERELEASE(tmpLbMenuNavigation);
        [self addSubview:self.m_LBMenuNavigation];
        //菜单3导航***
        
        [self.m_BtnMenuDetail addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.m_BtnMenuLocate addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.m_BtnMenuNavigation addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];

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
    if(recomdCellDelgate && [recomdCellDelgate respondsToSelector:@selector(recomdLineCellAction:withIndex:)])
    {
        [recomdCellDelgate recomdLineCellAction:currentType withIndex:self.tag];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setMenuAlpha:(CGFloat)fAlpha
{
    IVBg.alpha = fAlpha;
    m_BtnMenuDetail.alpha = fAlpha;
    m_IVMenuDetail.alpha = fAlpha;
    m_LBMenuDetail.alpha = fAlpha;
    m_BtnMenuLocate.alpha = fAlpha;
    m_IVMenuLocate.alpha = fAlpha;
    m_LBMenuLocate.alpha = fAlpha;
    m_BtnMenuNavigation.alpha = fAlpha;
    m_IVMenuNavigation.alpha = fAlpha;
    m_LBMenuNavigation.alpha = fAlpha;
}

- (void)setBIsShow:(BOOL)bIsShow
{
    
    if(_bIsShow == bIsShow)
    {
        if(_bIsShow == NO)
        {
            [self setMenuAlpha:0.0f];
            downUpImgView.image = [UIImage imageNamed:@"Route-arrow-down.png"];
        }
        else
        {
            [self setMenuAlpha:1.0f];
            downUpImgView.image = [UIImage imageNamed:@"Route-arrow-up.png"];
        }
        return;
    }
    _bIsShow = bIsShow;
    if(bIsShow)
    {
        [self setMenuAlpha:0.0f];
        downUpImgView.image = [UIImage imageNamed:@"Route-arrow-up.png"];
    }
    else
    {
        [self setMenuAlpha:1.0f];
        downUpImgView.image = [UIImage imageNamed:@"Route-arrow-down.png"];
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
    SAFERELEASE(loadingView)
    SAFERELEASE(cellImgView)
    SAFERELEASE(cellRecomdImgView)
    SAFERELEASE(cellTitle)
    SAFERELEASE(cellContent)
    SAFERELEASE(disImgView)
    SAFERELEASE(disLabel)
    SAFERELEASE(disValueLabel)
    SAFERELEASE(disUnitLabel)
    SAFERELEASE(priceImgView)
    SAFERELEASE(priceLabel)
    SAFERELEASE(priceValueLabel)
    SAFERELEASE(priceUnitLabel)
    SAFERELEASE(downUpImgView)
    
    SAFERELEASE(IVBg);
    SAFERELEASE(m_IVLocation);
    
    SAFERELEASE(m_BtnMenuDetail);
    SAFERELEASE(m_LBMenuDetail);
    SAFERELEASE(m_IVMenuDetail);
    
    SAFERELEASE(m_BtnMenuLocate);
    SAFERELEASE(m_LBMenuLocate);
    SAFERELEASE(m_IVMenuLocate);
    
    SAFERELEASE(m_BtnMenuNavigation);
    SAFERELEASE(m_LBMenuNavigation);
    SAFERELEASE(m_IVMenuNavigation);
    
    [super dealloc];
}

@end
