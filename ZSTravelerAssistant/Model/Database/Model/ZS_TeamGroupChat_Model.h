//
//  ZS_GroupChat_Model.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZS_TeamGroupChat_entity.h"

@interface ZS_TeamGroupChat_Model : NSObject

-(NSArray*)quaryAllGroupChat;
-(ZS_TeamGroupChat_entity*)quaryGropuChatByID:(int)ID;
-(BOOL)updateGroupChat:(NSArray*)data;
@end
