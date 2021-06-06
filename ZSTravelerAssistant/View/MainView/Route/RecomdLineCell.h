//
//  RecomdLineCell.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-1.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RouteThirdTableView.h"
@protocol RecomdLineCellDelegate <NSObject>
- (void)recomdLineCellAction:(ROUTE_MENU_TYPE)menuType withIndex:(int)index;
@end

@interface RecomdLineCell : UITableViewCell
{
    UIActivityIndicatorView *loadingView;
    UIImageView *cellImgView;
    UIImageView *cellRecomdImgView;
    UILabel     *cellTitle;
    UILabel     *cellContent;
    UIImageView *disImgView;
    UILabel     *disLabel;
    UILabel     *disValueLabel;
    UILabel     *disUnitLabel;  //距离计量单位
    UIImageView *priceImgView;
    UILabel     *priceLabel;
    UILabel     *priceValueLabel;
    UILabel     *priceUnitLabel;//货币计量单位
    //下拉
    UIImageView *downUpImgView;
    
    UIImageView *IVBg;
    
    UIImageView *m_IVLocation;
    UIButton *m_BtnMenuDetail;
    UIImageView *m_IVMenuDetail;
    UILabel *m_LBMenuDetail;
    UIButton *m_BtnMenuLocate;
    UIImageView *m_IVMenuLocate;
    UILabel *m_LBMenuLocate;
    UIButton *m_BtnMenuNavigation;
    UIImageView *m_IVMenuNavigation;
    UILabel *m_LBMenuNavigation;

    id<RecomdLineCellDelegate> recomdCellDelgate;
}
@property(nonatomic,assign)    id<RecomdLineCellDelegate> recomdCellDelgate;
@property(retain,nonatomic)     UIActivityIndicatorView *loadingView;
@property(nonatomic, retain)    UIImageView *cellImgView;
@property(nonatomic, retain)    UIImageView *cellRecomdImgView;
@property(nonatomic, retain)    UILabel     *cellTitle;
@property(nonatomic, retain)    UILabel     *cellContent;
@property(nonatomic, retain)    UIImageView *disImgView;
@property(nonatomic, retain)    UILabel     *disLabel;
@property(nonatomic, retain)    UILabel     *disValueLabel;
@property(nonatomic, retain)    UILabel     *disUnitLabel;
@property(nonatomic, retain)    UIImageView *priceImgView;
@property(nonatomic, retain)    UILabel     *priceLabel;
@property(nonatomic, retain)    UILabel     *priceValueLabel;
@property(nonatomic, retain)    UILabel     *priceUnitLabel;
@property(nonatomic, retain)    UIImageView *downUpImgView;

@property(nonatomic, retain) UIImageView *IVBg;
@property(assign, nonatomic)BOOL bIsShow;

@property(retain, nonatomic)UIImageView *m_IVLocation;
@property(retain, nonatomic)UIButton *m_BtnMenuDetail;
@property(retain, nonatomic)UIImageView *m_IVMenuDetail;
@property(retain, nonatomic)UILabel *m_LBMenuDetail;
@property(retain, nonatomic)UIButton *m_BtnMenuLocate;
@property(retain, nonatomic)UIImageView *m_IVMenuLocate;
@property(retain, nonatomic)UILabel *m_LBMenuLocate;
@property(retain, nonatomic)UIButton *m_BtnMenuNavigation;
@property(retain, nonatomic)UIImageView *m_IVMenuNavigation;
@property(retain, nonatomic)UILabel *m_LBMenuNavigation;

@end
