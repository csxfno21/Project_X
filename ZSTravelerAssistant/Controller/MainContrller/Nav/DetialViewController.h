//
//  ShopDetialViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-21.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"

@interface DetialViewController : BaseViewController<HttpManagerDelegate>

@property (retain, nonatomic) ZS_CommonNav_entity *entity;
@property (retain, nonatomic) IBOutlet UIImageView *topTitleImgView;
@property (retain, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property (retain, nonatomic) IBOutlet UIImageView *techanImgView;
@property (retain, nonatomic) IBOutlet UILabel *techanLabel;
@property (retain, nonatomic) IBOutlet UIImageView *smallTechanImgView;
@property (retain, nonatomic) IBOutlet UILabel *smallTechanLabel;
@property (retain, nonatomic) IBOutlet UIImageView *separateLineImgViewOne;
@property (retain, nonatomic) IBOutlet UIImageView *separateLineImgViewTwo;
@property (retain, nonatomic) IBOutlet UIImageView *separateLineImgViewThree;
@property (retain, nonatomic) IBOutlet UIImageView *locationImgView;
@property (retain, nonatomic) IBOutlet UILabel *locationLabel;
@property (retain, nonatomic) IBOutlet UILabel *manageLabel;
@property (retain, nonatomic) IBOutlet UILabel *rangeLabel;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImgview1;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImgview2;
@property (retain, nonatomic) IBOutlet UIImageView *backgroundImgview3;

@end
