//
//  SpotDetailViewController.h
//  ZSTravelerAssistant
//
//  Created by 梁谢超 on 13-8-1.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "TTSPlayer.h"
#import "RouteNavPopView.h"
@interface SpotDetailViewController : BaseViewController<TTSPlayerDelegate,RouteNavPopViewDelegate,HttpManagerDelegate>
{
    BOOL isSpeaking;
    UIActivityIndicatorView *loadingView;
}
@property (retain, nonatomic) ZS_CustomizedSpot_entity *spotEntity;
@property (retain, nonatomic) IBOutlet UILabel *LbSpotName;//景点名称
@property (retain, nonatomic) IBOutlet UILabel *LbTourist;//导游lable
@property (retain, nonatomic) IBOutlet UIButton *BtnTourist;//导游按钮
@property (retain, nonatomic) IBOutlet UIButton *BtnSpeak;//讲解按钮
@property (retain, nonatomic) IBOutlet UILabel *LbBack;//返回lable
@property (retain, nonatomic) IBOutlet UIButton *BtnBack;//返回按钮
@property (retain, nonatomic) IBOutlet UIImageView *IVBg;//背景图片
@property (retain, nonatomic) IBOutlet UIImageView *IVSpotImg;//景点图片
@property (retain, nonatomic) IBOutlet UILabel *LbBrief;//简介lable
@property (retain, nonatomic) IBOutlet UITextView *TXSpotContent;//景点详细介绍
@property (retain, nonatomic) IBOutlet UILabel *LbTouristDistance;//景区行程lable
@property (retain, nonatomic) IBOutlet UILabel *disValueLabel;

@end
