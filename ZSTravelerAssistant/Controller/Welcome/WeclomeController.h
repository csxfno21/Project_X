//
//  WeclomeController.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-7-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "HttpManagerCenter.h"
#import "TableVersionManager.h"
#import "ApplicationVersionManager.h"
@interface WeclomeController : BaseViewController<HttpManagerDelegate,UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *weclomeImgView;
@end
