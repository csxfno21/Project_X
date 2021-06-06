 //
//  MusicPlayManager.m
//  ZSTravelerAssistant
//
//  Created by csxfno21 on 13-8-6.
//  Copyright (c) 2013年 company. All rights reserved.
//

#import "MusicPlayManager.h"
#import "Config.h"
static MusicPlayManager *manager;
@implementation MusicPlayManager

- (id)init
{
    if(self = [super init])
    {

        
    }
    return self;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (manager == nil)
        {
            manager = [super allocWithZone:zone];
            return manager;
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

+(MusicPlayManager*)sharedInstanced
{
    @synchronized(self)
    {
        if(manager == nil)
        {
            manager = [[MusicPlayManager alloc] init];
        }
    }
    return manager;
}

- (void)rlayingBgMusic
{
    if(palyer)
    {
        [self playMusicWithType:self.currentType];
    }
}
- (void)playMusicWithType:(MUSIC_TYPE)type
{
    self.currentType = type;
    if(![Config isPlayBgmusic])return;
    NSString *playName = @"navibgmusic";
    switch (type)
    {
        case MUSIC_TYPE_LGS:
        {
            playName = @"lgsbgmusic";
            break;
        }
        case MUSIC_TYPE_MXL:
        {
            playName = @"mxlbgmusic";
            break;
        }
        case MUSIC_TYPE_NAV:
        {
            playName = @"navibgmusic";
            break;
        }
        case MUSIC_TYPE_ZSL:
        {
            playName = @"zslbgmusic";
            break;
        }
        default:
            playName = @"navibgmusic";
            break;
    }
    [self stopPlay];
    SAFERELEASE(palyer)
    
    palyer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:playName ofType:@"mp3"]] error:nil];
    [palyer prepareToPlay];
    palyer.numberOfLoops = -1;
    palyer.delegate = self;
    [palyer play];
    [self setPlayerMediaValue:[Config getMediaValue] == -1 ? palyer.volume : [Config getMediaValue]];
}

- (void)stopPlay
{
    if(palyer && palyer.isPlaying)
    {
        [palyer stop];
        SAFERELEASE(palyer)
    }
}
- (void)setPlayerMediaValue:(float)value
{
    if(palyer && palyer.isPlaying)
    {
        [palyer setVolume:value];
    }
}
- (float)getPlayerMediaValue
{
    if (palyer)
    {
        return palyer.volume;
    }
    return 0.0;
}
#pragma mark - AVAudioPlayer Delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
}

+(void)freeInstance
{
    manager = nil;
}

- (void)dealloc
{
    SAFERELEASE(palyer)
    [super dealloc];
}
@end
