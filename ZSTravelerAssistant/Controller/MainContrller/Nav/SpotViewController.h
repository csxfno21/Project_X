//
//  SpotViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-15.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "RouteThirdTableView.h"
#import "RouteNavPopView.h"
#import "RecomdLineTableView.h"
#import "SpotDetailViewController.h"
#import "RouteOneView.h"
#import "RouteDetailViewController.h"


@interface SpotViewController : BaseViewController<RouteThirdTableViewDlegate,RouteNavPopViewDelegate,RouteOneViewDelegate,UIActionSheetDelegate>
{
    NSMutableDictionary *spotDic;
    SCENIC_TYPE selectedType;
    ZS_CustomizedSpot_entity* spotData;
}
@property (retain, nonatomic) IBOutlet UIButton *topTitle;
@property (retain, nonatomic) IBOutlet UIImageView *topTitleImgView;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property (retain, nonatomic) RouteThirdTableView *mTableView;

@end
