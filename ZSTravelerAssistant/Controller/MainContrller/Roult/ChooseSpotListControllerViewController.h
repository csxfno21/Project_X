//
//  ChooseSpotListControllerViewController.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-23.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "BaseViewController.h"
#import "GMGridView.h"
#import "RouteSelfChoseSpotCell.h"
#import "RouteNavPopView.h"
#import "LoactionRegulation.h"


#import <CoreLocation/CoreLocation.h>

typedef enum
{
    PLAN_ROUTE_SELF_PLAN = 0,
    PLAN_ROUTE_SMART_PLAN,
}PLAN_ROUTE_TYPE;

@interface ChooseSpotListControllerViewController : BaseViewController<GMGridViewDataSource, GMGridViewSortingDelegate, GMGridViewActionDelegate,UIScrollViewDelegate,RouteNavPopViewDelegate>
{
    GMGridView *tableView;
    IBOutlet UIView *contentView;
    PLAN_ROUTE_TYPE planType;
    NSMutableArray *indexArray;
}

@property (retain, nonatomic) NSMutableArray *data;
@property (retain, nonatomic) IBOutlet UILabel *backTitle;
@property (retain, nonatomic) IBOutlet UIButton *earthBtn;
@property (retain, nonatomic) IBOutlet UILabel *earthLabel;


@end
