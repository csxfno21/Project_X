//
//  TTSPlayer.m
//  TTSPlayer
//
//  Created by csxfno21 on 13-8-22.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "TTSPlayer.h"
#import "Config.h"
#import <MediaPlayer/MediaPlayer.h>
#define  TTS_CUT_COUNT              40  //分段 标准
#define  TTS_CUT_FUHAO              5  //查找左右10个字 有没有符号

static TTSPlayer *player;
@implementation TTSPlayer
@synthesize delegate;
+(TTSPlayer*)shareInstance
{
    if (!player)
    {
        player = [[TTSPlayer alloc] init];
    }
    return player;
}

+(void)freeInstatnce
{
    [player release];
     player = nil;
}
- (id)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(synthsizeCompleted:) name:NOTIFICATION_MAV_READY object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTTSVoiceValue) name:NOTIFICATION_APP_TO_FOREGROUND object:nil];
        
        tts = [[TTSEngine alloc] init];
        _supportMode = TTS_DEFAULT;
        currentPlayerStr = [[NSMutableArray alloc] init];
        audiodata = [[NSMutableArray alloc] init];
        ttsEntityQueue = [[NSMutableArray alloc] init];
    }
    return self;
}
+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (player == nil)
        {
            player = [super allocWithZone:zone];
            return player;
        }
    }
    return nil;
}
- (id)retain
{
    return self;
}
- (id)autorelease
{
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_MAV_READY object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_APP_TO_FOREGROUND object:nil];
    
    if(audioPlayer)
    {
        [audioPlayer stop];
        [audioPlayer release];
    }
    [ttsEntityQueue release];
    [audiodata release];
    [currentPlayerStr release];
    [player release];
    delegate = nil;
    [super dealloc];
}

#pragma mark - 合成播放一段新的播报词
/**
 * 合成播放一段新的播报词
 * str 必填项 长度为任意长度字节的字符串（建议不超过1024字节） mode 传入合成内容的播报方式
 */
- (void)play:(NSString *)str playMode:(TTS_PLAY_MODE)mode
{
    @synchronized(currentPlayerStr)
    {
        _isPlaying = NO;
        //播报词为空 或长度为0的 直接 返回
        if(nil == str || [NSNull class] == str ||str.length == 0)
        {
            NSLog(@"TTS Error : String cannot be null or empty string");
            return;
        }
        
        if(mode != TTS_DEFAULT && mode != TTS_PLAY_APPEND_QUEUE && mode != TTS_PLAY_JUMP_QUEUE)mode = TTS_DEFAULT;
        _supportMode = mode;
        
        switch (_supportMode)
        {
            case TTS_DEFAULT://默认 丢掉当前播放内容
            {
                SAFERELEASE(tts)
                tts = [[TTSEngine alloc] init];
                [audiodata removeAllObjects];
                [currentPlayerStr removeAllObjects];
                if(audioPlayer && audioPlayer.isPlaying)
                {
                    [audioPlayer stop];
                    [audioPlayer release];
                    audioPlayer = nil;
                }
                [self synthsize:str];
                break;
            }
            case TTS_PLAY_APPEND_QUEUE://追加播放
            {
                if(currentPlayerStr.count == 0 && audiodata.count == 0 && audioPlayer == nil)//没有播报 或 播报结束
                {
                    //直接开始 播报
                    SAFERELEASE(tts)
                    tts = [[TTSEngine alloc] init];
                    [self synthsize:str];
                }
                else
                {
                    //之前的没有播报完
                    TTSPlayerEntity *entity = [[TTSPlayerEntity alloc] init];
                    [entity.noPlayStr addObjectsFromArray:[self cutStr:str]];
                    [ttsEntityQueue addObject:entity];
                    [entity release];
                }
                break;
            }
            case TTS_PLAY_JUMP_QUEUE:
            {
                if(currentPlayerStr.count == 0 && audiodata.count == 0 && audioPlayer == nil)//没有播报 或 播报结束
                {
                    //直接开始 播报
//                    SAFERELEASE(tts)
                    if(!tts)
                    tts = [[TTSEngine alloc] init];
                    [self synthsize:str];
                }
                else
                {
                    //之前的没有播报完, 将当前未播报完的 添加到队列并停止播报,播报新的内容
                    if(!tts)
                    {
//                        SAFERELEASE(tts)
                        tts = [[TTSEngine alloc] init];
                    }
                    
                    TTSPlayerEntity *entity = [[TTSPlayerEntity alloc] init];
                    
                    if(audiodata.count > 0)
                        [entity.audioData addObjectsFromArray:audiodata];
                    if(currentPlayerStr.count > 0)
                        [entity.noPlayStr addObjectsFromArray:currentPlayerStr];
                    
                    if(audioPlayer && audioPlayer.isPlaying)
                    {
                        entity.progress = audioPlayer.currentTime;
                        [audioPlayer stop];
                        [audioPlayer release];
                        audioPlayer = nil;
                    }
                    [ttsEntityQueue addObject:entity];
                    [entity release];
                    [audiodata removeAllObjects];
                    [currentPlayerStr removeAllObjects];
                    [self synthsize:str];
                }
                break;
            }
            default:
                break;
        }
        
    }
}
- (void)synthsize:(NSString*)str
{
    isOpen = YES;
    [currentPlayerStr addObjectsFromArray:[self cutStr:str]];
    if(currentPlayerStr.count > 0)
    {
        SAFERELEASE(tts)
        tts = [[TTSEngine alloc] init];
        [tts startSynthsizeInBackground:[currentPlayerStr objectAtIndex:0]];
    }
}

