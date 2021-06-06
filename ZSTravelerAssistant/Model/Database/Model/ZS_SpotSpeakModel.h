//
//  ZS_SpotSpeakModel.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-24.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZS_SpotSpeak_Entity.h"
@interface ZS_SpotSpeakModel : NSObject

- (BOOL)updateSpeakInfo:(NSArray*)data;
- (NSArray *)getAllSpotSpeak;
- (NSArray *)getSpotSpeakByType:(SCENIC_TYPE)type;
- (NSString *)getSpeakSpotContent:(int)SpotID;
@end
