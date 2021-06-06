//
//  TeamMatesInfo_entity.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-11.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeamMatesInfo_entity : NSObject
{
    NSString *ID;
    NSString *nickName;
    NSString *sex;
    NSString *where;
    NSString *longitude;
    NSString *latitude;
    NSString *state;
}
@property(nonatomic,retain) NSString *ID;
@property(nonatomic,retain) NSString *nickName;
@property(nonatomic,retain) NSString *sex;
@property(nonatomic,retain) NSString *where;
@property(nonatomic,retain) NSString *longitude;
@property(nonatomic,retain) NSString *latitude;
@property(nonatomic,retain) NSString *state;
@end
