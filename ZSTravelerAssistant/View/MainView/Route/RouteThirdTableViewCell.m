//
//  RouteTableViewCell.m
//  ZSTravelerAssistant
//
//  Created by 梁谢超 on 13-7-27.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "RouteThirdTableViewCell.h"

@implementation RouteThirdTableViewCell

@synthesize m_IVHead;
@synthesize m_LbTitle;
@synthesize m_IVStar;
@synthesize m_IVDis;
@synthesize m_LbDisText;
@synthesize m_LbDisNum;
@synthesize m_LBDisUnit;
@synthesize m_IVPrice;
@synthesize m_LbPricetext;
@synthesize m_LbPriceNum;
@synthesize m_LbPriceUnit;
@synthesize m_IVArrow;
@synthesize m_AddButton;
@synthesize m_IVMenuBg;
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
@synthesize cellDelgate;
@synthesize loadingView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        int y = -15;
        int x = -10;
        self.backgroundColor = [UIColor clearColor];
        
        //景区图片
        UIImageView *tmpHeadImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 70, 70)];
        self.m_IVHead = tmpHeadImg;
        SAFERELEASE(tmpHeadImg);
        [self addSubview:self.m_IVHead];
        
        UIActivityIndicatorView *tloadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        tloadingView.frame = self.m_IVHead.frame;
        self.loadingView = tloadingView;
        [self addSubview:self.loadingView];
        SAFERELEASE(tloadingView)
        
        //景区名称
        UILabel *tmpLbTitle = [[UILabel alloc] initWithFrame:CGRectMake(100 + x, 18, 150, 17)];
        tmpLbTitle.backgroundColor = [UIColor clearColor];
        tmpLbTitle.textColor = [UIColor blueColor];
        tmpLbTitle.font = [UIFont boldSystemFontOfSize:17];
        tmpLbTitle.textAlignment = UITextAlignmentLeft;
        self.m_LbTitle = tmpLbTitle;
        SAFERELEASE(tmpLbTitle);
        [self addSubview:self.m_LbTitle];
        
        //星级图片
        UIImageView *tmpIVStar = [[UIImageView alloc] initWithFrame:CGRectMake(100 + x, 41, 88, 18)];
        tmpIVStar.backgroundColor = [UIColor clearColor];
        self.m_IVStar = tmpIVStar;
        SAFERELEASE(tmpIVStar);
        [self addSubview:self.m_IVStar];
        
        //距离图片
        UIImageView *tmpIVDis = [[UIImageView alloc] initWithFrame:CGRectMake(100 + x, 80 + y, 18, 18)];
        tmpIVDis.image = [UIImage imageNamed:@"Route-dis.png"];
        tmpIVDis.backgroundColor = [UIColor clearColor];
        self.m_IVDis = tmpIVDis;
        SAFERELEASE(tmpIVDis);
        [self addSubview:self.m_IVDis];
        
        //距离文字“距离”
        UILabel *tmpLbDisNum = [[UILabel alloc] initWithFrame:CGRectMake(128 + x - 7, 80 + y, 40, 20)];
        tmpLbDisNum.backgroundColor = [UIColor clearColor];
        tmpLbDisNum.textColor = [UIColor blackColor];
        tmpLbDisNum.text = [Language stringWithName:DISTANCE];
        tmpLbDisNum.font = [UIFont systemFontOfSize:13];
        tmpLbDisNum.textAlignment = UITextAlignmentLeft;
        self.m_LbDisText = tmpLbDisNum;
        SAFERELEASE(tmpLbDisNum);
        [self addSubview:self.m_LbDisText];
        
        //距离数字“XX”
        UILabel *tmpLbDis = [[UILabel alloc] initWithFrame:CGRectMake(140 + x - 7, 80 + y, 70, 20)];
        tmpLbDis.backgroundColor = [UIColor clearColor];
        tmpLbDis.textColor = [UIColor orangeColor];
        tmpLbDis.font = [UIFont systemFontOfSize:17];
        tmpLbDis.textAlignment = UITextAlignmentCenter;
        self.m_LbDisNum = tmpLbDis;
        SAFERELEASE(tmpLbDis);
        [self addSubview:self.m_LbDisNum];
        
        //距离数字“m”
        UILabel *tmpLbDisUnit = [[UILabel alloc] initWithFrame:CGRectMake(199 + x - 12, 83 + y, 20, 15)];
        tmpLbDisUnit.backgroundColor = [UIColor clearColor];
        tmpLbDisUnit.textColor = [UIColor orangeColor];
        tmpLbDisUnit.font = [UIFont systemFontOfSize:13];
        tmpLbDisUnit.textAlignment = UITextAlignmentLeft;
        tmpLbDisUnit.text = [Language stringWithName:DISTANCE_M];
        self.m_LBDisUnit = tmpLbDisUnit;
        SAFERELEASE(tmpLbDisUnit);
        [self addSubview:self.m_LBDisUnit];
        
        //价格图片
        UIImageView *tmpIVPrice = [[UIImageView alloc] initWithFrame:CGRectMake(215 + x - 10, 79 + y, 20, 20)];
        tmpIVPrice.image = [UIImage imageNamed:@"Route-Price.png"];
        tmpIVPrice.backgroundColor = [UIColor clearColor];
        self.m_IVPrice = tmpIVPrice;
        SAFERELEASE(tmpIVPrice);
        [self addSubview:self.m_IVPrice];
        
        //价格文字”价格“
        UILabel *tmpLbPriceText = [[UILabel alloc] initWithFrame:CGRectMake(237 + x - 8, 83 + y, 30, 15)];
        tmpLbPriceText.backgroundColor = [UIColor clearColor];
        tmpLbPriceText.textColor = [UIColor blackColor];
        tmpLbPriceText.font = [UIFont systemFontOfSize:13];
        tmpLbPriceText.text = [Language stringWithName:PRICE];
        tmpLbPriceText.textAlignment = UITextAlignmentLeft;
        self.m_LbPricetext = tmpLbPriceText;
        SAFERELEASE(tmpLbPriceText);
        [self addSubview:self.m_LbPricetext];
        
        //价格数字”xx“ 231
        UILabel *tmpLbPrice = [[UILabel alloc] initWithFrame:CGRectMake(270 + x - 10, 80 + y, 30, 20)];
        tmpLbPrice.backgroundColor = [UIColor clearColor];
        tmpLbPrice.textColor = [UIColor orangeColor];
        tmpLbPrice.font = [UIFont systemFontOfSize:17];
        tmpLbPrice.textAlignment = UITextAlignmentCenter;
        self.m_LbPriceNum = tmpLbPrice;
        SAFERELEASE(tmpLbPrice);
        [self addSubview:self.m_LbPriceNum];
        
        //价格数字”元“
        UILabel *tmpLbPriceUnit = [[UILabel alloc] initWithFrame:CGRectMake(293 + x - 11, 83 + y, 20, 15)];
        tmpLbPriceUnit.backgroundColor = [UIColor clearColor];
        tmpLbPriceUnit.textColor = [UIColor orangeColor];
        tmpLbPriceUnit.font = [UIFont systemFontOfSize:13];
        tmpLbPriceUnit.textAlignment = UITextAlignmentLeft;
        tmpLbPriceUnit.text = [Language stringWithName:YUAN];
        self.m_LbPriceUnit = tmpLbPriceUnit;
        SAFERELEASE(tmpLbPriceUnit);
        [self addSubview:self.m_LbPriceUnit];
        
        UIImageView *tmpIVArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 40, 20, 20)];
        tmpIVArrow.image = [UIImage imageNamed:@"Route-arrow-down.png"];
        tmpIVArrow.backgroundColor = [UIColor clearColor];
        self.m_IVArrow = tmpIVArrow;
        SAFERELEASE(tmpIVArrow);
        [self addSubview:self.m_IVArrow];
        
        
        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(260, 30, 45, 30)];
        [addButton setTitle:[Language stringWithName:ADD] forState:UIControlStateNormal];
        addButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [addButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        addButton.hidden = YES;
        [addButton setBackgroundImage:[[UIImage imageNamed:@"add_item_bg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
        [addButton setBackgroundImage:[[UIImage imageNamed:@"add_item_bg-on.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
        [addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
        self.m_AddButton = addButton;
        SAFERELEASE(addButton)
        [self addSubview:self.m_AddButton];
        
        //点击菜单背景图片
        UIImageView *tmpIVMenuBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 42)];
        tmpIVMenuBg.image = [UIImage imageNamed:@"Route-Menu-bg.png"];
        tmpIVMenuBg.backgroundColor = [UIColor clearColor];
        self.m_IVMenuBg = tmpIVMenuBg;
        SAFERELEASE(tmpIVMenuBg);
        [self addSubview:self.m_IVMenuBg];
        
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
        tmpLbMenuLocate.text = [Language stringWithName:ROUTE_MENU_LOCATION];
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
- (void)addAction:(id)sender
{
    int index = self.tag;
    if(cellDelgate && [cellDelgate respondsToSelector:@selector(routeThirdTableViewAdd:)])
    {
        [cellDelgate routeThirdTableViewAdd:index];
    }
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
    if(cellDelgate && [cellDelgate respondsToSelector:@selector(routeThirdTableViewCellAction:withIndex:)])
    {
        [cellDelgate routeThirdTableViewCellAction:currentType withIndex:self.tag];
    }
}
- (void)setMenuAlpha:(CGFloat)fAlpha
{
//    if(fAlpha == 0.0f)
//    {
//        m_IVMenuBg.frame = CGRectMake(m_IVMenuBg.frame.origin.x, m_IVMenuBg.frame.origin.y, 320, 0);
//    }
//    else
//    {
//        m_IVMenuBg.frame = CGRectMake(m_IVMenuBg.frame.origin.x, m_IVMenuBg.frame.origin.y, 320, 142);
//    }
    m_IVMenuBg.alpha = fAlpha;
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
            m_IVArrow.image = [UIImage imageNamed:@"Route-arrow-down.png"];
        }
        else
        {
            [self setMenuAlpha:1.0f];
            m_IVArrow.image = [UIImage imageNamed:@"Route-arrow-up.png"];
        }
        return;
    }
    _bIsShow = bIsShow;
    if(bIsShow)
    {
        [self setMenuAlpha:0.0f];
        m_IVArrow.image = [UIImage imageNamed:@"Route-arrow-up.png"];
    }
    else
    {
        [self setMenuAlpha:1.0f];
        m_IVArrow.image = [UIImage imageNamed:@"Route-arrow-down.png"];
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

- (void)dealloc
{
    cellDelgate = nil;
    _bIsShow = NO;
    SAFERELEASE(m_AddButton)
    SAFERELEASE(loadingView)
    SAFERELEASE(m_IVHead);
    SAFERELEASE(m_LbTitle);
    SAFERELEASE(m_IVStar);
    SAFERELEASE(m_IVDis);
    SAFERELEASE(m_LbDisText);
    SAFERELEASE(m_LbDisNum);
    SAFERELEASE(m_LBDisUnit);
    SAFERELEASE(m_IVPrice);
    SAFERELEASE(m_LbPricetext);
    SAFERELEASE(m_LbPriceNum);
    SAFERELEASE(m_LbPriceUnit);
    SAFERELEASE(m_IVArrow);
    SAFERELEASE(m_IVMenuBg);
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
