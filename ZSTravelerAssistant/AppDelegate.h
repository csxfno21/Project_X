//
//  AppDelegate.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-7-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    Reachability  *hostReach;
}
@property (strong, nonatomic) UIWindow *window;
- (void)showMainController:(id)sender;
@end
