//
//  AroundDetailTwoViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-21.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "AroundDetailTableCell2.h"
#import "MyNavController.h"
#import "DetialViewController.h"
#import "RouteNavPopView.h"

@interface AroundDetailTwoViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AroundDetailTableCellTwoDelegate,RouteNavPopViewDelegate>
{
    NSInteger openIndex;
    ZS_CommonNav_entity* selectEntity;
}
@property (retain, nonatomic) NSArray *data;
@property (retain, nonatomic) IBOutlet UIImageView *topTitleImgView;
@property (retain, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property (retain, nonatomic) IBOutlet UITableView *mTableView;

@end
