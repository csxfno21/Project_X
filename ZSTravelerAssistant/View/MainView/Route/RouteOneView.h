//
//  RouteOneView.h
//  ZSTravelerAssistant
//
//  Created by 梁谢超 on 13-8-5.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RouteOneViewDelegate <NSObject>

- (void)routeOneViewAction;

@end
@interface RouteOneView : UIView
{
    UIImageView *m_IVBg;
    UIButton *m_BtnStart;
    UILabel *m_LbBtn;
    id<RouteOneViewDelegate> delegate;
}

@property(assign,nonatomic)id<RouteOneViewDelegate> delegate;
@property(retain, nonatomic)UIImageView *m_IVBg;
@property(retain, nonatomic)UIButton *m_BtnStart;
@property(retain, nonatomic)UILabel *m_LbBtn;
@end
