//
//  TeamList_entity.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-11.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamList_entity : NSObject
{
    NSString *success; // 0 --1--
    NSString *teamID;
    NSString *teamName;
    NSString *teamCreator;
    NSString *onLineaPCount;
    NSString *teamCounts;
}
@property(nonatomic,retain)NSString *success;
@property(nonatomic,retain)NSString *teamID;
@property(nonatomic,retain)NSString *teamName;
@property(nonatomic,retain)NSString *teamCreator;
@property(nonatomic,retain)NSString *onLineaPCount;
@property(nonatomic,retain)NSString *teamCounts;
@end