//
//  SenderUser.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-11-11.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    TEAM_USER_SENDER = 1,
    TEAM_USER_RECEIVE,
    TEAM_USER_TEAM,
}TEAM_USER_TYPE;
@interface TeamUser : NSObject
{
    NSString    *userID;
    NSString    *userName;
    TEAM_USER_TYPE userType;
}
@property(nonatomic,retain)NSString *userID;
@property(nonatomic,retain)NSString *userName;
@property(nonatomic,assign)TEAM_USER_TYPE userType;
@end
