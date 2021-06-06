//
//  AroundDetailViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-13.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "AroundDetailTableCell.h"
#import "MyNavController.h"
#import "RouteNavPopView.h"

@interface AroundDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,AroundDetailTableCellDelegate,RouteNavPopViewDelegate>
{
    NSArray *titleArray;
    NSArray *picArray;
    NSInteger openIndex;
    ZS_CommonNav_entity* selectEntity;

}
@property (retain, nonatomic) NSArray *data;
@property (assign, nonatomic) int index;
@property (retain, nonatomic) NSArray *titleArray;
@property (retain, nonatomic) NSArray *picArray;
@property (retain, nonatomic) IBOutlet UIImageView *topTitleImgView;
@property (retain, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property (retain, nonatomic) IBOutlet UITableView *mTableView;
//@property (nonatomic, retain) NSIndexPath *selectedtIndex;


@end
