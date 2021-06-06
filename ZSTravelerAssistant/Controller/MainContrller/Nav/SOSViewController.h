//
//  SOSViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-7.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "SOSTableViewCell.h"
#import "SOSPopView.h"
#import "TeamManager.h"

typedef enum
{
    ALARM_TYPE_INJURED = 1000,
    ALARM_TYPE_STOLEN ,
    ALARM_TYPE_DISPUTE,
    ALARM_TYPE_DISMISS,
    ALARM_TYPE_SINK,
    ALARM_TYPE_OTHERS,
}ALARM_TYPE;


@interface SOSViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SOSTableViewCellDelegate,UIAlertViewDelegate,SOSPopViewDelegate,TeamManagerDelegate>
{
    NSDictionary    *dictionary;
    NSArray         *titleArray;
}
@property (retain, nonatomic) NSArray  *titileArray;
@property (retain, nonatomic) IBOutlet UIImageView *topImgView;
@property (retain, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property (retain, nonatomic) IBOutlet UITableView *mTableView;
@end
