//
//  InfoSubVIewDetail.h
//  ZSTravelerAssistant
//
//  Created by 梁谢超 on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "TTSPlayer.h"
#import "ZS_Infomation_entity.h"
#import "HttpManagerCenter.h"
@interface InfoSubVIewDetailController : BaseViewController<TTSPlayerDelegate,HttpManagerDelegate>
{
    BOOL  isSpeaking;
    UIActivityIndicatorView *loadingView;
}
@property (retain,nonatomic)  ZS_Infomation_entity *entity;
@property (retain, nonatomic) IBOutlet UIButton *BtnBack;
@property (retain, nonatomic) IBOutlet UIButton *BtnSpeak;
@property (retain, nonatomic) IBOutlet UILabel *LbSpeak;

@property (retain, nonatomic) UIImageView *m_IVIcon;
@property (retain, nonatomic) UILabel *m_LBHot;
@property (retain, nonatomic) UILabel *m_LBTitle;
@property (retain, nonatomic) UIImageView *m_IVImg;
@property (retain, nonatomic) UITextView *m_TVContent;

@end
