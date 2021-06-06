//
//  BaseViewController.m
//  Tourism
//
//  Created by csxfno21 on 13-4-2.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netConnect:) name:NOTIFY_NETCONNECT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netUnConnect:) name:NOTIFY_NETUNCONNECT object:nil];
    [[LanguageManager sharedInstanced] registerLanugageNotification:self];
}


//网络重连
- (void)netConnect:(id)sender
{

}

//网络断开
- (void)netUnConnect:(id)sender
{

}
//语言切换
- (void)updateLanguage:(id)sender
{
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//	return  UIInterfaceOrientationIsPortrait(interfaceOrientation);
//}
#pragma mark
#pragma mark languageManagerDelegate
- (void)notifiChangelanguage
{
    [self updateLanguage:self];
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_NETCONNECT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_NETUNCONNECT object:nil];
    [[LanguageManager sharedInstanced] unRegisterLanugageNotification:self];
    [[ASIUtil sharedInstance] cancelRequest:self];
    [super dealloc];
}
@end