/**
 * 分段
 *
 */
- (NSArray*)cutStr:(NSString*)str
{
    NSMutableArray *array = [NSMutableArray array];
    
    while (str.length > 0)
    {
        //先判断长度是否大于切断长度
        if (str.length > TTS_CUT_COUNT)
        {
            //查看左右范围内是否有符号
            NSString *left = [str substringWithRange:NSMakeRange(TTS_CUT_COUNT - TTS_CUT_FUHAO, TTS_CUT_FUHAO)];
            NSRange range1 = [left rangeOfString:@","];
            NSRange range2 = [left rangeOfString:@"。"];
            NSRange range3 = [left rangeOfString:@"，"];
            NSRange range4 = [left rangeOfString:@"."];
            NSRange range5 = [left rangeOfString:@"!"];
            NSRange range6 = [left rangeOfString:@"！"];
            if (range1.location != NSNotFound)
            {
                NSString* text = [str substringToIndex:TTS_CUT_COUNT - TTS_CUT_FUHAO + range1.location];
                str = [str substringFromIndex:text.length];
                [array addObject:text];
            }
            else if (range2.location != NSNotFound)
            {
                NSString* text = [str substringToIndex:TTS_CUT_COUNT - TTS_CUT_FUHAO + range2.location];
                str = [str substringFromIndex:text.length];
                [array addObject:text];
            }
            else if (range3.location != NSNotFound)
            {
                NSString* text = [str substringToIndex:TTS_CUT_COUNT - TTS_CUT_FUHAO + range3.location];
                str = [str substringFromIndex:text.length];
                [array addObject:text];
            }
            else if (range4.location != NSNotFound)
            {
                NSString* text = [str substringToIndex:TTS_CUT_COUNT - TTS_CUT_FUHAO + range4.location];
                str = [str substringFromIndex:text.length];
                [array addObject:text];
            }
            else if (range5.location != NSNotFound)
            {
                NSString* text = [str substringToIndex:TTS_CUT_COUNT - TTS_CUT_FUHAO + range5.location];
                str = [str substringFromIndex:text.length];
                [array addObject:text];
            }
            else if (range6.location != NSNotFound)
            {
                NSString* text = [str substringToIndex:TTS_CUT_COUNT - TTS_CUT_FUHAO + range6.location];
                str = [str substringFromIndex:text.length];
                [array addObject:text];
            }
            else
            {
                //判断后面 是否有符号
                if (str.length > TTS_CUT_FUHAO + TTS_CUT_COUNT)
                {
                    NSString *right = @"";
                    if(str.length > TTS_CUT_COUNT + TTS_CUT_FUHAO * 2)
                    {
                        right = [str substringWithRange:NSMakeRange(TTS_CUT_COUNT + TTS_CUT_FUHAO, TTS_CUT_FUHAO)];
                    }
                    else
                    {
                        right = str;
                    }
                    
                    NSRange rangeR1 = [right rangeOfString:@","];
                    NSRange rangeR2 = [right rangeOfString:@"。"];
                    NSRange rangeR3 = [right rangeOfString:@"，"];
                    NSRange rangeR4 = [right rangeOfString:@"."];
                    NSRange rangeR5 = [right rangeOfString:@"!"];
                    NSRange rangeR6 = [right rangeOfString:@"！"];
                    if (rangeR1.location != NSNotFound)
                    {
                        NSString* text = @"";
                        if (str.length <= TTS_CUT_COUNT + TTS_CUT_FUHAO + rangeR1.location)
                        {
                            text = str;
                        }
                        else
                        {
                            text = [str substringToIndex:TTS_CUT_COUNT + TTS_CUT_FUHAO + rangeR1.location];
                        }
                        str = [str substringFromIndex:text.length];
                        [array addObject:text];
                    }
                    else if (rangeR2.location != NSNotFound)
                    {
                        NSString* text = @"";
                        if (str.length <= TTS_CUT_COUNT + TTS_CUT_FUHAO + rangeR2.location)
                        {
                            text = str;
                        }
                        else
                        {
                            text = [str substringToIndex:TTS_CUT_COUNT + TTS_CUT_FUHAO + rangeR2.location];
                        }
                        str = [str substringFromIndex:text.length];
                        [array addObject:text];
                    }
                    else if (rangeR3.location != NSNotFound)
                    {
                        NSString* text = @"";
                        if (str.length <= TTS_CUT_COUNT + TTS_CUT_FUHAO + rangeR3.location)
                        {
                            text = str;
                        }
                        else
                        {
                            text = [str substringToIndex:TTS_CUT_COUNT + TTS_CUT_FUHAO + rangeR3.location];
                        }
                        str = [str substringFromIndex:text.length];
                        [array addObject:text];
                    }
                    else if (rangeR4.location != NSNotFound)
                    {
                        NSString* text = @"";
                        if (str.length <= TTS_CUT_COUNT + TTS_CUT_FUHAO + rangeR4.location)
                        {
                            text = str;
                        }
                        else
                        {
                            text = [str substringToIndex:TTS_CUT_COUNT + TTS_CUT_FUHAO + rangeR4.location];
                        }
                        str = [str substringFromIndex:text.length];
                        [array addObject:text];
                    }
                    else if (rangeR5.location != NSNotFound)
                    {
                        NSString* text = @"";
                        if (str.length <= TTS_CUT_COUNT + TTS_CUT_FUHAO + rangeR5.location)
                        {
                            text = str;
                        }
                        else
                        {
                            text = [str substringToIndex:TTS_CUT_COUNT + TTS_CUT_FUHAO + rangeR5.location];
                        }
                        str = [str substringFromIndex:text.length];
                        [array addObject:text];
                    }
                    else if (rangeR6.location != NSNotFound)
                    {
                        NSString* text = @"";
                        if (str.length <= TTS_CUT_COUNT + TTS_CUT_FUHAO + rangeR6.location)
                        {
                            text = str;
                        }
                        else
                        {
                            text = [str substringToIndex:TTS_CUT_COUNT + TTS_CUT_FUHAO + rangeR6.location];
                        }
                        str = [str substringFromIndex:text.length];
                        [array addObject:text];
                    }
                    else
                    {
                        NSString* text = [str substringToIndex:TTS_CUT_COUNT];
                        str = [str substringFromIndex:text.length];
                        [array addObject:text];
                    }
                }
                else
                {
                    NSString* text = [str substringToIndex:TTS_CUT_COUNT];
                    str = [str substringFromIndex:text.length];
                    [array addObject:text];
                }
            }
        }
        else
        {
            [array addObject:str];
//            str = @"";
            break;
        }
    }
    
//    for (NSString *str in array)
//    {
//        NSLog(@"------------ %@",str);
//    }
//    if(str.length > TTS_CUT_COUNT)
//    {
//        int cutCount = str.length / TTS_CUT_COUNT;
//        for (int i = 1; i <= cutCount ; i++)
//        {
//            [array addObject:[str substringWithRange:NSMakeRange((i - 1) * TTS_CUT_COUNT, TTS_CUT_COUNT)]];
//        }
//        [array addObject:[str substringFromIndex:cutCount * TTS_CUT_COUNT]];
//    }
//    else
//    {
//        [array addObject:str];
//    }
    return array;
}
/**
 *  synthsizeCompleted 段落合成完毕
 *
 */
