//
//  NavigationView.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-10-10.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SOSViewController.h"
#import "RNExpandingButtonBar.h"
@interface NavigationLabelView : UIView
{
}
@property(nonatomic, retain) UILabel *targetLabel;
@property(nonatomic, retain) UILabel *nameLabel;
@property(nonatomic, retain) UILabel *disLabel;
@property(nonatomic, retain) UILabel *disUnitLabel;

@end


@protocol NavigationViewDelegate <NSObject>

-(void)navMenuAction:(int)index;

@end

@interface NavigationView : UIView
{
    IBOutlet UIButton *sosBtn;
    IBOutlet UIButton *closeBtn;
    IBOutlet UIButton *moreBtn;
    IBOutlet UIImageView *partLine1;
    IBOutlet UIImageView *partLine2;
    IBOutlet UIImageView *partLine3;
    IBOutlet UIImageView *partLine4;
    NavigationLabelView *naviLabelOne;
    NavigationLabelView *naviLabelTwo;
    RNExpandingButtonBar *navMenuBar;
    id<NavigationViewDelegate> delegate;
}
@property(nonatomic, assign) id<NavigationViewDelegate> delegate;
@property(nonatomic, retain) NavigationLabelView *naviLabelOne;
@property(nonatomic, retain) NavigationLabelView *naviLabelTwo;
@property(retain, nonatomic) IBOutlet UIImageView *directionImgView;
@property(retain, nonatomic) IBOutlet UILabel *disValueLabel;
@property(strong, nonatomic) RNExpandingButtonBar *navMenuBar;

+(NavigationView *)instanceNavigationView;
- (void)hideButtonsAnimated;
- (void)changeTarget:(NSString*)currentTarget;//当前目标的信息显示
- (void)changeDis:(double)targetDis TurnDis:(double)turnDis;//下一个目标的信息显示
- (void)changeDirections:(MAP_DIRECTION)orientation;
@end

