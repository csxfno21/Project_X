//
//  ZS_Scenic_Buffer_entity.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-27.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZS_Scenic_Buffer_entity : NSObject
{

    int  ID;
    NSString *spotID;
    NSString *ScenicName;
    NSString *BufferIn;
    NSString *BufferOut;
    NSString *SpeakContentIn;
    NSString *SpeakContentOut;
}
@property(assign,nonatomic) int  ID;
@property(retain,nonatomic) NSString *spotID;
@property(retain,nonatomic) NSString *ScenicName;
@property(retain,nonatomic) NSString *BufferIn;
@property(retain,nonatomic) NSString *BufferOut;
@property(retain,nonatomic) NSString *SpeakContentIn;
@property(retain,nonatomic) NSString *SpeakContentOut;
@end
