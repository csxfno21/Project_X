//
//  ZS_SingleChat_Model.h
//  ZSTravelerAssistant
//
//  Created by szmap on 13-11-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZS_TeamSingleChat_entity.h"

@interface ZS_TeamSingleChat_Model : NSObject

-(NSArray*)quaryAllSingleChat;
-(ZS_TeamSingleChat_entity *)quraySingleChatByID:(int)ID;
-(BOOL)updateSingleChat:(NSArray*)data;
@end
