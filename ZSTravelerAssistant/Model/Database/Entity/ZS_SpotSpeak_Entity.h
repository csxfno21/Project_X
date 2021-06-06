//
//  ZS_SpotSpeak_Entity.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-24.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZS_SpotSpeak_Entity : NSObject
{
    int  ID;
    NSString *SpotID;
    NSString *SpotName;
    NSString *SpeakSpotContent;
    NSString *SpotBuffer;
    NSString *SpotParentID;
}
@property(nonatomic,assign)int  ID;
@property(nonatomic,retain)NSString *SpotID;
@property(nonatomic,retain)NSString *SpotName;
@property(nonatomic,retain)NSString *SpeakSpotContent;
@property(nonatomic,retain)NSString *SpotBuffer;
@property(nonatomic,retain)NSString *SpotParentID;
@end
