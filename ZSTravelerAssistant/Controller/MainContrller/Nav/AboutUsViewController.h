//
//  AboutUsViewController.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-10.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"

@interface AboutUsViewController : BaseViewController
{
   
}
@property (retain, nonatomic) IBOutlet UIImageView *topTitleImgView;
@property (retain, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *backBtn;
@property (retain, nonatomic) IBOutlet UILabel *backLabel;
@property (retain, nonatomic) IBOutlet UILabel *middleZSLabel;
@property (retain, nonatomic) IBOutlet UILabel *IphoneVersionLabel;
@property (retain, nonatomic) IBOutlet UILabel *bottomZSLabel;
@property (retain, nonatomic) IBOutlet UILabel *connectLabel;
@property (retain, nonatomic) IBOutlet UILabel *copiesRightLabel;
@property (retain, nonatomic) IBOutlet UIImageView *lineImgView;

@end
