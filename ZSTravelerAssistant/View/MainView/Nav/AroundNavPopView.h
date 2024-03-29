//
//  CommonNavPopView.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-12.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AroundCell.h"
#import "AroundDetailTableCell.h"

@protocol AroundNavPopViewDelegate <NSObject>
-(void)aroundNavPopViewAction:(int)index withType:(int)type;
@end

@interface AroundNavPopView : UIView
{
    AroundCell *cell1;
    AroundCell *cell2;
    AroundCell *cell3;
    AroundCell *cell4;
    AroundCell *cell5;
    AroundCell *cell6;
    AroundCell *cell7;
    AroundCell *cell8;
    AroundCell *cell9;
    
    UIControl   *overlayView;
    int selectedIndex;
    
    id<AroundNavPopViewDelegate>    delegate;
}
@property (nonatomic, assign)    id<AroundNavPopViewDelegate>    delegate;

@property (retain, nonatomic) IBOutlet UIButton *searchAroundBtn;
@property (retain, nonatomic) IBOutlet UIButton *closestNavBtn;
@property (retain, nonatomic) IBOutlet UILabel *searchAroundLabel;
@property (retain, nonatomic) IBOutlet UILabel *closestNavLabel;

+(AroundNavPopView *)instanceSOSPopView;
- (void)dismiss;
- (void)show;
@end