- (void)synthsizeCompleted:(NSNotification*)notification
{
    @synchronized(currentPlayerStr)
    {
        if (currentPlayerStr.count > 0)
        {
            NSString *cnText = [currentPlayerStr objectAtIndex:0];
            if (![cnText isEqualToString:notification.object])
            {
                return;
            }
            else
            {
                [currentPlayerStr removeObjectAtIndex:0];
            }
        }
        if (!isOpen)
        {
            return;
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0];
        NSString *filePath = [cachesDirectory stringByAppendingPathComponent:@"Output.wav"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            if (delegate && [delegate respondsToSelector:@selector(ttsPlayStart)])
            {
                [delegate ttsPlayStart];
            }
            //合成好的 天假到 等待播放的队列
            [audiodata addObject:[NSData dataWithContentsOfFile:filePath]];
            
            if (!audioPlayer)
            {
                _isPlaying = YES;
                audioPlayer = [[AVAudioPlayer alloc] initWithData:[audiodata objectAtIndex:0] error:nil];
                audioPlayer.delegate = self;
                [audioPlayer prepareToPlay];
                [audioPlayer play];
            }
        }
        
        if(currentPlayerStr.count > 0)
        {
            if (!tts)
            {
              tts = [[TTSEngine alloc] init];  
            }
            [tts startSynthsizeInBackground:[currentPlayerStr objectAtIndex:0]];
        }

    }
}

