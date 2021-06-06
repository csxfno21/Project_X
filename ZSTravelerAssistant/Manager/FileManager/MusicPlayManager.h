//
//  MusicPlayManager.h
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
typedef enum
{
    MUSIC_TYPE_ZSL = 0,
    MUSIC_TYPE_LGS,
    MUSIC_TYPE_MXL,
    MUSIC_TYPE_NAV,
    MUSIC_TYPE_TEST,
}MUSIC_TYPE;
@interface MusicPlayManager : NSObject<AVAudioPlayerDelegate>
{
    AVAudioPlayer *palyer;
    
}
@property(nonatomic,assign)MUSIC_TYPE currentType;
+(MusicPlayManager*)sharedInstanced;
+(void)freeInstance;
- (void)playMusicWithType:(MUSIC_TYPE)type;
- (void)stopPlay;
- (void)setPlayerMediaValue:(float)value;
- (float)getPlayerMediaValue;
- (void)rlayingBgMusic;
@end
