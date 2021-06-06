//
//  RouteSelfChoseSpotCell.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "GMGridViewCell.h"
#import "RouteThirdTableViewCell.h"

@protocol RouteSelfChoseSpotCellDelegate <NSObject>
- (void)routeSelfChoseCellAction:(ROUTE_MENU_TYPE)menuType withIndex:(int)index;
@end


@interface RouteSelfChoseSpotCell : GMGridViewCell
{
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

    
    id<RouteSelfChoseSpotCellDelegate> delegate;
    UIActivityIndicatorView *loadingView;
}
@property(retain, nonatomic)UIActivityIndicatorView *loadingView;
@property(nonatomic, assign)    id<RouteSelfChoseSpotCellDelegate> delegate;
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

@end