- (void)nextTTS
{
    if(ttsEntityQueue.count > 0)
    {
        TTSPlayerEntity *entity = [ttsEntityQueue objectAtIndex:0];
        [currentPlayerStr removeAllObjects];
        if(entity.noPlayStr.count > 0)
            [currentPlayerStr addObjectsFromArray:entity.noPlayStr];
        [audiodata removeAllObjects];
        if(entity.audioData.count >0)
            [audiodata addObjectsFromArray:entity.audioData];
        
        if(audiodata.count > 0)
        {
            if(audioPlayer)
            {
                [audioPlayer stop];
                [audioPlayer release];
            }
            audioPlayer = [[AVAudioPlayer alloc] initWithData:[audiodata objectAtIndex:0] error:nil];
            audioPlayer.delegate = self;
            if(entity.progress != 0 )
            {
                audioPlayer.currentTime = entity.progress;
                entity.progress = 0;
            }
                
            [audioPlayer prepareToPlay];
            [audioPlayer play];
        }
        else if(currentPlayerStr.count > 0)
        {
            if (!tts)
            {
              tts = [[TTSEngine alloc] init];  
            }
            [tts startSynthsizeInBackground:[currentPlayerStr objectAtIndex:0]];
        }
        
        [ttsEntityQueue removeObjectAtIndex:0];
    }
    else
    {
        //播放完毕
        if (delegate && [delegate respondsToSelector:@selector(ttsPlayEnd)])
        {
            [delegate ttsPlayEnd];
            delegate = nil;
        }
        isOpen = NO;
        _isPlaying = NO;
    }
}
- (void)setTTSVoiceValue
{
    if(audioPlayer && _isPlaying)
    {
        [self rePlayVideo];
    }
}
- (void)rePlayVideo
{
    if (!audioPlayer || audioPlayer.isPlaying)
    {
        return;
    }
    [audioPlayer play];
    _isPlaying = YES;
}
- (void)pauseVideo
{
    if (!audioPlayer || !audioPlayer.isPlaying)
    {
        return;
    }
     _isPlaying = NO;
    [audioPlayer pause];
}
- (void)stopVideo
{
    [tts stopSynthsize];
    isOpen = NO;
    [audiodata removeAllObjects];
    [currentPlayerStr removeAllObjects];
    [ttsEntityQueue removeAllObjects];
    
    if (audioPlayer)
    {
        [audioPlayer stop];
        [audioPlayer release];
        audioPlayer = nil;
    }
    delegate = nil;
    _isPlaying = NO;
}
#pragma mark - audio play delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(audiodata.count > 0)
    [audiodata removeObjectAtIndex:0];
    if(audiodata.count > 0 && flag)
    {
        [audioPlayer stop];
        SAFERELEASE(audioPlayer)
        audioPlayer = [[AVAudioPlayer alloc] initWithData:[audiodata objectAtIndex:0] error:nil];
        audioPlayer.delegate = self;
        [audioPlayer prepareToPlay];
        [audioPlayer play];
    }
    else
    {
        [audioPlayer stop];
        SAFERELEASE(audioPlayer)
        if(currentPlayerStr.count == 0)
        {
            //当前所有段落播报完毕
            [self nextTTS];
        }
    }
}

@end





#pragma mark - TTSPlayerEntity
@implementation TTSPlayerEntity
@synthesize audioData = audioData;
@synthesize progress;
@synthesize noPlayStr = noPlayStr;
/**
 *
 * 初始化 结构  path 媒体路径
 */
- (id)init
{
    if (self = [super init])
    {
        audioData = [[NSMutableArray alloc] init];
        noPlayStr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [noPlayStr release];
    progress = 0;
    audioData = nil;
    [super dealloc];
}
@end
