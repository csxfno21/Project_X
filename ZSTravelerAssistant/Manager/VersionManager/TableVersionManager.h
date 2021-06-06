//
//  TableVersionManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-9.
//  Copyright (c) 2013年 company. All rights reserved.
//

/**
 * 本地数据版本管理类
 *
 */
#import "BaseRequestManager.h"
#import "DataAccessManager.h"

@interface TableVersionManager : BaseRequestManager<HttpManagerDelegate>
{

    NSMutableDictionary *needUpdateTables;
}
+ (TableVersionManager*)sharedInstance;

- (void)requestCheckVersion:(id)UIDelegate;



@property(assign,nonatomic,readonly)BOOL checkTableVersionSuccess;//查看当前检查是否成功
@end
