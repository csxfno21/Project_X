//
//  RootViewController.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-7-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "SMPageControl.h"
#import "MapManager.h"
@interface RootViewController : BaseViewController<UIScrollViewDelegate,HttpManagerDelegate,MapManagerDelegate>
{
    SMPageControl *pageControl;
    
    
}
@property (retain, nonatomic) IBOutlet UILabel *topTitle;

@property (retain, nonatomic) IBOutlet UIScrollView *mScrollView;
@property (retain, nonatomic) IBOutlet UIButton *infoBtn;
@property (retain, nonatomic) IBOutlet UIButton *routeBtn;
@property (retain, nonatomic) IBOutlet UIButton *navBtn;
@property (retain, nonatomic) IBOutlet UIButton *teamBtn;
@property (retain, nonatomic) IBOutlet UILabel *topLocationLabel;


@property (retain, nonatomic) IBOutlet UILabel *page_one_title;
@property (retain, nonatomic) IBOutlet UILabel *page_one_subtitle_one;
@property (retain, nonatomic) IBOutlet UILabel *page_one_subtitle_two;
@property (retain, nonatomic) IBOutlet UILabel *page_two_title;
@property (retain, nonatomic) IBOutlet UILabel *page_two_subtitle_one;
@property (retain, nonatomic) IBOutlet UILabel *page_two_subtitle_two;
@property (retain, nonatomic) IBOutlet UILabel *page_three_title;
@property (retain, nonatomic) IBOutlet UILabel *page_three_subtitle_one;
@property (retain, nonatomic) IBOutlet UILabel *page_three_subtitle_two;
@property (retain, nonatomic) IBOutlet UILabel *page_four_title;
@property (retain, nonatomic) IBOutlet UILabel *page_four_subtitle_one;
@property (retain, nonatomic) IBOutlet UILabel *page_four_subtitle_two;
@end
