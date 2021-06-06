//
//  AppDelegate.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-7-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "AppDelegate.h"
#import "LanguageManager.h"
#import "WeclomeController.h"
#import "RootViewController.h"
#import <AudioToolbox/AudioSession.h>
#import "Config.h"
#import "TeamManager.h"


#import "MusicPlayManager.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    NSLog(@"-------- %@",[[TeamManager sharedInstanced] encryptUseDES:@"0x5E%%801%%liangxiechao%%123456"]);
    [TeamManager sharedInstanced];
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    AudioSessionSetActive(true);
    AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume,
                                    volumeListenerCallback,
                                    (void *)(self)
                                    );
    
    [[LanguageManager sharedInstanced] setCurrentLanguage:CHINESE];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self showWelcomeController:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(reachabilityChanged:)
												 name: kReachabilityChangedNotification
											   object: nil];
    
    hostReach = [[Reachability reachabilityWithHostName:@"www.baidu.com"] retain];
	[hostReach startNotifier];
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    return YES;
}
void volumeListenerCallback (void *inClientData,AudioSessionPropertyID inID,UInt32 inDataSize, const void *inData)
{
    const float *volumePointer = inData;
    float volume = *volumePointer;
    [Config setMediaValue:volume];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MEDIAVALUE_CHAGE object:nil];
}
- (void)reachabilityChanged:(NSNotification *)note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	
	NetworkStatus status = [curReach currentReachabilityStatus];
    
	if (NotReachable == status)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NETUNCONNECT object:nil];
    }
    else
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_NETCONNECT object:nil];
    }
    
}
void UncaughtExceptionHandler(NSException *exception) {
    
    NSArray *arr = [exception callStackSymbols];
    
    NSString *reason = [exception reason];
    
    NSString *name = [exception name];
    NSLog(@"the name is %@,the reason is %@,the arr is %@",name,reason,[arr componentsJoinedByString:@"<br>"]);
    
    NSString *urlStr = [NSString stringWithFormat:@"mailto://csxfno21@126.com?subject= ZS_IOS bug report&body=Thanks to your help!<br><br><br>"
                        
                        "error detail:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                        
                        name,reason,[arr componentsJoinedByString:@"<br>"]];
    
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [[UIApplication sharedApplication] openURL:url];
    
}

- (void)showWelcomeController:(id)sender
{
    WeclomeController *controller = [[WeclomeController alloc] initWithNibName:@"WeclomeController" bundle:nil];
    self.window.rootViewController = controller;
    SAFERELEASE(controller)
}
- (void)showMainController:(id)sender
{
    RootViewController *rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    navController.navigationBarHidden = YES;
    self.window.rootViewController = navController;
    SAFERELEASE(rootViewController)
    SAFERELEASE(navController)
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[MapManager sharedInstanced] cleanLocation];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if([Config isPlayBgmusic])
    {
        [[MusicPlayManager sharedInstanced] rlayingBgMusic];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTIFICATION_APP_TO_FOREGROUND" object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
