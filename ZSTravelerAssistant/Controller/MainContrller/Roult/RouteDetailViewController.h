//
//  RouteDetailViewController.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-5.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "GMScrollerView.h"
#import "SMPageControl.h"
#import "RouteNavPopView.h"
#import "TTSPlayer.h"
#import "ZS_CustomizedSpot_entity.h"
@interface RouteDetailViewController : BaseViewController<GMScrollerViewDelegate,TTSPlayerDelegate,UIScrollViewDelegate,RouteNavPopViewDelegate,HttpManagerDelegate>
{
    GMScrollerView  *gmScrollerView;
    SMPageControl   *pageControl;
    BOOL isSpeaking;
}
@property (retain, nonatomic) IBOutlet UIButton *speakBtn;
@property (retain, nonatomic) IBOutlet UIScrollView *mScrollerView;
@property (retain, nonatomic) IBOutlet UITextView *mTextView;
@property (retain, nonatomic) IBOutlet UILabel *mTour;
@property (retain, nonatomic) IBOutlet UILabel *mBack;
@property (retain, nonatomic) IBOutlet UILabel *mTitle;

@property (nonatomic, retain) NSArray   *data;//数据
@end
