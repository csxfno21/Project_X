//
//  NavigationPopMoreView.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-10-11.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AroundCell.h"

@protocol NavigationPopMoreViewDelegate <NSObject>

-(void)morePopAction:(int)index;

@end

@interface NavigationPopMoreView : UIView
{
    UIControl *overlayView;
    id<NavigationPopMoreViewDelegate> delegate;
    UILabel *titleLabel;
    AroundCell *cell1;
    AroundCell *cell2;
    AroundCell *cell3;
    AroundCell *cell4;
    AroundCell *cell5;
    AroundCell *cell6;
}
@property(nonatomic, assign) id<NavigationPopMoreViewDelegate> delegate;

+(NavigationPopMoreView*)instancePopMoreView;
-(void)dismiss;
-(void)show;

@end
