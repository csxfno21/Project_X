//
//  BaseNavController.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-7-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageManager.h"
@interface BaseNavController : UINavigationController<LanguageManagerDelegate>

- (void)updateLanguage:(id)sender;
@end
