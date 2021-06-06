//
//  ZS_TeamChat_Model.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-11.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZS_TeamChat_entity.h"

@interface ZS_TeamChat_Model : NSObject

-(NSArray*)quaryAllTeamChat;
-(ZS_TeamChat_entity*)quaryTeamChatByID:(int)ID;
-(BOOL)updateTeamChat:(NSArray*)data;
@end
