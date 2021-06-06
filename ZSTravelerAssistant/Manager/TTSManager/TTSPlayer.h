//
//  TTSPlayer.h
//  TTSPlayer
//
//  Created by csxfno21 on 13-8-22.
//  Copyright (c) 2013年 company. All rights reserved.
//
typedef enum
{
    TTS_DEFAULT = 0,                //默认
    TTS_PLAY_JUMP_QUEUE ,           //插播
    TTS_PLAY_APPEND_QUEUE,          //加播
}TTS_PLAY_MODE;
@protocol TTSPlayerDelegate <NSObject>
- (void)ttsPlayEnd;
@optional
- (void)ttsPlayStart;
@end
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TTSEngine.h"
@interface TTSPlayer : NSObject<AVAudioPlayerDelegate>
{
    TTSEngine  *tts;
    AVAudioPlayer *audioPlayer;
    
    NSMutableArray *audiodata;
    NSMutableArray *currentPlayerStr;//  当前的播报词
    NSMutableArray *ttsEntityQueue;
    
    id<TTSPlayerDelegate>  delegate;
    
    BOOL  isOpen;
}
@property(assign,readonly,nonatomic)BOOL  isPlaying;
@property(assign,nonatomic)id<TTSPlayerDelegate>  delegate;
@property(assign,readonly,nonatomic)TTS_PLAY_MODE supportMode;
+(TTSPlayer*)shareInstance;
+(void)freeInstatnce;

/**
 * 合成播放一段新的播报词
 * str 必填项 长度为任意长度字节的字符串（建议不超过1024字节） mode 传入合成内容的播报方式
 */
- (void)play:(NSString*)str playMode:(TTS_PLAY_MODE)mode;

- (void)rePlayVideo;
- (void)pauseVideo;
- (void)stopVideo;
@end

/**
 * 播放结构
 * noPlayStr 未播放完的 字符串集合 audioData 多媒体字节 progress 播放进度
 */
@interface TTSPlayerEntity : NSObject
{
    NSMutableArray  *noPlayStr;
    NSMutableArray  *audioData;
    int      progress;
    
}
@property(strong,nonatomic)NSMutableArray *noPlayStr;
@property(strong,nonatomic)NSMutableArray  *audioData;
@property(assign,nonatomic)int  progress;
@end
