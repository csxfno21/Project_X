//
//  CommonTableViewOne.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-8-14.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AroundDetailTableCell.h"
#import "CommonTableViewDelegate.h"
@interface CommonTableViewOne : UITableView<UITableViewDataSource,UITableViewDelegate,AroundDetailTableCellDelegate>
{
    NSInteger openIndex;
    id<CommonTableViewDelegate> commonDelegate;
}
@property(nonatomic,assign)id<CommonTableViewDelegate> commonDelegate;
@property(nonatomic, retain)    NSArray     *data;

@end