//
//  InfoMainTableView.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-7-24.
//  Copyright (c) 2013年 company. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "HttpManagerCenter.h"
#import "ASIUtil.h"
#import "InfoMationManager.h"
#import "LoadingTableView.h"
typedef enum
{
    INFOTYPE_SEASON = 0,
    INFOTYPE_RECENTLY = 1,
    
}InfoType;
@protocol InfoMainTableViewDlegate <NSObject>

- (void)itemDidSelected:(int) index withType:(InfoType)type;

@end
@interface InfoMainTableView : LoadingTableView<UITableViewDataSource,UITableViewDelegate,HttpManagerDelegate>
{
    id<InfoMainTableViewDlegate> infodelegate;
    UIActivityIndicatorView *loadingView;
    int  lastDataCount;
}
@property(retain,nonatomic)NSArray *data;
@property(assign,nonatomic)InfoType type;
@property(assign,nonatomic)id<InfoMainTableViewDlegate> infodelegate;
@end

