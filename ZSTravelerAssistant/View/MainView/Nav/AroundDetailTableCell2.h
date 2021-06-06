//
//  AroundDetailTableCell2.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-21.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AroundDetailCell.h"
#import "RouteThirdTableViewCell.h"

@protocol AroundDetailTableCellTwoDelegate <NSObject>
- (void)aroundTableViewCellTwoAction:(ROUTE_MENU_TYPE)menuType withIndex:(int)index;
@end
@interface AroundDetailTableCell2 : UITableViewCell
{
    UIImageView *typeImgView;
    UILabel     *titleLabel;
    UILabel     *disLabel;
    UILabel     *contentLabel;
    UILabel     *bottomLabel;
    AroundDetailCell *cell1;
    AroundDetailCell *cell2;
    AroundDetailCell *cell3;
    UIImageView *downUpArrowImgView;
    id<AroundDetailTableCellTwoDelegate>    aroun2Delegate;
}
@property (nonatomic, assign)    id<AroundDetailTableCellTwoDelegate>    aroun2Delegate;
@property (nonatomic, retain)    UIImageView *typeImgView;
@property (nonatomic, retain)    UILabel     *titleLabel;
@property (nonatomic, retain)    UILabel     *disLabel;
@property (nonatomic, retain)    UILabel     *contentLabel;
@property (nonatomic, retain)    UILabel     *bottomLabel;
@property (nonatomic, retain)    AroundDetailCell *cell1;
@property (nonatomic, retain)    AroundDetailCell *cell2;
@property (nonatomic, retain)    AroundDetailCell *cell3;
@property (nonatomic, retain)    UIImageView *downUpArrowImgView;
@property(assign, nonatomic)BOOL bIsShow;
@end
