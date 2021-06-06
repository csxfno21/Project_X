//
//  RecomdLineTableView.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-7-31.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpManagerCenter.h"
#import "ASIUtil.h"
#import "RecomdLineCell.h"
#import "LoadingTableView.h"
#import "SpotRouteManager.h"
typedef enum
{
    LINETYPE_THEME = 0,
    LINETYPE_ROUTINE,
}LINETYPE;

@protocol RecomdLineTableViewDelegate <NSObject>

-(void)recomdLineItemDidSelectedMenuType:(int)index withLineType:(LINETYPE) lineType withType:(ROUTE_MENU_TYPE) type;

@end

@interface RecomdLineTableView : LoadingTableView<UITableViewDataSource,UITableViewDelegate,RecomdLineCellDelegate,HttpManagerDelegate>

{
    NSMutableDictionary *indexs;
    id<RecomdLineTableViewDelegate> recomdelegate;
    UIActivityIndicatorView *loadingView;
    int  lastDataCount;
}
- (void)setLoadingViewFram;
@property(nonatomic, retain)    NSArray     *data;
@property(nonatomic, assign)    LINETYPE    type;
@property(nonatomic, assign)    id<RecomdLineTableViewDelegate> recomdelegate;

@property(nonatomic, retain)    NSIndexPath *selectedtIndex;

@end
