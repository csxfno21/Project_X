//
//  WeclomeController.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-7-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "WeclomeController.h"
#import "TTSPlayer.h"
#define MAX_REQUEST_COUN                1
#define WAITTIME                        2
@interface WeclomeController ()
{
    int requestCount ;
    
    int waitTime;
}
@end

@implementation WeclomeController

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
    
    [[TTSPlayer shareInstance] play:[Language stringWithName:WECLOME_SPEAK] playMode:TTS_DEFAULT];
    
    [[ApplicationVersionManager sharedInstance] requestCheckVersion:self];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeRunOver) userInfo:nil repeats:NO];
    if (iPhone5)
    {
        self.weclomeImgView.image = [UIImage imageNamed:@"Default-568h.png"];//Default-568h@2x.png  weclome
    }else
    {
        self.weclomeImgView.image = [UIImage imageNamed:@"Default.png"];//Default@2x.png  weclome4s
    }
}

- (void)timeRunOver
{
    waitTime = WAITTIME;
    [self showMainViewController];
}
- (void)showMainViewController
{
    if(requestCount < MAX_REQUEST_COUN || waitTime != WAITTIME)
    {
        return;
    }
    AppDelegate * appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate showMainController:nil];
}



- (void)callBackToUI:(HttpBaseResponse *)response
{
    
    switch (response.cc_cmd_code)
    {
        case CC_CHECK_TABLE_VERSION:
        {
            requestCount++;
            [self showMainViewController];
            break;
        }
        case CC_VERSION_CHECK:
        {
            CheckVersionResponse *resPonse = (CheckVersionResponse*)response;
            if(resPonse.error_code == E_HTTPSUCCEES)
            {
                if(resPonse.version == VERSION_MUST_UPDATE)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[Language stringWithName:CHECK_VERSION] message:[NSString stringWithFormat:[Language stringWithName:MUST_UPDATE],resPonse.currentVersion] delegate:self cancelButtonTitle:[Language stringWithName:CANCEL] otherButtonTitles:[Language stringWithName:CONFIRM], nil];
                    alertView.tag = 1000;
                    [alertView show];
                    SAFERELEASE(alertView)
                }
                else if(resPonse.version == VERSION_UPDATE)
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[Language stringWithName:CHECK_VERSION] message:[NSString stringWithFormat:[Language stringWithName:NEED_UPDATE],resPonse.currentVersion] delegate:self cancelButtonTitle:[Language stringWithName:CANCEL] otherButtonTitles:[Language stringWithName:CONFIRM], nil];
                    alertView.tag = 1001;
                    [alertView show];
                    SAFERELEASE(alertView)
                }
                else
                    [[TableVersionManager sharedInstance] requestCheckVersion:self];
            }
            else
            {
              [[TableVersionManager sharedInstance] requestCheckVersion:self];
            }
            break;
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        // 下载
    }
    else
    {
        if (alertView.tag == 1001)
        {
            [[TableVersionManager sharedInstance] requestCheckVersion:self];
        }
        else
        {
            //必须下载，但是没有点击下载
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [_weclomeImgView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWeclomeImgView:nil];
    [super viewDidUnload];
}
@end
