//
//  ZS_SingleChat_entity.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZS_TeamSingleChat_entity : NSObject
{
    int ID;
    NSString *TeamID;
    NSString *SenderID;
    NSString *ChatContent;
    NSString *ChatTime;
    NSString *ReceiveID;
    NSString *ReceiveName;
    int messageState;
    //发起人id ,name 接收
}
@property (nonatomic, assign) int ID;
@property (nonatomic, retain) NSString *TeamID;
@property (nonatomic, retain) NSString *SenderID;
@property (nonatomic, retain) NSString *ChatContent;
@property (nonatomic, retain) NSString *ChatTime;
@property (nonatomic, retain) NSString *ReceiveID;
@property (nonatomic, retain) NSString *ReceiveName;
@property (nonatomic, assign) int messageState;
@end
