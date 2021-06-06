//
//  ZS_GroupChat_entity.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZS_TeamGroupChat_entity : NSObject
{
    int ID;
    NSString *TeamID;
    NSString *SenderID;
    NSString *SenderName;
    NSString *ChatContent;
    NSString *ChatTime;
    //团队ID  senderid/name
    int      messageState;
}
@property (nonatomic, assign) int ID;
@property (nonatomic, retain) NSString *TeamID;
@property (nonatomic, retain) NSString *SenderID;
@property (nonatomic, retain) NSString *SenderName;
@property (nonatomic, retain) NSString *ChatContent;
@property (nonatomic, retain) NSString *ChatTime;
@property (nonatomic, assign) int      messageState;
@end

