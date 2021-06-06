//
//  InfoLineViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-30.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "ZS_Traffic_entity.h"
#import "InfoLinestateCell.h"
@interface InfoLineViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UIImageView *explaBg;
    UILabel     *explaContentLabel;
    UILabel     *explaLabel;

    UILabel     *lineMarkLabel;
    UILabel     *lineExplaLabel;

    NSMutableArray     *arrayFromString;
    
    IBOutlet UIScrollView *m_ScrollView;
    IBOutlet UITableView *m_InfoLinestateTableView;
}
@property (retain, nonatomic) ZS_Traffic_entity *entity;
@property (retain, nonatomic) IBOutlet UIImageView *topImgView;
@property (retain, nonatomic) IBOutlet UILabel *topTitle;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property (retain, nonatomic) IBOutlet UIImageView *lineContent;
@property (retain, nonatomic) IBOutlet UILabel *lineLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UILabel *startptnLabel;
@property (retain, nonatomic) IBOutlet UILabel *endptnLabel;
@property (retain, nonatomic) IBOutlet UILabel *ticketLabel;
@property (retain, nonatomic) IBOutlet UILabel *moneyLabel;
@property (retain, nonatomic) IBOutlet UILabel *runtimeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *goAndBackImgView;


@end
