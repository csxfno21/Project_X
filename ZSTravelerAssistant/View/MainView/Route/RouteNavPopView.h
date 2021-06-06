//
//  RouteNavPopView.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-5.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RouteNavPopViewDelegate <NSObject>

- (void)routeNavAction:(int)index withType:(int)type;

@end
@interface RouteNavPopView : UIView
{
    UIControl  *overlayView;
    id<RouteNavPopViewDelegate> delegate;
    int selectedIndex;
}
@property (assign, nonatomic) id<RouteNavPopViewDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *goLabel;
@property (retain, nonatomic) IBOutlet UILabel *locationLabel1;
@property (retain, nonatomic) IBOutlet UILabel *parkingLabel;
@property (retain, nonatomic) IBOutlet UILabel *entryLabel1;
@property (retain, nonatomic) IBOutlet UILabel *locationLabel2;
@property (retain, nonatomic) IBOutlet UILabel *parkingLabel2;
@property (retain, nonatomic) IBOutlet UILabel *entryLabel2;
@property (retain, nonatomic) IBOutlet UILabel *locationLabel3;
@property (retain, nonatomic) IBOutlet UILabel *entryLabel3;
@property (retain, nonatomic) IBOutlet UIButton *realTravelBtn;
@property (retain, nonatomic) IBOutlet UIButton *simulateBtn;
@property (retain, nonatomic) IBOutlet UIButton *cancleBtn;
@property (retain, nonatomic) IBOutlet UIButton *choseBtn1;
@property (retain, nonatomic) IBOutlet UIButton *choseBtn2;
@property (retain, nonatomic) IBOutlet UIButton *choseBtn3;
@property (retain, nonatomic) IBOutlet UILabel *l1;
@property (retain, nonatomic) IBOutlet UILabel *l2;



+ (RouteNavPopView *)instanceRouteNavPopView;
- (void)show;
- (void)dismiss;
- (void)setTitleText:(NSString*)title;
- (void)selectSecond;
@end
