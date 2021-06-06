//
//  InfoTrafficTableView.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-26.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpManagerCenter.h"
#import "ASIUtil.h"
#import "LoadingTableView.h"
#import "TrafficManager.h"
typedef enum
{
    TRAFFICTYPE_BUS = 0,
    TRAFFICTYPE_SIGHTSEEING ,
}TRAFFICTYPE;
@protocol InfoTrafficTableViewDelegate <NSObject>

- (void)cellDidSelected:(int) index withType:(TRAFFICTYPE) type;

@end

@interface InfoTrafficTableView : LoadingTableView<UITableViewDataSource,UITableViewDelegate,HttpManagerDelegate>
{
    UIActivityIndicatorView *loadingView;
    id<InfoTrafficTableViewDelegate>  trafficdelegate;
    int  lastDataCount;
}
@property (nonatomic, retain) NSArray *trafficData;
@property (assign, nonatomic) TRAFFICTYPE type;
@property (assign, nonatomic) id<InfoTrafficTableViewDelegate> trafficdelegate;
@end
