//
//  SetViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-9.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "SetTableViewCell.h"
#import "AboutUsViewController.h"

@interface SetViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SetTableViewCellDelegate>
{
    NSDictionary *dictionary;
}

@property (retain, nonatomic) IBOutlet UIImageView *topTitleImgView;
@property (retain, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;

@property (retain, nonatomic) IBOutlet UITableView *mTableView;
@end
