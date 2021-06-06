//
//  SpotDetailViewController.m
//  ZSTravelerAssistant
//
//  Created by 梁谢超 on 13-8-1.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "SpotDetailViewController.h"

#define SPOT_NAME_LABLE_TO_LEFT 58
#define SPOT_NAME_LABLE_TO_RIGHT 257
//

@interface SpotDetailViewController ()

@end

@implementation SpotDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.IVSpotImg.layer.masksToBounds = YES;
    self.IVSpotImg.layer.cornerRadius = 4.0f;
    
    self.LbTourist.text = [Language stringWithName:TOURIST];
    self.LbBack.text = [Language stringWithName:BACK];
    self.LbBrief.text = [Language stringWithName:EXPLAIN];
    self.LbTouristDistance.text = [Language stringWithName:ROUTE_TOURISTDISTANCE];
    
    [self.BtnBack setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.BtnBack setImage:[UIImage imageNamed:@"back-on.png"] forState:UIControlStateHighlighted];
    [self.BtnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BtnTourist setImage:[UIImage imageNamed:@"speak.png"] forState:UIControlStateNormal];
    [self.BtnTourist setImage:[UIImage imageNamed:@"speak-on.png"] forState:UIControlStateHighlighted];
    [self.BtnTourist addTarget:self action:@selector(btnTouristClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.BtnSpeak setImage:[UIImage imageNamed:@"Route-voice-on.png"] forState:UIControlStateNormal];
    [self.BtnSpeak addTarget:self action:@selector(btnVoiceClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.TXSpotContent setFrame:CGRectMake(15, 290, 273,  self.view.frame.size.height-290)];
    
    self.TXSpotContent.editable = NO;
    loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingView.frame = self.IVSpotImg.frame;
    [self.view addSubview:loadingView];
    if(self.spotEntity)
    {
        self.LbSpotName.frame = CGRectMake(SPOT_NAME_LABLE_TO_LEFT, 0, SPOT_NAME_LABLE_TO_RIGHT - SPOT_NAME_LABLE_TO_LEFT, 44);
        
        self.TXSpotContent.text = self.spotEntity.SpotContent;
        self.LbSpotName.text = self.spotEntity.SpotName;
        if (self.spotEntity.SpotLength && self.spotEntity.SpotLength.length > 0)
        {
            self.disValueLabel.text = [NSString stringWithFormat:@"%@km",self.spotEntity.SpotLength];
        }
        else
        {
            self.disValueLabel.hidden = YES;
            self.LbTouristDistance.hidden = YES;
        }

        UIImage *image = [[NetFileLoadManager sharedInstanced] loadImageByURL:self.spotEntity.SpotImgUrl withDelegate:self withID:self.spotEntity.ID withImgName:self.spotEntity.SpotImgName withCmdcode:CC_DOWN_IMAGE_SPOT];
        if(image)
        {
            [self.IVSpotImg setImage:image];
        }
        else
        {
            [loadingView startAnimating];
        }     
    }
    
}

- (void)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)btnTouristClick:(id)sender
{
    if(self.spotEntity)
    {
        CGFloat xWidth = self.view.bounds.size.width - 30.0f;
        CGFloat yHeight = 300.0f;
        CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
        RouteNavPopView *popView = [RouteNavPopView instanceRouteNavPopView];
        popView.frame = CGRectMake(15, yOffset, xWidth, yHeight);
        [popView setTitleText:self.spotEntity.SpotName];
        popView.delegate = self;
        [popView show];
    }
}

#pragma mark - popViewDelegate
- (void)routeNavAction:(int)index withType:(int)type
{
    BOOL isSimulation = type;
    NAV_TYPE nav_type = (NAV_TYPE)index;
    
    PoiPoint *poiPoint = [PoiPoint pointWithName:self.spotEntity.SpotName withLongitude:self.spotEntity.SpotLng.doubleValue withLatitude:self.spotEntity.SpotLat.doubleValue withPoiID:self.spotEntity.SpotID.intValue];
    [[MapManager sharedInstanced] startNavByOne:poiPoint withType:nav_type simulation:isSimulation withBarriers:@""];
    
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnVoiceClick:(id)sender
{
    if(isSpeaking)
    {
        [[TTSPlayer shareInstance] pauseVideo];
        isSpeaking = NO;
        [self.BtnSpeak setImage:[UIImage imageNamed:@"Route-voice-on"] forState:UIControlStateNormal];
    }
    else
    {
        [self.BtnSpeak setImage:[UIImage imageNamed:@"Route-voice-off"] forState:UIControlStateNormal];
        isSpeaking = YES;
        if([TTSPlayer shareInstance].delegate == self)
        {
            [[TTSPlayer shareInstance] rePlayVideo];
        }
        else
        {
            [TTSPlayer shareInstance].delegate = self;
            [[TTSPlayer shareInstance] play:self.TXSpotContent.text playMode:TTS_DEFAULT];
        }
    }

}

- (void)ttsPlayEnd
{
    [self.BtnSpeak setImage:[UIImage imageNamed:@"Route-voice-on"] forState:UIControlStateNormal];
}


- (void)callBackToUI:(HttpBaseResponse *)response
{
    switch (response.cc_cmd_code)
    {
        case CC_DOWN_IMAGE_SPOT:
        {
            if(response.error_code == E_HTTPSUCCEES)
            {
                DwonImgResponse *res = (DwonImgResponse*)response;
                if(res.imgID == self.spotEntity.ID)
                {
                    UIImage *image = [[NetFileLoadManager sharedInstanced] loadImageByURL:self.spotEntity.SpotImgUrl withDelegate:self withID:self.spotEntity.ID withImgName:self.spotEntity.SpotImgName withCmdcode:CC_DOWN_IMAGE_SPOT];
                    if(image)
                    {
                        [self.IVSpotImg setImage:image];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    if([TTSPlayer shareInstance].delegate == self)
    {
        [[TTSPlayer shareInstance] stopVideo];
    }
    
    [[NetFileLoadManager sharedInstanced] cancelRequest:self];
    [_LbSpotName release];
    [_LbTourist release];
    [_LbBack release];
    [_BtnBack release];
    [_BtnTourist release];
    [_IVBg release];
    [_IVSpotImg release];
    [_LbBrief release];
    [_TXSpotContent release];
    [_BtnSpeak release];
    [_LbTouristDistance release];
    [_disValueLabel release];
    SAFERELEASE(loadingView)
    [super dealloc];
}
- (void)viewDidUnload {
    [self setLbSpotName:nil];
    [self setLbTourist:nil];
    [self setLbBack:nil];
    [self setBtnBack:nil];
    [self setBtnTourist:nil];
    [self setIVBg:nil];
    [self setIVSpotImg:nil];
    [self setLbBrief:nil];
    [self setTXSpotContent:nil];
    [self setBtnSpeak:nil];
    [self setLbTouristDistance:nil];
    [self setDisValueLabel:nil];
    [super viewDidUnload];
}
@end
