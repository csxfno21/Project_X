//
//  InfoSubVIewDetail.m
//  ZSTravelerAssistant
//
//  Created by 梁谢超 on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "InfoSubVIewDetailController.h"
#import <QuartzCore/QuartzCore.h>

@interface InfoSubVIewDetailController ()

@end

@implementation InfoSubVIewDetailController

@synthesize m_IVIcon;
@synthesize m_LBHot;
@synthesize m_LBTitle;
@synthesize m_IVImg;
@synthesize m_TVContent;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //返回按钮
    [self.BtnBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.BtnBack setImage:[UIImage imageNamed:@"back-on.png"] forState:UIControlStateHighlighted];
    [self.BtnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //讲解按钮
    [self.BtnSpeak setImage:[UIImage imageNamed:@"speak.png"] forState:UIControlStateNormal];
    [self.BtnSpeak setImage:[UIImage imageNamed:@"speak-on.png"] forState:UIControlStateHighlighted];
    [self.BtnSpeak addTarget:self action:@selector(btnSpeakClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.LbSpeak.text = [Language stringWithName:EXPLAIN];
    
    //Hot 背景图片
    UIImageView *tmpIcon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 55, 25, 25)];
    [tmpIcon setImage:[[UIImage imageNamed:@"info-cell-hot.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    self.m_IVIcon = tmpIcon;
    SAFERELEASE(tmpIcon)
    [self.view addSubview:self.m_IVIcon];
    
    //Hot 文字
    UILabel *tmpLbHot = [[UILabel alloc]initWithFrame:CGRectMake(17, 50, 30, 30)];
    tmpLbHot.backgroundColor = [UIColor clearColor];
    tmpLbHot.textColor = [UIColor whiteColor];
    tmpLbHot.font = [UIFont systemFontOfSize:15];
    tmpLbHot.textAlignment = UITextAlignmentLeft;
    tmpLbHot.text = [Language stringWithName:INFO_CELL_HOT];
    self.m_LBHot = tmpLbHot;
    SAFERELEASE(tmpLbHot)
    [self.view addSubview:self.m_LBHot];
    
    //标题
    UILabel *tmpLbTitle = [[UILabel alloc]initWithFrame:CGRectMake(45, 58, 260, 20)];
    tmpLbTitle.backgroundColor = [UIColor clearColor];
    tmpLbTitle.textColor = [UIColor blackColor];
    tmpLbTitle.font = [UIFont systemFontOfSize:16];
    tmpLbTitle.textAlignment = UITextAlignmentLeft;
//    tmpLbTitle.text = @"寒春梅韵";
    self.m_LBTitle = tmpLbTitle;
    SAFERELEASE(tmpLbTitle);
    [self.view addSubview:self.m_LBTitle];
    
    //景点图片
    UIImageView *tmpImg = [[UIImageView alloc] initWithFrame:CGRectMake(14, 85, 292, 140)];
//    [tmpImg setImage:[[UIImage imageNamed:@"test.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    tmpImg.layer.masksToBounds = YES;
    tmpImg.layer.cornerRadius = 4.0f;
    self.m_IVImg = tmpImg;
    SAFERELEASE(tmpImg);
    [self.view addSubview:self.m_IVImg];
    
    //景点简介
    UITextView *tmpLbContent = [[UITextView alloc]initWithFrame:CGRectMake(5, 235, 314, 230)];
    if(iPhone5)tmpLbContent.frame = CGRectMake(5, 235, 314, self.view.frame.size.height - 235);
    tmpLbContent.backgroundColor = [UIColor clearColor];
    tmpLbContent.textColor = [UIColor blackColor];
    tmpLbContent.font = [UIFont systemFontOfSize:13];
    tmpLbContent.textAlignment = UITextAlignmentLeft;
    tmpLbContent.editable = NO;
//    tmpLbContent.text = @"    金秋虽不如百花绽放的春天，却也仍然拥有属于自己的美。无论是飘香的桂花，还是怒放的艳菊，都在灿烂的阳光下各展秀美。这不，近日中山陵园风景区灵谷景区的浓浓秋色，带动了南京许多中小学以及幼儿园的秋游热。小朋友在老师的带领下，手拉着手来到景区，刚进门口便被美丽的自然景色吸引，纷纷在老师的帮助下拍起美照来。";
    self.m_TVContent = tmpLbContent;
    SAFERELEASE(tmpLbContent);
    [self.view addSubview:self.m_TVContent];
    
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.frame = self.m_IVImg.frame;
    [self.view addSubview:loadingView];
    
    if (self.entity)
    {
        self.m_LBTitle.text = self.entity.InfoTitle;
        self.m_TVContent.text = self.entity.InfoContent;
        REQUEST_CMD_CODE ccmcode = CC_DOWN_IMAGE_SEASONINFO_BIG;
        if (self.entity.InfoType.intValue == 2)
        {
            ccmcode = CC_DOWN_IMAGE_REC_INFO_BIG;
        }
        UIImage *image = [[NetFileLoadManager sharedInstanced] loadImageByURL:self.entity.InfoImgUrl withDelegate:self withID:self.entity.ID withImgName:self.entity.InfoImgName withCmdcode:ccmcode];
        if(image)
        {
            [self.m_IVImg setImage:image];
        }
        else
        {
            [loadingView startAnimating];
        }
    }
}
#pragma mark- updateLanguage
- (void)updateLanguage:(id)sender
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnSpeakClick:(id)sender
{
    if(isSpeaking)
    {
        [[TTSPlayer shareInstance] pauseVideo];
        isSpeaking = NO;
        self.LbSpeak.text = [Language stringWithName:EXPLAIN];
    }
    else
    {
        self.LbSpeak.text = [Language stringWithName:STOP];
        isSpeaking = YES;
        
        if([TTSPlayer shareInstance].delegate == self)
        {
            [[TTSPlayer shareInstance] rePlayVideo];
        }
        else
        {
            self.BtnSpeak.enabled = NO;
            [[TTSPlayer shareInstance] stopVideo];
            [TTSPlayer shareInstance].delegate = self;
            [[TTSPlayer shareInstance] play:self.m_TVContent.text playMode:TTS_DEFAULT];
        }
    }
}

#pragma mark - ttsendCallBack
- (void)ttsPlayEnd
{
    self.LbSpeak.text = [Language stringWithName:EXPLAIN];
}
- (void)ttsPlayStart
{
    self.BtnSpeak.enabled = YES;
}

#pragma mark - calBack
- (void)callBackToUI:(HttpBaseResponse *)response
{
    switch (response.cc_cmd_code)
    {
        case CC_DOWN_IMAGE_REC_INFO_BIG:
        case CC_DOWN_IMAGE_SEASONINFO_BIG:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                DwonImgResponse *res = (DwonImgResponse*)response;
                if(self.entity.ID == res.imgID)
                {
                    UIImage *image = [[NetFileLoadManager sharedInstanced] loadImageByURL:self.entity.InfoImgUrl withDelegate:self withID:self.entity.ID withImgName:self.entity.InfoImgName withCmdcode:response.cc_cmd_code];
                    if(image)
                    {
                        [self.m_IVImg setImage:image];
                        [loadingView stopAnimating];
                    }
                }
            }
            break;
        }
        default:
            break;
    }
}
- (void)dealloc
{
    if([TTSPlayer shareInstance].delegate == self)
    {
        [[TTSPlayer shareInstance] stopVideo];
    }
    [[NetFileLoadManager sharedInstanced] cancelRequest:self];
    SAFERELEASE(loadingView)
    [_BtnBack release];
    SAFERELEASE(m_IVIcon);
    SAFERELEASE(m_LBHot);
    SAFERELEASE(m_LBTitle);
    SAFERELEASE(m_IVImg);
    SAFERELEASE(m_TVContent);
    SAFERELEASE(_BtnSpeak);
    [_LbSpeak release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnBack:nil];
    [self setBtnSpeak:nil];
    [self setLbSpeak:nil];
    [super viewDidUnload];
}
@end
