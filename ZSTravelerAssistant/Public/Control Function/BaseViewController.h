//
//  BaseViewController.h
//  Tourism
//
//  Created by csxfno21 on 13-4-2.
//  Copyright (c) 2013年 logic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpManagerCenter.h"
#import "LanguageManager.h"
@interface BaseViewController : UIViewController<LanguageManagerDelegate>

- (void)updateLanguage:(id)sender;
- (void)netConnect:(id)sender;
- (void)netUnConnect:(id)sender;
@end

