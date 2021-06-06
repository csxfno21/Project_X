//
//  CommonTableViewTwo.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-15.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AroundDetailTableCell.h"
#import "CommonTableViewDelegate.h"


@interface CommonTableViewTwo : UITableView<UITableViewDataSource,UITableViewDelegate,AroundDetailTableCellDelegate>
{
    NSMutableDictionary *openIndex;
    id<CommonTableViewTwoDelegate> commonDelegate;
}
@property (nonatomic, assign) id<CommonTableViewTwoDelegate> commonDelegate;
@property (nonatomic, assign) BUS_TYPE busType;
@property (nonatomic, retain) NSDictionary *data;
@end
